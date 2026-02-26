tableextension 50111 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50108; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50109; "G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Editable = false;
        }
        field(50110; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Transaction No." where("Document No." = field("Document No."),
                                                                                "Document Type" = const("Credit Memo")));
            Editable = false;
        }
        field(50111; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            DataClassification = ToBeClassified;
        }
    }
}