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
    }
}