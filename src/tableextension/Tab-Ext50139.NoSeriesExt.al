tableextension 50172 "No. Series Ext" extends "No. Series"
{
    fields
    {
        field(100; "FA Class Code"; Code[10])
        {
            Caption = 'FA Class Code';
            TableRelation = "FA Class";
        }
        field(101; "FA Subclass Code"; Code[10])
        {
            Caption = 'FA Subclass Code';
            TableRelation = "FA Subclass";
        }
        field(102; "Default FA Posting Group"; Code[20])
        {
            Caption = 'Default FA Posting Group';
            TableRelation = "FA Posting Group";
            DataClassification = ToBeClassified;
        }
    }
}