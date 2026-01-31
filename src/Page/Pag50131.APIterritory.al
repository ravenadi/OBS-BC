page 50131 "API territory"
{
    PageType = API;
    Caption = 'API Territory';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'territories';
    EntitySetName = 'territories';
    SourceTable = Territory;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(code; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(bc_id; Rec.SystemId)
                {
                    Caption = 'System Id';
                }

            }
        }
    }
}
