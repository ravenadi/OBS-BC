table 50105 "Error Log"
{
    Caption = 'Error Log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Entry No';
        }
        field(2; "Document No"; Code[20])
        {
            Caption = 'Document No';
        }
        field(3; Description; Text[1024])
        {
            Caption = 'Description';
        }
        field(4; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
    }
    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
    }
}
