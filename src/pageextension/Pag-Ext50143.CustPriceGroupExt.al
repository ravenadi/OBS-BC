
pageextension 50143 "Cust. Price Group Ext" extends "Customer Price Groups"
{
    layout
    {
        addafter(Description)
        {
            field("Crm Id"; rec."Crm Id") { ApplicationArea = All; }
        }
    }
}
