namespace GKBCustomization.GKBCustomization;

using Microsoft.Purchases.History;

pageextension 50231 "Pstd Purch Cr Memo Lns List" extends "Posted Purchase Cr. Memo Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the G/L Account No. for this credit memo line';
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
