tableextension 50107 "Sales Cr.Memo Header Ext" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50192; "Full Topic"; Text[300])
        {
            DataClassification = ToBeClassified;

        }
    }
}