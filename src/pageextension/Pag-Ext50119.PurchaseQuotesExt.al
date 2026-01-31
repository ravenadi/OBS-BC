
pageextension 50119 "Purchase Quotes Ext" extends "Purchase Quotes"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}


