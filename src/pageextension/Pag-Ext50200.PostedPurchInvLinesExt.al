pageextension 50200 "Posted Purch Inv Lines Ext" extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addafter("Description")
        {
            // GkbLabs_Tv_15/12/25
            field("Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task Number for the purchase invoice line.';
            }
            // GkbLabs_Tv_29/01/25 ++
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Transaction Number from Vendor Ledger Entry.';
            }
            field(Cancelled; Rec.Cancelled)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the purchase invoice is cancelled.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the buy-from vendor.';
            }
            field("G/L Account Name"; Rec."G/L Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the G/L account.';
            }
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the GST amount (Amount Including VAT - Amount).';
            }
        }
    }

    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";

    trigger OnAfterGetRecord()
    begin
        // Transaction No.
        VendorLedgerEntry.Reset();
        VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        VendorLedgerEntry.SetRange("Document No.", Rec."Document No.");
        VendorLedgerEntry.SetRange("Vendor No.", Rec."Buy-from Vendor No.");
        if VendorLedgerEntry.FindLast() then
            Rec."Transaction No." := VendorLedgerEntry."Transaction No.";

        // Cancelled
        if PurchInvHeader.Get(Rec."Document No.") then
            Rec.Cancelled := PurchInvHeader.Cancelled;

        // Vendor Name
        if Vendor.Get(Rec."Buy-from Vendor No.") then
            Rec."Vendor Name" := Vendor.Name;

        // G/L Account Name
        if GLAccount.Get(Rec."G/L Account No.") then
            Rec."G/L Account Name" := GLAccount.Name;

        // GST Amount
        Rec."GST Amount" := Rec."Amount Including VAT" - Rec.Amount;
    end;
}
// GkbLabs_Tv_29/01/25 --
