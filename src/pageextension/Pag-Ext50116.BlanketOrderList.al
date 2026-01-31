pageextension 50116 "Blanket Order List" extends "Blanket Sales Orders"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}
