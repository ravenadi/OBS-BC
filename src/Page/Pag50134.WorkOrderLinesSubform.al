page 50134 "Work Order Lines Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Work Order Lines";
    Caption = 'Work Order Lines';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Work Order No."; rec."Work Order No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        WorkOrder: Record "Work Order";
                    begin
                        WorkOrder.SetFilter("Job No.", Rec."Job No.");
                        if WorkOrder.FindFirst() then begin
                            Rec."Work Order No." := WorkOrder."Project Task No";
                            Rec."Job No." := WorkOrder."Job No.";
                        end;
                    end;
                }
                field("Project Code"; rec."Job No.")
                {
                    Caption = 'Project No.';
                    ApplicationArea = All;
                }
                field(Code; rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Unit Code"; rec."Unit Code")
                {
                    ApplicationArea = All;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Line Status"; rec."Line Status")
                {
                    ApplicationArea = All;
                }
                field("Estimate Quantity"; rec."Estimate Quantity")
                {
                    ApplicationArea = All;
                }
                field("Quantity to Build"; rec."Quantity to Build")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; rec."Location Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Line")
            {
                ApplicationArea = All;
                Caption = 'New Line';
                ToolTip = 'Create a new work order line.';
                Image = GetLines;
                trigger OnAction()
                begin
                    Rec.Insert(true);
                end;
            }
        }
    }
}
