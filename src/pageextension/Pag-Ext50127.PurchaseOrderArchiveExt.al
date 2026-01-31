pageextension 50127 "Purchase Order Archive Ext" extends "Purchase Order Archive"
{
    layout
    {
        addlast(General)
        {
            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Work Order No"; Rec."Work Order No")
            {
                ApplicationArea = all;
            }
        }
    }
}