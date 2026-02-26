table 50207 "CRM Sync Buffer"
{
    TableType = Temporary;
    DataClassification = SystemMetadata;
    fields
    {
        field(1; "BC Item No."; Code[20]) { }
        field(2; "CRM ID"; Text[100]) { }
        field(3; "D365 Product ID"; Text[100]) { }
    }
    keys
    {
        key(PK; "BC Item No.") { Clustered = true; }
    }
}
