

pageextension 50149 "Location List Ext" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("Crm Id"; Rec."Crm Id")
            {
                ApplicationArea = all;
            }
        }
    }
}