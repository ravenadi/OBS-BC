tableextension 50144 "Item Journals Ext" extends "Item Journal Line"
{
    fields
    {
        field(50100; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50101; "Unit of Measure Code CRMID"; Text[100])
        {
            Caption = 'Unit of Measure Code CRMID';
            DataClassification = ToBeClassified;
        }
        field(50102; "Unit Cost CRMID"; Text[100])
        {
            Caption = 'Unit Cost CRMID';
            DataClassification = ToBeClassified;
        }
        field(50103; "Comment"; Text[200])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(50114; "Item Availability By Location"; Decimal)
        {
            Caption = 'Item Availability By Location';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
    }
}