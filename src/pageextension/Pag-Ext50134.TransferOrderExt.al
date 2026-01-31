pageextension 50134 "Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        addlast(General)
        {
            field("Transfer Note"; Rec."Transfer Note")
            {
                ApplicationArea = All;
                Caption = 'Transfer Note';
            }
        }
    }

}