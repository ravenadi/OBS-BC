
pageextension 50123 "Purch. Invoices Ext" extends "Purchase Invoices"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}

