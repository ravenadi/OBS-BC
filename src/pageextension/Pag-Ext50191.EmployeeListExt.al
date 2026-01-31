namespace GKBCustomizationsept.GKBCustomizationsept;

using Microsoft.HumanResources.Employee;
// DCS::HP 06102025 ++
pageextension 50191 "Employee List Ext" extends "Employee List"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CRM ID field.', Comment = '%';
            }
        }
    }
}
// DCS::HP 06102025 --
