table 50108 "Resource Posting"
{
    Caption = 'Resource Posting';
    DataClassification = ToBeClassified;
 
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
 
        }
        field(2; "Gen. Product Posting"; Code[20])
        {
            Caption = 'Gen. Product Posting';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(3; "Cost G/L"; code[20])
        {
            Caption = 'Cost G/L';
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true));
 
        }
        field(4; "Balance G/L"; code[20])
        {
            Caption = 'Balance G/L';
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true));
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
 
 