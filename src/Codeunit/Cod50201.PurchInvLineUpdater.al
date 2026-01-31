codeunit 50201 "Purch Inv Line Updater"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(
        var PurchaseHeader: Record "Purchase Header";
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PurchRcpHdrNo: Code[20];
        RetShptHdrNo: Code[20];
        PurchInvHdrNo: Code[20];
        PurchCrMemoHdrNo: Code[20])
    var
        PurchInvLine: Record "Purch. Inv. Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PurchInvHdrNo = '' then
            exit;

        Message('Event fired for invoice %1', PurchInvHdrNo);

        PurchInvHeader.Get(PurchInvHdrNo);

        PurchInvLine.SetRange("Document No.", PurchInvHdrNo);
        if PurchInvLine.FindSet() then
            repeat
                // Transaction No.
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
                VendorLedgerEntry.SetRange("Document No.", PurchInvHdrNo);
                if VendorLedgerEntry.FindFirst() then begin
                    PurchInvLine."Transaction No." := VendorLedgerEntry."Transaction No.";
                    Message('VLE found, Transaction No %1', VendorLedgerEntry."Transaction No.");
                end else
                    Message('No VLE found for %1', PurchInvHdrNo);

                // Cancelled
                PurchInvLine.Cancelled := PurchInvHeader.Cancelled;

                // Vendor Name
                Vendor.Reset();
                if Vendor.Get(PurchInvLine."Buy-from Vendor No.") then
                    PurchInvLine."Vendor Name" := Vendor.Name;

                // G/L Account Name
                GLAccount.Reset();
                if GLAccount.Get(PurchInvLine."G/L Account No.") then
                    PurchInvLine."G/L Account Name" := GLAccount.Name;

                // GST Amount
                PurchInvLine."GST Amount" :=
                    PurchInvLine."Amount Including VAT" - PurchInvLine.Amount;

                PurchInvLine.Modify(false);
                Message('Line updated: Transaction No %1, Vendor Name %2, GST Amount %3', PurchInvLine."Transaction No.", PurchInvLine."Vendor Name", PurchInvLine."GST Amount");
            until PurchInvLine.Next() = 0;
    end;
}