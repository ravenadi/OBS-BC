namespace GKBCustomization.GKBCustomization;

using Microsoft.Sales.History;

pageextension 50232 "Pstd Sales Cr Memo Lns List" extends "Posted Sales Credit Memo Lines"
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
                ToolTip = 'Specifies the Transaction No. from Customer Ledger Entry';
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
