tableextension 50133 "Purchase Order Archive" extends "Purchase Header Archive"
{
    fields
    {


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
        field(50107; "Entry Type"; Text[100])
        {
            Caption = 'Entry Type';
            DataClassification = ToBeClassified;
        }
        field(50108; "Po Status"; enum "Purch header Archive")
        {
            Caption = 'Po Status';
        }
    }

}