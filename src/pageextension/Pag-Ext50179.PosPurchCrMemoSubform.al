namespace GKBCustomization.GKBCustomization;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;

pageextension 50179 "Pos Purch. Cr. Memo Subform" extends "Posted Purch. Cr. Memo Subform"
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
