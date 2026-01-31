namespace GKBCustomization.GKBCustomization;

using Microsoft.Foundation.NoSeries;

pageextension 50203 "No. Series Ext" extends "No. Series"
{
    layout
    {
        addafter(Description)
        {
            field("FA Class Code"; Rec."FA Class Code")
            {
                ApplicationArea = All;
            }
            field("FA Subclass Code"; Rec."FA Subclass Code")
            {
                ApplicationArea = All;
            }
        }
    }
}