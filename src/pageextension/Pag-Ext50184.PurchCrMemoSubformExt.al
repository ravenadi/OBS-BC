namespace GKBCustomization.GKBCustomization;

using Microsoft.Purchases.Document;
// DCS::HP08122025 ++
pageextension 50184 "Purch. Cr. Memo Subform Ext" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        modify("Job No.")
        {
            Visible = true;
            Caption = 'Job No.';
        }
        modify("Job Task No.")
        {
            Visible = true;
            Caption = 'Job Task No.';
        }
    }
}
// DCS::HP08122025 --