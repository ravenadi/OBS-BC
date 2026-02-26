namespace GKBCustomization.GKBCustomization;

using Microsoft.Purchases.Document;
using Microsoft.Purchases.History;

pageextension 50179 "Pos Purch. Cr. Memo Subform" extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
                Visible = true;
            }
            field("G/L Account Name"; Rec."G/L Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the G/L Account Name from Chart of Accounts';
            }
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Transaction No. from Vendor Ledger Entry';
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Amount Including VAT';
            }
            field("GST Amount"; Rec."Amount Including VAT" - Rec.Amount)
            {
                ApplicationArea = All;
                Caption = 'GST Amount';
                ToolTip = 'Specifies the GST Amount (Amount Including VAT - Amount)';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Transaction No.", "G/L Account Name");
    end;
}
