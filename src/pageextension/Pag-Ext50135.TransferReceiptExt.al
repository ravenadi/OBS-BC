pageextension 50135 "Transfer Receipt Ext" extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Transfer Note"; Rec."Transfer Note")
            {
                ApplicationArea = all;
            }
        }
    }
}