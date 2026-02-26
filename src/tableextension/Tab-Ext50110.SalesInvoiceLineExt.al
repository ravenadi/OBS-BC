tableextension 50110 "Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        field(50100; Comments2; Text[200])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "Crm Id"; Text[200])
        {
            Caption = 'Crm Id';
            DataClassification = ToBeClassified;
        }
        field(50108; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50211; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            DataClassification = ToBeClassified;
        }
        field(50212; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(50213; "G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            DataClassification = ToBeClassified;
        }
        field(50214; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            DataClassification = ToBeClassified;
        }
        field(50215; "Cancelled"; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = ToBeClassified;
        }
    }
}
