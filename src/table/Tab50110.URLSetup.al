table 50110 "URL Setup"
{
    Caption = 'URL Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(2; "Customer URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Functional Location URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(4; "Contact URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Item URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Projects URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(7; "Location URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }

        field(8; "Inventory Transfer URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Inventory Adjustment URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
            Editable = false;
        }
        // DCS::HP02122025 ++
        field(10; "Sales Price List URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        // DCS::HP02122025 ++
        field(11; "Purchase Order URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Inventory URL"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}