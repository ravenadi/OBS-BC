tableextension 50115 "Purch. Inv. Header Ext" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "Ordered By"; Text[100])
        {
            Caption = 'Ordered By';
            DataClassification = ToBeClassified;
        }
        field(50102; "Created By"; Text[100])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(50103; "Work Order No"; Text[100])
        {
            Caption = 'Work Order No';
            DataClassification = ToBeClassified;
        }
        field(50104; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }


    }

}