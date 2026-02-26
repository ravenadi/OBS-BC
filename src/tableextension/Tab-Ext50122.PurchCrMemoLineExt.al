tableextension 50122 "Purch. Cr. Memo Line Ext" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50107; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Vendor Ledger Entry"."Transaction No." where("Document No." = field("Document No."),
                                                                                 "Document Type" = const("Credit Memo")));
            Editable = false;
        }
        field(50109; "G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("G/L Account No.")));
            Editable = false;
        }
        field(50114; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            DataClassification = ToBeClassified;
        }
    }
}