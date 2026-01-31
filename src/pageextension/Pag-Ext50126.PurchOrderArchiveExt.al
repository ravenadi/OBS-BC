pageextension 50126 "Purch Order Archive Ext" extends "Purchase Order Archives"
{
    layout
    {
        addafter("Location Code")
        {
            field("Po Status"; Rec."Po Status")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Entry Type"; Rec."Entry Type")
            {
                ApplicationArea = all;
            }
        }
    }
}