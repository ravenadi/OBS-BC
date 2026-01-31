page 50124 "API Work Order Lines"
{
    PageType = API;
    ApplicationArea = All;
    SourceTable = "Work Order Lines";
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'WorkOrderLine';
    EntitySetName = 'WorkOrderLines';
    DelayedInsert = true;



    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // DCS::HP02122025 ++ Production Comment
                field(projectTaskNumber; Rec."Project Task Number")
                {
                    Caption = 'Project Task Number';
                }
                // DCS::HP02122025 --
                field("CRMID"; Rec."CRM ID")
                {
                }
                field("WorkOrderNo"; Rec."Work Order No.")
                {
                }
                // DCS::HP 07082025 ++
                field(Code; Rec."Code")
                {
                }
                field(UnitCode; Rec."Unit Code")
                {
                }
                // DCS::HP 07082025 --
                field(Name; Rec.Description)
                {
                }
                field("LineStatus"; Rec."Line Status")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("LineType"; Rec."Line Type")
                {
                }
                field("EstimateQuantity"; Rec."Estimate Quantity")
                {
                }

                field("QuantitytoBuild"; Rec."Quantity to Build")
                {
                }
                field("WorkStartTime"; Rec."Work Start Time")
                {
                }
                field("WorkEndTime"; Rec."Work End Time")
                {
                }
                field("ServiceDuration"; Rec."Service Duration")
                {
                }
                field("LocationCode"; Rec."Location Code")
                {
                }
                field("UnitCost"; Rec."Unit Cost")
                {
                }
                field("UnitAmount"; Rec."Unit Amount")
                {
                }
                // DCS::HP 081025 ++
                field(owner; Rec."Owner CRM")
                {
                }
                // DCS::HP 081025 --

                // field("LineNo"; Rec."Line No.")
                // {
                // }
                // DCS::HP 07082025 --
            }
        }
    }
}