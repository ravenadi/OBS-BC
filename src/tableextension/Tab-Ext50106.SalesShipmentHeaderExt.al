tableextension 50106 "Sales Shipment Header Ext" extends "Sales Shipment Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50155; "Delivery Docket No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50192; "Full Topic"; Text[300])
        {
            DataClassification = ToBeClassified;

        }
    }
}