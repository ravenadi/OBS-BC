tableextension 50158 "Warehouse Reciepr Header" extends "Warehouse Receipt Header"
{
    fields
    {
        field(50110; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }
        //HP++
        field(50121; "D01 Preview Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //HP--
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