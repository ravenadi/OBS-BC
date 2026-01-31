tableextension 50152 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "AP E-Mail"; Text[80])
        {
            Caption = 'AP E-Mail';
            DataClassification = ToBeClassified;
        }
        field(50102; "AR E-Mail"; Text[80])
        {
            Caption = 'AR E-Mail';
            DataClassification = ToBeClassified;
        }
        // DCS:: HP 250925 ++
        field(50103; "AP Telephone"; Text[30])
        {
            Caption = 'AP Telephone';
            DataClassification = ToBeClassified;
        }
    }
}