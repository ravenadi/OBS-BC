table 70201 "M2M Match Log"
{
    Caption = 'Many-to-Many Match Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account";
        }
        field(3; "Statement No."; Code[20])
        {
            Caption = 'Statement No.';
        }
        field(4; "Match Group ID"; Integer)
        {
            Caption = 'Match Group ID';
        }
        field(5; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionMembers = "Bank Statement Line","Ledger Entry";
        }
        field(6; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 5;
        }
        field(8; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(10; "Matched By"; Code[50])
        {
            Caption = 'Matched By';
        }
        field(11; "Matched Date-Time"; DateTime)
        {
            Caption = 'Matched Date-Time';
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Matched,Posted,Reversed;
            OptionCaption = 'Matched,Posted,Reversed';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(MatchGroup; "Bank Account No.", "Statement No.", "Match Group ID") { }
    }
}
