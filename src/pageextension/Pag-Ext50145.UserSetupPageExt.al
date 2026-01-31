pageextension 50145 "User Setup Page Ext" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("User Employee No."; Rec."User Employee No.") ////Pankaj_10Oct2025
            {
                ApplicationArea = all;
            }
            field("Allow Edit Mode"; Rec."Allow Edit Mode")
            {
                ApplicationArea = All;
            }
            field("Allow Edit Vandor Bank"; Rec."Allow Edit Vandor Bank")
            {
                ApplicationArea = all;
            }
            field("Customer Card"; Rec."Customer Card")
            {
                ApplicationArea = all;
            }
            field("G\L Account"; Rec."G\L Account")
            {
                ApplicationArea = all;
            }
            field("Location"; Rec."Location")
            {
                ApplicationArea = all;
            }
            field("Sales Quote"; Rec."Sales Quote")
            {
                ApplicationArea = all;
            }
            //DCS::HK 14112025 ++
            field("Req. Worksheet Status Allowed"; Rec."Req. Worksheet Status Allowed")
            {
                ApplicationArea = all;
            }
            //DCS::HK 14112025 --
            // DCS::HP 24082025 ++
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CRM ID field.', Comment = '%';
            }
        }
    }
}