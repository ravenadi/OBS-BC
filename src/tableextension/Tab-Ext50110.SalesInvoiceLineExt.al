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
    }
}
