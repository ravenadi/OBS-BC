page 50107 "API Locations "
{
    PageType = API;
    APIVersion = 'v2.0';
    EntityName = 'Location';
    EntitySetName = 'Locations';
    APIGroup = 'api';
    APIPublisher = 'integration';
    SourceTable = Location;
    DelayedInsert = true;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm Id';
                }
                field("AdjustmentCrmId"; Rec."Adjustment Crm Id") { }
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name or address of the location.';
                }
                field("AddressName"; Rec."Address Name") { }
                field("Address1"; Rec.Address) { }
                field("Address2"; Rec."Address 2") { }
                field("City"; Rec."D365 City") { }
                field("State"; Rec."D365 State") { }
                field("Country"; Rec."D365 Country") { }
                field("PostCode"; Rec."D365 Postal Code") { }
            }
        }
    }
}