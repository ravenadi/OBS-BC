namespace GKBCustomization.GKBCustomization;

using Microsoft.Projects.Resources.Resource;

pageextension 50181 "Resource Ext" extends "Resource Card"
{
    layout
    {
        addafter("Time Sheet Approver User ID")
        {
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = All;
            }
            // DCS::HP 11082025 ++
            field("Trade Type"; Rec."Trade Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Trade Type field.', Comment = '%';
            }
            // DCS::HP 11082025 --
        }
    }
}
