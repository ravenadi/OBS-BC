tableextension 50166 "Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(50170; "Delivery Docket No."; Text[100])
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