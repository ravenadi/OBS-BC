page 50106 "API Item Journals"
{
    PageType = API;
    Caption = 'API Item Journals';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'inventory';
    EntitySetName = 'inventory';
    SourceTable = "Item Journal Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(uomcode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(uomcrmid; Rec."Unit of Measure Code CRMID")
                {
                    Caption = 'Unit of Measure Code crmid';
                }
                field(postinggroup; Rec."Gen. Prod. Posting Group")
                {
                    Caption = 'Gen. Prod. Posting Group';
                }
                field(locationcode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(bincode; Rec."Bin Code")
                {
                    Caption = 'Bin Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitcost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitcostcrmid; Rec."Unit Cost CRMID")
                {
                    Caption = 'Unit Cost CRMID';
                }
            }
        }
    }
}
