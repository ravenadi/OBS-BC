tableextension 50108 "Transfer Shipment Header Ext" extends "Transfer Shipment Header"
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