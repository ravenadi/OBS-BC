namespace GKBCustomization.GKBCustomization;

using Microsoft.Projects.Resources.Resource;

page 50153 Resource
{
    APIGroup = 'api';
    APIPublisher = 'integration';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'resource';
    DelayedInsert = true;
    EntityName = 'resourceAPI';
    EntitySetName = 'resourcesAPI';
    PageType = API;
    SourceTable = Resource;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(cRMID; Rec."CRM ID")
                {
                    Caption = 'crm ID';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                // DCS::HP 11082025 ++
                field(tradeType; Rec."Trade Type")
                {
                    Caption = 'Trade Type';
                }
                // DCS::HP 11082025 --
            }
        }
    }
}
