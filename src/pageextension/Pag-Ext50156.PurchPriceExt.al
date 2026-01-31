pageextension 50156 "Purch.Price Ext" extends "Purchase Price List"
{
    layout
    {
        addafter(Status)
        {
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
            }
            field("Price Type"; Rec."Price Type")
            {
                ApplicationArea = All;
            }
        }
    }
}