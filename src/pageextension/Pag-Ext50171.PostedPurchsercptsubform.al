pageextension 50171 "Posted Purchse rcpt subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the person who ordered the item.';
                Editable = true;
            }
            //DCS::HJ 20251103++
            field("Name Ordered By"; Rec."Name Ordered By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name Ordered By field.', Comment = '%';
            }
            //DCS::HJ 20251103++
            field("car Registration No."; Rec."Car Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Car Registration No. field.', Comment = '%';
            }
        }
    }
}
