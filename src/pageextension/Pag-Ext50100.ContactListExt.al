pageextension 50100 "Contact List Ext" extends "Contact List"
{
    layout
    {
        addafter("Currency Code")
        {
            field("CRM ID"; Rec."CRM ID") { ApplicationArea = all; }
        }
    }

}