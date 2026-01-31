tableextension 50160 "Pos Warehouse Reciepr Header" extends "Posted Whse. Receipt Header"
{
    fields
    {
        field(50110; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}