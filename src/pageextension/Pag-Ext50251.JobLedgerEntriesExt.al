pageextension 50251 "Job Ledger Entries Ext" extends "Job Ledger Entries"
{
    layout
    {
        modify("Document No.")
        {
            trigger OnDrillDown()
            var
                PurchInvHeader: Record "Purch. Inv. Header";
                PostedPurchInvoicesPage: Page "Posted Purchase Invoices";
            begin
                if Rec."Document No." = '' then
                    exit;
                if PurchInvHeader.Get(Rec."Document No.") then begin
                    PurchInvHeader.SetRange("No.", Rec."Document No.");
                    PostedPurchInvoicesPage.SetTableView(PurchInvHeader);
                    PostedPurchInvoicesPage.Run();
                end;
            end;
        }
    }
}
