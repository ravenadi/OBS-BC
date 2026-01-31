pageextension 50175 "Pos Sales Inv Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
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