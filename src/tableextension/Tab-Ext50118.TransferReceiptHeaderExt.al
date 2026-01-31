tableextension 50118 "Transfer Receipt Header Ext" extends "Transfer Receipt Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
    }
}