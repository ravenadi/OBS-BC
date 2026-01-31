table 60100 "BSO Invoice Records"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; "Blanket Order No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
        }

        field(3; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Invoice));
        }

        field(4; "Invoice Date"; Date)
        {
            DataClassification = CustomerContent;
        }

        field(5; "Invoiced %"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(6; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Document Type"; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
