namespace GKBCustomization.GKBCustomization;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;
using Microsoft.Purchases.Vendor;

/// <summary>
/// Codeunit Auto Apply After Consolidation (ID 50142).
/// Automatically applies consolidated payment lines to vendor invoices AND CREDIT MEMOS using BC standard mechanism.
/// 
/// This codeunit simulates the "Set Applies-to ID" button that users click manually in "Apply Entries" screen.
/// It updates BOTH Table 81 (Gen. Journal Line) and Table 25 (Vendor Ledger Entry) with matching Applies-to ID.
/// This ensures BC posting engine creates correct DVLE entries (one per applied invoice/credit memo).
/// </summary>

//Gkblabs_Tv_03/12/25 - Updated to support Credit Memos
codeunit 50142 "Auto Apply After Consolidation"
{
    /// <summary>
    /// Main procedure: Auto-apply consolidated payment to specific invoice OR credit memo.
    /// Call this after consolidation for each payment line.
    /// Uses Applies-to Doc. No. from payment line to find and link the invoice/credit memo.
    /// ENHANCED: Now with diagnostic logging for troubleshooting.
    /// </summary>
    procedure AutoApplyConsolidated(var GenJnlLine: Record "Gen. Journal Line"): Integer
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        ApplyID: Code[50];
        AppliesToDocNo: Code[20];
        AppliedCount: Integer;
        DiagnosticMsg: Text;
        FoundCount: Integer;
    begin
        // Validate payment line
        if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor then
            exit(0);
        if GenJnlLine."Account No." = '' then
            exit(0);
        if GenJnlLine.Amount = 0 then
            exit(0);

        // Get Applies-to Doc. No. from payment line
        AppliesToDocNo := GenJnlLine."Applies-to Doc. No.";
        if AppliesToDocNo = '' then
            exit(0); // No invoice/credit memo specified - nothing to apply

        // Generate unique Applies-to ID (use payment Document No.)
        ApplyID := GenJnlLine."Document No.";
        if ApplyID = '' then
            exit(0);

        // Find the specific invoice OR credit memo in Vendor Ledger Entry (Table 25)
        VendorLedgEntry.Reset();
        VendorLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
        VendorLedgEntry.SetRange("Document No.", AppliesToDocNo);
        VendorLedgEntry.SetRange(Open, true);
        // CRITICAL FIX: Include both Invoice AND Credit Memo
        // VendorLedgEntry.SetFilter("Document Type", '%1|%2',
        //     VendorLedgEntry."Document Type"::Invoice,
        //     VendorLedgEntry."Document Type"::"Credit Memo");

        // Count how many we found
        FoundCount := VendorLedgEntry.Count();

        if FoundCount = 0 then begin
            // Try without the Open filter to see if document exists but is closed
            VendorLedgEntry.Reset();
            VendorLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
            VendorLedgEntry.SetRange("Document No.", AppliesToDocNo);
            // VendorLedgEntry.SetFilter("Document Type", '%1|%2',
            //     VendorLedgEntry."Document Type"::Invoice,
            //     VendorLedgEntry."Document Type"::"Credit Memo");

            if VendorLedgEntry.FindFirst() then
                Message('Document %1 found but is CLOSED (Open=%2).\nCannot apply closed documents.',
                    AppliesToDocNo, VendorLedgEntry.Open)
            else
                Message('Document %1 NOT FOUND in Vendor Ledger for vendor %2.\n\nPossible reasons:\n1. Document not posted yet\n2. Wrong document number\n3. Document is for a different vendor',
                    AppliesToDocNo, GenJnlLine."Account No.");
            exit(0);
        end;

        if VendorLedgEntry.FindSet(true) then begin
            repeat
                // CRITICAL: Must CalcFields BEFORE accessing Remaining Amount
                VendorLedgEntry.CalcFields("Remaining Amount");

                // Build diagnostic message
                DiagnosticMsg := StrSubstNo('✓ Applying: %1 %2, Remaining: %3, Open: %4',
                    VendorLedgEntry."Document Type",
                    VendorLedgEntry."Document No.",
                    VendorLedgEntry."Remaining Amount",
                    VendorLedgEntry.Open);

                // Set Applies-to ID on the invoice/credit memo (mimics "Set Applies-to ID" button)
                VendorLedgEntry."Applies-to ID" := ApplyID;

                // CRITICAL FIX: Use Validate to trigger BC's application logic
                // This ensures the Appln. Amount to Apply is calculated correctly
                // For both invoices and credit memos
                VendorLedgEntry.Validate("Amount to Apply", VendorLedgEntry."Remaining Amount");

                if VendorLedgEntry.Modify(true) then begin
                    AppliedCount += 1;
                    // Show success for first document
                    if AppliedCount = 1 then
                        Message(DiagnosticMsg);
                end;
            until VendorLedgEntry.Next() = 0;
        end;

        // Set Applies-to ID on the payment line too (critical for BC posting)
        if AppliedCount > 0 then begin
            GenJnlLine."Applies-to ID" := ApplyID;
            GenJnlLine.Modify(true);
        end;

        exit(AppliedCount);
    end;

    /// <summary>
    /// Auto-apply all payment lines in a batch.
    /// For consolidated lines (no Applies-to Doc. No.), applies to ALL open invoices/credit memos for that vendor.
    /// For non-consolidated lines (has Applies-to Doc. No.), applies to specific invoice/credit memo only.
    /// This is called automatically after consolidation.
    /// </summary>
    procedure AutoApplyBatch(TemplateNameParam: Code[10]; BatchNameParam: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        AppliedCount: Integer;
        TotalApplied: Integer;
        ProcessedLines: Integer;
        LineCount: Integer;
    begin
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetRange("Journal Batch Name", BatchNameParam);
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);

        LineCount := GenJnlLine.Count();
        if LineCount = 0 then begin
            Message('No vendor payment lines found in batch %1 to apply.', BatchNameParam);
            exit(0);
        end;

        if GenJnlLine.FindSet(true) then begin
            repeat
                // Check if line has specific Applies-to Doc. No.
                if GenJnlLine."Applies-to Doc. No." <> '' then begin
                    // Payment line targets a specific invoice/credit memo - auto-apply to that document
                    AppliedCount := AutoApplyConsolidated(GenJnlLine);
                end else begin
                    // ONLY auto-apply if user already set Applies-to ID
                    // (i.e., they used Apply Entries -> Set Applies-to ID before moving)
                    if GenJnlLine."Applies-to ID" <> '' then begin
                        // Update Amount to Apply ONLY for invoices/credit memos that already have this Applies-to ID
                        AppliedCount := SetAppliesToIDInVendorLedger(GenJnlLine);
                    end else begin
                        // Do NOT auto-apply to all open documents automatically
                        // User must use Apply Entries to select specific invoices/credit memos
                        AppliedCount := 0;
                    end;
                end;

                if AppliedCount > 0 then begin
                    TotalApplied += AppliedCount;
                    ProcessedLines += 1;
                end;
            until GenJnlLine.Next() = 0;
        end;

        if TotalApplied > 0 then
            Message('Auto-apply complete!\n\nProcessed: %1 payment line(s)\nApplied to: %2 user-selected document(s)\n\nReady to post!', ProcessedLines, TotalApplied)
        else
            Message('No documents were auto-applied.\n\nFor consolidated lines:\n1. Click "Apply Entries"\n2. Select specific invoices/credit memos\n3. Click "Set Applies-to ID"\n4. Then post');

        exit(TotalApplied);
    end;

    /// <summary>
    /// Updates Amount to Apply ONLY for invoices/credit memos that ALREADY have Applies-to ID set.
    /// This ensures only user-selected documents (from Apply Entries) are updated.
    /// Does NOT automatically apply to all open documents.
    /// CRITICAL: Properly handles both invoices (negative remaining) and credit memos (positive remaining).
    /// </summary>
    local procedure SetAppliesToIDInVendorLedger(var GenJnlLineRec: Record "Gen. Journal Line"): Integer
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        ApplyID: Code[50];
        VendorNo: Code[20];
        AppliedCount: Integer;
    begin
        ApplyID := GenJnlLineRec."Applies-to ID";
        VendorNo := GenJnlLineRec."Account No.";

        if (ApplyID = '') or (VendorNo = '') then
            exit(0);

        // Find ONLY invoices/credit memos that ALREADY have this Applies-to ID (user-selected)
        VendorLedgEntry.Reset();
        VendorLedgEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgEntry.SetRange("Applies-to ID", ApplyID);
        VendorLedgEntry.SetRange(Open, true);
        // CRITICAL FIX: Include both Invoice AND Credit Memo
        // VendorLedgEntry.SetFilter("Document Type", '%1|%2',
        //     VendorLedgEntry."Document Type"::Invoice,
        //     VendorLedgEntry."Document Type"::"Credit Memo");

        if VendorLedgEntry.FindSet(true) then begin
            repeat
                VendorLedgEntry.CalcFields("Remaining Amount");
                // Only update Amount to Apply if not already set correctly
                // For invoices: Remaining Amount is negative (e.g., -1,498.09)
                // For credit memos: Remaining Amount is positive (e.g., 400.00)
                // Use Validate to trigger BC's application logic
                if VendorLedgEntry."Amount to Apply" <> VendorLedgEntry."Remaining Amount" then begin
                    VendorLedgEntry.Validate("Amount to Apply", VendorLedgEntry."Remaining Amount");
                    VendorLedgEntry.Modify(true);
                    AppliedCount += 1;
                end;
            until VendorLedgEntry.Next() = 0;
        end;

        // Ensure payment line has Applies-to ID
        if AppliedCount > 0 then begin
            GenJnlLineRec.Validate("Applies-to ID", ApplyID);
            GenJnlLineRec.Modify(true);
        end;

        exit(AppliedCount);
    end;

    /// <summary>
    /// Auto-apply payment to ALL open invoices/credit memos for the vendor.
    /// Use this for consolidated lines with multiple documents.
    /// Sets Applies-to ID in BOTH Journal Line and Vendor Ledger Entry.
    /// NOTE: This is NOT called automatically - only use if explicitly needed.
    /// </summary>
    local procedure AutoApplyToAllOpenInvoices(var GenJnlLine: Record "Gen. Journal Line"): Integer
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        ApplyID: Code[50];
        AppliedCount: Integer;
    begin
        // Validate payment line
        if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor then
            exit(0);
        if GenJnlLine."Account No." = '' then
            exit(0);
        if GenJnlLine.Amount = 0 then
            exit(0);

        // Generate unique Applies-to ID (use payment Document No.)
        ApplyID := GenJnlLine."Document No.";
        if ApplyID = '' then
            exit(0);

        // Find ALL open invoices/credit memos for this vendor
        VendorLedgEntry.Reset();
        VendorLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
        VendorLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
        VendorLedgEntry.SetRange(Open, true);
        // CRITICAL FIX: Include both Invoice AND Credit Memo
        // VendorLedgEntry.SetFilter("Document Type", '%1|%2',
        //     VendorLedgEntry."Document Type"::Invoice,
        //     VendorLedgEntry."Document Type"::"Credit Memo");

        AppliedCount := VendorLedgEntry.Count();

        if AppliedCount = 0 then begin
            Message('DEBUG: No open invoices/credit memos found for vendor %1.\n\nThis vendor may not have any posted documents yet.\nOr all documents are already closed/applied.', GenJnlLine."Account No.");
            exit(0);
        end;

        // Set Applies-to ID on each document - BC will handle application during posting
        Message('DEBUG: Found %1 open documents for vendor %2.\nSetting Applies-to ID = %3', AppliedCount, GenJnlLine."Account No.", ApplyID);

        if VendorLedgEntry.FindSet(true) then begin
            repeat
                // CRITICAL: Must CalcFields BEFORE accessing Remaining Amount
                VendorLedgEntry.CalcFields("Remaining Amount");
                VendorLedgEntry."Applies-to ID" := ApplyID;
                VendorLedgEntry.Validate("Amount to Apply", VendorLedgEntry."Remaining Amount");
                VendorLedgEntry.Modify(true);
            until VendorLedgEntry.Next() = 0;
        end;

        // Set Applies-to ID on the payment line too - this is CRITICAL for preview/posting
        GenJnlLine.Validate("Applies-to ID", ApplyID);
        GenJnlLine.Modify(true);

        Message('DEBUG: Applies-to ID set successfully!\n\nPayment Line: %1\nApplies-to ID: %2\nDocuments marked: %3', GenJnlLine."Document No.", ApplyID, AppliedCount);

        exit(AppliedCount);
    end;

    /// <summary>
    /// Manual apply for current batch - call this from page button if auto-apply didn't work
    /// </summary>
    procedure ManualApplyCurrentBatch(TemplateNameParam: Code[10]; BatchNameParam: Code[10])
    var
        AppliedCount: Integer;
    begin
        AppliedCount := AutoApplyBatch(TemplateNameParam, BatchNameParam);
        if AppliedCount = 0 then
            Message('No documents found to apply. Please check if:\n1. Lines have vendor account type\n2. Vendor has open invoices/credit memos\n3. Document No. is not empty');
    end;

    /// <summary>
    /// Advanced procedure: Auto-apply payment to MULTIPLE specific invoices/credit memos.
    /// Use this when you want to manually specify which documents to apply.
    /// </summary>
    procedure AutoApplyToSpecificInvoices(var GenJnlLine: Record "Gen. Journal Line"; InvoiceDocNos: List of [Code[20]]): Integer
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        ApplyID: Code[50];
        InvoiceDocNo: Code[20];
        AppliedCount: Integer;
    begin
        // Validate payment line
        if GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor then
            exit(0);
        if GenJnlLine."Account No." = '' then
            exit(0);
        if InvoiceDocNos.Count() = 0 then
            exit(0);

        // Generate unique Applies-to ID
        ApplyID := GenJnlLine."Document No.";
        if ApplyID = '' then
            exit(0);

        // Apply to each invoice/credit memo in the list
        foreach InvoiceDocNo in InvoiceDocNos do begin
            VendorLedgEntry.Reset();
            VendorLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
            VendorLedgEntry.SetRange("Document No.", InvoiceDocNo);
            VendorLedgEntry.SetRange(Open, true);
            // CRITICAL FIX: Include both Invoice AND Credit Memo
            // VendorLedgEntry.SetFilter("Document Type", '%1|%2',
            //     VendorLedgEntry."Document Type"::Invoice,
            //     VendorLedgEntry."Document Type"::"Credit Memo");

            if VendorLedgEntry.FindSet(true) then begin
                repeat
                    // CRITICAL: Must CalcFields BEFORE accessing Remaining Amount
                    VendorLedgEntry.CalcFields("Remaining Amount");
                    VendorLedgEntry."Applies-to ID" := ApplyID;
                    VendorLedgEntry.Validate("Amount to Apply", VendorLedgEntry."Remaining Amount");
                    if VendorLedgEntry.Modify(true) then
                        AppliedCount += 1;
                until VendorLedgEntry.Next() = 0;
            end;
        end;

        // Set Applies-to ID on payment line
        if AppliedCount > 0 then begin
            GenJnlLine."Applies-to ID" := ApplyID;
            GenJnlLine.Modify(true);
        end;

        exit(AppliedCount);
    end;
}