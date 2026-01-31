pageextension 50157 "Warehouse Receipt" extends "Warehouse Receipt"
{
    layout
    {
        addlast(General)
        {
            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = All;
            }
        }
    }
}