pageextension 50129 "Posted Purch. Rece Subform Ext" extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = all;
            }
            field("Name Ordered By"; Rec."Name Ordered By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name Ordered By field.', Comment = '%';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Work Order No"; Rec."Work Order No")
            {
                ApplicationArea = all;
            }
            field("Delivery Document No"; Rec."Delivery Document No")
            {
                ApplicationArea = all;
            }
        }
        
    }
    actions
    {
        addafter("&Print")
        {
            action("View QR-Codes")
            {
                ApplicationArea = all;
                Caption = 'View QR-Codes';
                Image = Add;
                trigger OnAction()
                var
                    PurcRecptQR: Report "Purch Receipt Item QR Codes";
                begin
                    PurcRecptQR.Run();
                end;
            }
        }
    }
}