page 50158 "API JobTask"
{
    PageType = API;
    Caption = 'API JobTask';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'jobtasks';
    EntitySetName = 'jobtasks';
    SourceTable = "Job Task";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(jobno; Rec."Job No.")
                {
                    Caption = 'Job No';
                }
                field(jobtaskno; Rec."Job Task No.")
                {
                    Caption = 'Job Task No';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(actualcost; Rec."Usage (Total Cost)")
                {
                    Caption = 'Usage (Total Cost)';
                }
                field(bc_id; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
            }
        }
    }
}