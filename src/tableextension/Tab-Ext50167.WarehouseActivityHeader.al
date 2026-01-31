tableextension 50167 "Warehouse Activity Header" extends "Warehouse Activity Header"
{
    fields
    {
        field(50100; "Delivery Docket No."; Text[100])
        {
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