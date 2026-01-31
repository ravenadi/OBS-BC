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
    }
}