namespace GKBCustomization.GKBCustomization;

using Microsoft.Foundation.Company;
// DCS::HP 19092025 ++
pageextension 50187 "Company Information Ext" extends "Company Information"
{
    layout
    {
        addlast(Communication)
        {
            field("AP E-Mail"; rec."AP E-Mail")
            {
                ApplicationArea = All;
                Caption = 'AP E-Mail';
                ToolTip = 'Specifies the e-mail address for accounts payable communications.';
            }
            field("AR E-Mail"; rec."AR E-Mail")
            {
                ApplicationArea = All;
                Caption = 'AR E-Mail';
                ToolTip = 'Specifies the e-mail address for accounts receivable communications.';
            }
            field("AP Telephone"; Rec."AP Telephone")
            {
                ApplicationArea = All;
                Caption = 'AP Telephone';
                ToolTip = 'Specifies the value of the AP Telephone field.', Comment = '%';
            }
        }
    }
}
// DCS::HP 19092025 --