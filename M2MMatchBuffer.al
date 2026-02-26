table 70200 "M2M Match Buffer"
{
    TableType = Temporary;
    Caption = 'Many-to-Many Match Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionMembers = "Bank Statement Line","Ledger Entry";
            OptionCaption = 'Bank Statement Line,Ledger Entry';
        }
        field(3; "Recon Line No."; Integer)
        {
            Caption = 'Bank Statement Line No.';
        }
        field(4; "Ledger Entry No."; Integer)
        {
            Caption = 'Ledger Entry No.';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 5;
        }
        field(6; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(7; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
        }
        field(10; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(LineType; "Line Type") { }
    }
}
