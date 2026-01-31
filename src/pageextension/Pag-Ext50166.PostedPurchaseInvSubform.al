pageextension 50166 "Posted Purchase Inv Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            field("Car Registration No."; Rec."Car Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Car Registration No. field.', Comment = '%';
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