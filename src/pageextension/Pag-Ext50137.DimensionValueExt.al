pageextension 50137 "Dimension Value Ext" extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = all;
            }
        }
    }
}