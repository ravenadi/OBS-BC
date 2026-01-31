pageextension 50159 "Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {

        addlast(General)
        {
            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = All;
            }
            field("Full Topic"; Rec."Full Topic")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Topic field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}