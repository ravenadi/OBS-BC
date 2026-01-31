namespace GKBCustomization.GKBCustomization;

using Microsoft.Sales.History;

pageextension 50177 "Pos Sales CR Memo Subform" extends "Posted Sales Cr. Memo Subform"
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
}
