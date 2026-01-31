tableextension 50123 "Transfer Receipt Line Ext" extends "Transfer Receipt Line"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50111; "Transfer Note"; Text[200])
        {
            Caption = 'Transfer Note';
            DataClassification = ToBeClassified;
        }
    }
}

