
tableextension 50137 "UOM Ext" extends "Unit of Measure"
{
    fields
    {
        field(50100; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50101; "Unitgroup CRM ID"; Text[100])
        {
            Caption = 'Unitgroup CRM ID';
            DataClassification = ToBeClassified;
        }
    }
}