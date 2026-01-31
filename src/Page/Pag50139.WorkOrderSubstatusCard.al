page 50139 "WorkOrderSubstatusCard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Work Order Substatus";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Work Order Name"; Rec."Name")
                {
                    ApplicationArea = all;
                    Caption = 'Name';
                }
                field("System Substatus"; Rec."System Substatus")
                {
                    ApplicationArea = all;
                    Caption = 'System Substatus';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}