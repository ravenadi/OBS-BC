tableextension 50169 "Resources Setup ext" extends "Resources Setup"
{
    fields
    {
        field(80100; Journal; Code[10])
        {
            Caption = 'Journal';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(80101; Batch; code[10])
        {
            Caption = 'Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field(Journal));
        }
 
    }
}
 
 