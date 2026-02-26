namespace GKBCustomization.GKBCustomization;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Payables;
using System.Reflection;

/// <summary>
/// Codeunit Journal Batch Management (ID 50137).
/// Handles the logic for moving journal lines to selected batches based on Test checkbox.
/// Supports grouping by Account Number for better organization.
/// When consolidating, updates Applies-to ID in Vendor Ledger Entry if Applies-to No. matches Document No.
/// </summary>


//Gkblabs_Tv_03/12/25
codeunit 60137 "Journal Batch Management"
{
    /// <summary>
    /// Shows batch selection dialog and moves all Test=true lines grouped by Account No. to selected batch.
    /// This is the main entry point from the page action button.
    /// Handles Applies-to ID matching with Vendor Ledger Entry.
    /// </summary>
    procedure ShowBatchSelectionAndMove(TemplateNameParam: Code[10]): Integer
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        SelectedBatchName: Code[10];
        TestLinesCount: Integer;
    begin
        // Count lines with Test=true first
        TestLinesCount := CountTestLines(TemplateNameParam);
        if TestLinesCount = 0 then begin
            Message('No journal lines with Test checkbox selected.');
            exit(0);
        end;

        // Show batch selection dialog
        GenJnlBatch.SetRange("Journal Template Name", TemplateNameParam);
        if PAGE.RunModal(PAGE::"General Journal Batches", GenJnlBatch) = ACTION::LookupOK then begin
            SelectedBatchName := GenJnlBatch.Name;

            // Verify destination batch doesn't already contain Test=true lines
            if IsAnyTestLineInBatch(TemplateNameParam, SelectedBatchName) then begin
                Message('Selected batch already contains marked lines. Please select a different batch.');
                exit(0);
            end;

            exit(MoveAllTestLinesToBatchGrouped(TemplateNameParam, SelectedBatchName));
        end;
        exit(0);
    end;

    /// <summary>
    /// Moves all Test=true lines to selected batch, grouping by Account No.
    /// When multiple Test=true lines have same Account No., Document No., AND Applies-to Doc. No., amounts are consolidated.
    /// PRESERVES Applies-to Doc. No. and Applies-to ID from original lines for correct posting.
    /// Automatically applies consolidated lines to vendor invoices using BC standard mechanism.
    /// </summary>
    local procedure MoveAllTestLinesToBatchGrouped(TemplateNameParam: Code[10]; DestinationBatchName: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        NewGenJnlLine: Record "Gen. Journal Line";
        AutoApplyCodeunit: Codeunit "Auto Apply After Consolidation";
        AccountNo: Code[20];
        MovedCount: Integer;
        ConsolidatedCount: Integer;
        NewLineNo: Integer;
        Msg: Text;
    begin
        // Ensure destination batch exists
        EnsureUserBatchExists(TemplateNameParam, DestinationBatchName);

        // Get next available line number in destination batch
        NewLineNo := GetNextLineNo(TemplateNameParam, DestinationBatchName);

        // Find all lines in template (will filter by Test field in code)
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetFilter("Journal Batch Name", '<>%1', DestinationBatchName);
        GenJnlLine.SetCurrentKey("Account No.", "Account Type", "Document No.");

        // First pass: consolidate lines into temp table
        if GenJnlLine.FindSet() then begin
            repeat
                // Check Test field value directly - extension field
                if GenJnlLine.Test = true then begin
                    // Check if this combination already exists in temp table
                    // Consolidation matches: Account Type + Account No. + Document No. + Description
                    //                       + Currency Code + Posting Date + Payment Method Code
                    // NOTE: Applies-to Doc. No. is NOT checked - lines with different invoices WILL consolidate
                    TempGenJnlLine.SetRange("Account Type", GenJnlLine."Account Type");
                    TempGenJnlLine.SetRange("Account No.", GenJnlLine."Account No.");
                    TempGenJnlLine.SetRange("Document No.", GenJnlLine."Document No.");
                    TempGenJnlLine.SetRange(Description, GenJnlLine.Description);
                    TempGenJnlLine.SetRange("Currency Code", GenJnlLine."Currency Code");
                    TempGenJnlLine.SetRange("Posting Date", GenJnlLine."Posting Date");
                    TempGenJnlLine.SetRange("Payment Method Code", GenJnlLine."Payment Method Code");

                    if TempGenJnlLine.FindFirst() then begin
                        // Same combination found: consolidate by summing amounts
                        TempGenJnlLine.Amount += GenJnlLine.Amount;
                        TempGenJnlLine."Amount (LCY)" += GenJnlLine."Amount (LCY)";
                        // keep debit/credit values in line with the Amount total
                        TempGenJnlLine."Debit Amount" := TempGenJnlLine.Amount;
                        TempGenJnlLine."Credit Amount" := TempGenJnlLine.Amount * -1; // mirror if needed

                        TempGenJnlLine.Modify();
                        ConsolidatedCount += 1;

                        // CRITICAL: Set Applies-to ID on THIS invoice immediately
                        // This ensures BC knows which invoices to apply when posting
                        if GenJnlLine."Applies-to Doc. No." <> '' then
                            SetAppliesToIDForInvoice(GenJnlLine."Account No.", GenJnlLine."Applies-to Doc. No.", GenJnlLine."Document No.");
                    end else begin
                        // First occurrence: add to temp table
                        TempGenJnlLine.Init();
                        // Use false parameter to skip FlowField calculation
                        TempGenJnlLine.TransferFields(GenJnlLine, false);
                        TempGenJnlLine."Line No." := NewLineNo;
                        // make sure debit amount mirrors the amount value
                        TempGenJnlLine."Debit Amount" := GenJnlLine.Amount;
                        TempGenJnlLine."Credit Amount" := GenJnlLine.Amount * -1;
                        TempGenJnlLine.Insert();
                        NewLineNo += 10000;

                        // Also set Applies-to ID for first line's invoice
                        if GenJnlLine."Applies-to Doc. No." <> '' then
                            SetAppliesToIDForInvoice(GenJnlLine."Account No.", GenJnlLine."Applies-to Doc. No.", GenJnlLine."Document No.");
                    end;

                    TempGenJnlLine.Reset();
                end;
            until GenJnlLine.Next() = 0;
        end;

        // Second pass: move consolidated lines to destination batch
        TempGenJnlLine.Reset();
        TempGenJnlLine.SetCurrentKey("Account No.");
        if TempGenJnlLine.FindSet() then begin
            AccountNo := '';
            repeat
                // Add spacing between different account numbers
                if (AccountNo <> TempGenJnlLine."Account No.") and (AccountNo <> '') then
                    NewLineNo += 5000;

                AccountNo := TempGenJnlLine."Account No.";

                // Insert consolidated line to destination batch
                NewGenJnlLine.Init();
                NewGenJnlLine.TransferFields(TempGenJnlLine, false);
                NewGenJnlLine."Journal Template Name" := TemplateNameParam;
                NewGenJnlLine."Journal Batch Name" := DestinationBatchName;
                NewGenJnlLine."Line No." := NewLineNo;
                NewGenJnlLine.Test := false;  // Clear checkbox after moving

                // For consolidated lines, clear Applies-to Doc. No. (since multiple invoices)
                // Set Applies-to ID to Document No. - this will be used for application
                NewGenJnlLine."Applies-to Doc. No." := '';
                NewGenJnlLine."Applies-to ID" := NewGenJnlLine."Document No.";

                NewGenJnlLine.Insert(true);

                MovedCount += 1;
                NewLineNo += 10000;
            until TempGenJnlLine.Next() = 0;
        end;

        // Delete original Test=true lines from source batches
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetFilter("Journal Batch Name", '<>%1', DestinationBatchName);
        if GenJnlLine.FindSet() then begin
            repeat
                if GenJnlLine.Test = true then
                    GenJnlLine.Delete(true);
            until GenJnlLine.Next() = 0;
        end;

        // Show result message
        if MovedCount > 0 then begin
            if ConsolidatedCount > 0 then
                Msg := StrSubstNo('%1 journal line(s) moved to batch: %2 (%3 lines consolidated by Vendor and Invoice)', MovedCount, DestinationBatchName, ConsolidatedCount)
            else
                Msg := StrSubstNo('%1 journal line(s) moved to batch: %2.', MovedCount, DestinationBatchName);
            Message(Msg);

            // Commit changes before auto-apply
            Commit();

            // AUTOMATIC APPLY: Apply consolidated lines to vendor invoices
            // This uses BC standard "Apply Entries" mechanism automatically
            AutoApplyCodeunit.AutoApplyBatch(TemplateNameParam, DestinationBatchName);
        end else begin
            Message('No lines were moved.');
        end;

        exit(MovedCount);
    end;

    /// <summary>
    /// Sets Applies-to ID on a specific invoice in Vendor Ledger Entry (Table 25).
    /// This is called during consolidation to mark which invoices should be applied.
    /// Each invoice gets marked with the payment Document No. as Applies-to ID.
    /// </summary>
    local procedure SetAppliesToIDForInvoice(VendorNo: Code[20]; InvoiceDocNo: Code[20]; PaymentDocNo: Code[20])
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        DiagnosticMsg: Text;
    begin
        if (VendorNo = '') or (InvoiceDocNo = '') or (PaymentDocNo = '') then
            exit;

        // Only set Applies-to ID for open entries that do not already have Applies-to ID (ignore Document Type)
        VendorLedgEntry.Reset();
        VendorLedgEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgEntry.SetRange("Document No.", InvoiceDocNo);
        VendorLedgEntry.SetRange(Open, true);
        // VendorLedgEntry.SetRange("Document Type", VendorLedgEntry."Document Type"::Invoice);
        // NO Document Type filter - apply to ALL document types

        // Set Applies-to ID on this document
        if VendorLedgEntry.FindFirst() then begin
            VendorLedgEntry.CalcFields("Remaining Amount");
            // VendorLedgEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");

            // Set Applies-to ID even if remaining is zero
            VendorLedgEntry."Applies-to ID" := PaymentDocNo;
            // Use Validate to trigger BC standard logic
            VendorLedgEntry.Validate("Amount to Apply", VendorLedgEntry."Remaining Amount");
            VendorLedgEntry.Modify(true);
            //Gkblabs_Tv_06/02/26+++++++++++

            // Success message
            Message('✓ Applied: %1 %2 → Payment %3\nRemaining: %4\nPositive: %5',
                VendorLedgEntry."Document Type",
                InvoiceDocNo,
                PaymentDocNo,
                VendorLedgEntry."Remaining Amount",
                VendorLedgEntry.Positive);
        end else begin
            // Document not found - check why
            VendorLedgEntry.Reset();
            VendorLedgEntry.SetRange("Vendor No.", VendorNo);
            VendorLedgEntry.SetRange("Document No.", InvoiceDocNo);

            if VendorLedgEntry.FindFirst() then begin
                VendorLedgEntry.CalcFields("Remaining Amount");
                Message('✗ Document FOUND but NOT MATCHED: %1\n' +
                    'Vendor: %2\n' +
                    'Document Type: %3 (Need Invoice or Credit Memo)\n' +
                    'Open: %4 (Need Yes)\n' +
                    'Positive: %5\n' +
                    'Remaining: %6',
                    InvoiceDocNo, VendorNo,
                    Format(VendorLedgEntry."Document Type"),
                    VendorLedgEntry.Open,
                    VendorLedgEntry.Positive,
                    VendorLedgEntry."Remaining Amount");
            end else begin
                Message('✗ Document NOT FOUND: %1\nVendor: %2', InvoiceDocNo, VendorNo);
            end;
            //Gkblabs_Tv_06/02/26----------------
        end;
    end;

    /// <summary>
    /// Moves journal lines with Test=true to user's personal batch.
    /// Creates the batch if it doesn't exist.
    /// </summary>
    procedure MoveLinesToUserBatch(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLineToMove: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        UserBatchName: Code[10];
        MovedCount: Integer;
        NewLineNo: Integer;
    begin
        if not (GenJnlLine.Test = true) then
            exit;

        // Get user's batch name (based on current user)
        UserBatchName := GetUserBatchName();

        // Ensure user's batch exists, create if not
        EnsureUserBatchExists(GenJnlLine."Journal Template Name", UserBatchName);

        // Get next available line number in user batch
        NewLineNo := GetNextLineNo(GenJnlLine."Journal Template Name", UserBatchName);

        // Copy current record to user batch if not already there
        if GenJnlLine."Journal Batch Name" <> UserBatchName then begin
            NewGenJnlLine.Init();
            NewGenJnlLine.TransferFields(GenJnlLine, false);
            NewGenJnlLine."Journal Template Name" := GenJnlLine."Journal Template Name";
            NewGenJnlLine."Journal Batch Name" := UserBatchName;
            NewGenJnlLine."Line No." := NewLineNo;
            if NewGenJnlLine.Insert(true) then begin
                GenJnlLine.Delete(true);
                MovedCount := 1;
                NewLineNo += 10000;
            end;
        end;

        // Copy all other lines with same account number and Test=true
        if GenJnlLine."Account No." <> '' then begin
            GenJnlLineToMove.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLineToMove.SetRange("Account No.", GenJnlLine."Account No.");
            GenJnlLineToMove.SetFilter("Journal Batch Name", '<>%1', UserBatchName);

            if GenJnlLineToMove.FindSet() then
                repeat
                    if GenJnlLineToMove.Test = true then begin
                        NewGenJnlLine.Init();
                        NewGenJnlLine.TransferFields(GenJnlLineToMove, false);
                        NewGenJnlLine."Journal Template Name" := GenJnlLineToMove."Journal Template Name";
                        NewGenJnlLine."Journal Batch Name" := UserBatchName;
                        NewGenJnlLine."Line No." := NewLineNo;
                        if NewGenJnlLine.Insert(true) then begin
                            GenJnlLineToMove.Delete(true);
                            MovedCount += 1;
                            NewLineNo += 10000;
                        end;
                    end;
                until GenJnlLineToMove.Next() = 0;
        end;

        if MovedCount > 0 then
            Message('%1 journal line(s) with Account No. %2 moved to batch: %3', MovedCount, GenJnlLine."Account No.", UserBatchName);
    end;

    /// <summary>
    /// Moves all lines with Test=true to a selected batch (bulk operation).
    /// User can choose the destination batch via dialog.
    /// </summary>
    procedure MoveAllTestLinesToSelectedBatch(TemplateNameParam: Code[10]): Integer
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        SelectedBatchName: Code[10];
    begin
        // Show batch selection dialog
        GenJnlBatch.SetRange("Journal Template Name", TemplateNameParam);
        if PAGE.RunModal(PAGE::"General Journal Batches", GenJnlBatch) = ACTION::LookupOK then begin
            SelectedBatchName := GenJnlBatch.Name;
            exit(MoveAllTestLinesToBatch(TemplateNameParam, SelectedBatchName));
        end;
        exit(0);
    end;

    /// <summary>
    /// Moves all lines with Test=true to a specific batch (internal procedure).
    /// </summary>
    local procedure MoveAllTestLinesToBatch(TemplateNameParam: Code[10]; DestinationBatchName: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        MovedCount: Integer;
        NewLineNo: Integer;
    begin
        // Ensure destination batch exists
        EnsureUserBatchExists(TemplateNameParam, DestinationBatchName);

        // Get next available line number in destination batch
        NewLineNo := GetNextLineNo(TemplateNameParam, DestinationBatchName);

        // Find all lines in template
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetFilter("Journal Batch Name", '<>%1', DestinationBatchName);

        if GenJnlLine.FindSet() then
            repeat
                if GenJnlLine.Test = true then begin
                    NewGenJnlLine.Init();
                    NewGenJnlLine.TransferFields(GenJnlLine, false);
                    NewGenJnlLine."Journal Template Name" := GenJnlLine."Journal Template Name";
                    NewGenJnlLine."Journal Batch Name" := DestinationBatchName;
                    NewGenJnlLine."Line No." := NewLineNo;
                    if NewGenJnlLine.Insert(true) then begin
                        GenJnlLine.Delete(true);
                        MovedCount += 1;
                        NewLineNo += 10000;
                    end;
                end;
            until GenJnlLine.Next() = 0;

        if MovedCount > 0 then
            Message('%1 journal line(s) moved to batch: %2', MovedCount, DestinationBatchName);

        exit(MovedCount);
    end;

    /// <summary>
    /// Moves all lines with Test=true to user's personal batch (bulk operation).
    /// </summary>
    procedure MoveAllTestLinesToUserBatch(TemplateNameParam: Code[10]): Integer
    var
        UserBatchName: Code[10];
    begin
        UserBatchName := GetUserBatchName();
        exit(MoveAllTestLinesToBatch(TemplateNameParam, UserBatchName));
    end;

    /// <summary>
    /// Gets the current user's batch name (first 10 characters of username).
    /// </summary>
    procedure GetUserBatchName(): Code[10]
    var
        CurrentUser: Text;
    begin
        CurrentUser := CopyStr(UserId(), 1, MaxStrLen(CurrentUser));
        exit(CopyStr(CurrentUser, 1, 10));
    end;

    /// <summary>
    /// Ensures user's batch exists, creates it if not found.
    /// </summary>
    local procedure EnsureUserBatchExists(TemplateNameParam: Code[10]; BatchNameParam: Code[10])
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        CurrentUser: Text;
    begin
        if not GenJnlBatch.Get(TemplateNameParam, BatchNameParam) then begin
            GenJnlBatch.Init();
            GenJnlBatch."Journal Template Name" := TemplateNameParam;
            GenJnlBatch.Name := BatchNameParam;

            // Set description with user's full name
            CurrentUser := UserId();
            GenJnlBatch.Description := StrSubstNo('Batch for %1', CurrentUser);
            GenJnlBatch.Insert(true);
        end;
    end;

    /// <summary>
    /// Gets count of lines in user's batch.
    /// </summary>
    procedure GetUserBatchLineCount(TemplateNameParam: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        UserBatchName: Code[10];
    begin
        UserBatchName := GetUserBatchName();
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetRange("Journal Batch Name", UserBatchName);
        exit(GenJnlLine.Count());
    end;

    /// <summary>
    /// Gets the next available line number for the batch.
    /// </summary>
    local procedure GetNextLineNo(TemplateNameParam: Code[10]; BatchNameParam: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetRange("Journal Batch Name", BatchNameParam);
        if GenJnlLine.FindLast() then
            exit(GenJnlLine."Line No." + 10000)
        else
            exit(10000);
    end;

    /// <summary>
    /// Counts the number of lines with Test=true in a template.
    /// </summary>
    local procedure CountTestLines(TemplateNameParam: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        TestLineCount: Integer;
    begin
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        if GenJnlLine.FindSet() then begin
            repeat
                if GenJnlLine.Test = true then
                    TestLineCount += 1;
            until GenJnlLine.Next() = 0;
        end;
        exit(TestLineCount);
    end;

    /// <summary>
    /// Checks if any Test=true lines exist in a specific batch.
    /// Used to prevent moving to the same batch.
    /// </summary>
    local procedure IsAnyTestLineInBatch(TemplateNameParam: Code[10]; BatchNameParam: Code[10]): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", TemplateNameParam);
        GenJnlLine.SetRange("Journal Batch Name", BatchNameParam);
        GenJnlLine.SetRange(Test, true);
        exit(not GenJnlLine.IsEmpty());
    end;
}
