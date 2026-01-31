tableextension 50148 "Currency Ext" extends "Currency"
{
    fields
    {
        field(50100; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50101; "Custom Exchange Amount"; Decimal)
        {
            Caption = 'Custom Exchange Amount';
            DataClassification = ToBeClassified;
        }
        field(50102; "Currency Code CRM"; Code[10])
        {
            Caption = 'Currency Code CRM';
            DataClassification = ToBeClassified;
        }
    }
}