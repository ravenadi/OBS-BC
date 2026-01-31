page 50135 "Work Order Lines List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Work Order Lines";
    Caption = 'Work Order Lines';
    UsageCategory = Lists;
    DelayedInsert = true;
    SourceTableView = Sorting("Line No.")
                       order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    Caption = 'Line No. ';
                }
                field("Work Order No"; Rec."Work Order No.")
                {
                    Caption = 'Work Order No.';
                    ApplicationArea = all;
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        WorkOrder: Record "Work Order";
                    begin
                        if xRec."Work Order No." <> Rec."Work Order No." then begin
                            WorkOrder.Reset();
                            if WorkOrder.Get(Rec."Work Order No.") then begin
                                Rec."Work Order No." := WorkOrder."Project Task No";
                                Rec."Job No." := WorkOrder."Job No.";
                            end;
                        end;
                    end;
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
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("CRM ID"; Rec."CRM ID")
                {
                    ApplicationArea = all;
                }
                field("Unit Code"; rec."Unit Code")
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

                field("Project Code"; rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field("Project Task Code"; rec."Work Order No.")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = all;
                }
                // DCS::HP01122025++
                field("Project Task Number"; Rec."Project Task Number")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Project Task Number field.', Comment = '%';
                }
                // DCS::HP01122025--
                field("Line Created"; Rec."Line Created")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }
}
