// Code from Jatin
pageextension 50136 "Sales Price List Ext" extends "Sales Price List"
{
    layout
    {
        addafter(EndingDate)
        {
            field("D01 Percentage"; Rec."D01 Percentage")
            {
                ApplicationArea = All;
            }
        }
    }
}