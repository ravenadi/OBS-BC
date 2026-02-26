tableextension 50120 "Purch. Inv. Line Ext" extends "Purch. Inv. Line"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }

        field(50111; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }
        field(50107; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        // DCS::HP 18092025 ++
        field(50210; "Car Registration No."; Code[50])
        {
            Caption = 'Car Registration No.';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 18092025 --
        // GkbLabs_Tv_29/01/25 ++
        // Changed field ID from 50211 to 50216 to avoid conflict with Purchase Line field 50211 "Name Ordered By"
        field(50216; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
            DataClassification = ToBeClassified;
        }
        field(50212; Cancelled; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = ToBeClassified;
        }
        field(50213; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = ToBeClassified;
        }
        field(50214; "G/L Account Name"; Text[100])
        {
            Caption = 'G/L Account Name';
            DataClassification = ToBeClassified;
        }
        field(50215; "GST Amount"; Decimal)
        {
            Caption = 'GST Amount';
            DataClassification = ToBeClassified;
        }
        // GkbLabs_Tv_29/01/25 --
    }



}