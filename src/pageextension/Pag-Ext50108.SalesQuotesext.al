
pageextension 50108 "Sales Quotes Ext" extends "Sales Quotes"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}

