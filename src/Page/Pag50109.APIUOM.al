page 50109 "API UOM"
{
    PageType = API;
    Caption = 'API UOM';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'uom';
    EntitySetName = 'uom';
    SourceTable = "Unit of Measure";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(code; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(unitgroupcrmid; Rec."Unitgroup CRM ID")
                {
                    Caption = 'Unitgroup CRM ID';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
            }
        }
    }
}
