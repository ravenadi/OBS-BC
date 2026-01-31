table 50106 "Job Journal Setup"
{
    Caption = 'Job Journal Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Journal Template"; Code[10])
        {
            Caption = 'Journal Template';
        }
        field(3; "Journal Batch"; Code[10])
        {
            Caption = 'Default Journal Batch';
            TableRelation = "Job Journal Batch".Name where ("Journal Template Name" = field("Journal Template"));
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
