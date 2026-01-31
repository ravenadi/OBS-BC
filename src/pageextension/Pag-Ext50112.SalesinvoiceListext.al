
pageextension 50112 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}
