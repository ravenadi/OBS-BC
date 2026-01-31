pageextension 50110 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        addafter("Currency Code")
        {
            field(SystemId; Rec.SystemId) { ApplicationArea = all; }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}