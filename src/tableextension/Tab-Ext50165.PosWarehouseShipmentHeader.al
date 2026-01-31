tableextension 50165 "Pos Warehouse Shipment Header" extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(50521; "Delivery Docket No."; Code[50])
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