page 50126 "API WorkOrderSubStatus"
{
    PageType = API;
    EntitySetName = 'Workordersubstatus';
    EntityName = 'Workordersubstatus';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    APIPublisher = 'integration';
    DelayedInsert = true;
    SourceTable = "Work Order Substatus";

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
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field("SystemSubstatus"; Rec."System Substatus")
                {
                    Caption = 'SystemSubstatus';
                }
            }
        }
    }
}