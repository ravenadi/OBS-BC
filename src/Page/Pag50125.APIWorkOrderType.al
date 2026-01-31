page 50125 "API WorkOrderType"
{
    PageType = API;
    EntityName = 'WorkOrderType';
    EntitySetName = 'WorkOrderTypes';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    APIPublisher = 'integration';
    DelayedInsert = true;
    SourceTable = "GKB Work Order Type";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("CRMID"; Rec."CRM ID")
                {
                    Caption = 'Crm Id';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field("WorkOrderName"; Rec."Work Order Type Name")
                {
                    Caption = 'Work Order Name';
                }
            }
        }
    }
}