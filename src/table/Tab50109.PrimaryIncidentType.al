// HK::DCS 061025 ++
table 50109 "Primary Incident Type"
{
    Caption = 'Primary Incident Type';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(2; "Estimated Duration"; Text[100])
        {
            Caption = 'Estimated Duration';
        }
        field(3; "Created On"; Text[100])
        {
            Caption = 'Created On';
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
// HK::DCS 061025 --