pageextension 50117 "Blanket Sales Order Ext" extends "Blanket Sales Order"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(BSOInvoices; "BSO Invoice Records")
            {
                ApplicationArea = All;
                SubPageLink = "Blanket Order No." = FIELD("No.");
            }
        }
        addafter("Sell-to Address 2")
        {
            field("D365 Sell-to Address 3"; Rec."D365 Sell-to Address 3")
            {
                ApplicationArea = All;
                Caption = 'Address 3';
                ToolTip = 'Specifies the third line of the D365 sell-to address.';
            }
        }
        addafter("Bill-to Address 2")
        {
            field("D365 Bill-to Address 3"; Rec."D365 Bill-to Address 3")
            {
                ApplicationArea = All;
                Caption = 'Address 3';
                ToolTip = 'Specifies the third line of the D365 bill-to address.';
            }
        }
        addafter("Ship-to Address 2")
        {
            field("D365 Ship-to Address 3"; Rec."Ship-to Address 3")
            {
                ApplicationArea = All;
                Caption = 'Address 3';
                ToolTip = 'Specifies the third line of the D365 ship-to address.';
            }
        }
        modify("Sell-to Customer Name")
        {
            trigger OnAfterValidate()
            var

            begin
                Rec."Sales Name" := Rec."Sell-to Customer Name";
                Rec.Modify();
            end;
        }
        addafter(Status)
        {
            field("Percentage"; Rec.Percentage)
            {
                ApplicationArea = All;
                Caption = 'Percentage to Update';
                Visible = false;
            }
            field("Work Order Type"; Rec."Work Order Type")
            {
                ApplicationArea = All;
                Caption = 'Work Order Type';
                // DCS::HP 09092025 HP ++
                Visible = false;
                // DCS::HP 09092025 HP --
            }
            field("Customer PO Number"; Rec."Customer PO Number")
            {
                ApplicationArea = All;
                Caption = 'Customer PO Number';
            }
            // DCS:: aaj

            field("Billing Type"; Rec."Billing Type")
            {
                ApplicationArea = All;
                Caption = 'Billing Type';
            }
            field(Quote; Rec.Quote)
            {
                ApplicationArea = All;
                Caption = 'Quote';
            }
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = All;
                Caption = 'CRM ID';
            }
            field(Owner; Rec.Owner)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
            }

            field("Sales Name"; Rec."Sales Name")
            {
                ApplicationArea = All;
                Caption = 'Name';
                // DCS::HP 09092025 HP ++
                Visible = False;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name field.', Comment = '%';
            }
            // DCS::HP 09092025 HP --
            // DCS :: HJ20251028++
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                Caption = 'Work Order No.';
                DrillDown = true;
                trigger OnDrillDown()
                var
                    Job: Record Job;
                begin
                    if Job.Get(Rec."Job No.") then
                        PAGE.Run(PAGE::"Job Card", Job);
                end;
            }
            field("Blanket Sales Order No."; Rec."Blanket Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Blanket Sales Order No. field.', Comment = '%';
                DrillDown = true;
                Visible = false;
                // trigger OnValidate()
                // var
                //     Job: Record Job;
                // begin
                //     Clear(Job);
                //     if Job.Get(Rec."Job No.") then
                //         Rec.Name := Job.Description;
                // end;

                trigger OnDrillDown()
                var
                    Job: Record Job;
                begin
                    if Job.Get(Rec."Blanket Sales Order No.") then
                        PAGE.Run(PAGE::"Job Card", Job);
                end;
            }

            // DCS :: HJ20251028--


            // field("Blanket Sales Order No."; Rec."Blanket Sales Order No.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Blanket Sales Order No. field.';
            //     DrillDown = true;

            //     trigger OnValidate()
            //     var
            //         Job: Record Job;
            //     begin
            //         Clear(Job);
            //         if Job.Get(Rec."Job No.") then
            //             Rec.Name := Job.Description;
            //     end;

            //     trigger OnDrillDown()
            //     var
            //         Job: Record Job;
            //     begin
            //         if Job.Get(Rec."Blanket Sales Order No.") then
            //             PAGE.Run(PAGE::"Job Card", Job);
            //     end;
            // }



        }
        addafter(General)
        {
            group("Milestone Details")
            {
                field("Percentage To Invoice"; Rec."Percentage To Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the % of the total amount to be invoiced in the current cycle.';

                    // DecimalPlaces = 1 : 4;
                }

                field("Invoiced Percentage"; Rec."Invoiced Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative % of the total amount that has been invoiced.';
                    // Editable = false;
                    // DCS::HP06112024 ++
                    Editable = IsEditable;
                    // DCS::HP06112024 --
                    // DecimalPlaces = 1 : 4;
                }

                field("Remaining Percentage"; Rec."Remaining Percentage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the % of the total amount that remains to be invoiced.';
                    // Editable = false;
                    // DCS::HP06112024 ++
                    Editable = IsEditable;
                    // DCS::HP06112024 --
                    // DecimalPlaces = 1 : 4;
                }

                field("Invoicing Amount"; Rec."Invoicing Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount to be invoiced in the current cycle based on the % To Invoice.';
                    Editable = false;

                }

                field("Amount Invoiced"; Rec."Amount Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cumulative amount that has been invoiced.';
                    // Editable = false;
                    // DCS::HP06112024 ++
                    Editable = IsEditable;
                    // DCS::HP06112024 --
                }

                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount that remains to be invoiced.';
                    // Editable = false;
                    // DCS::HP06112024 ++
                    Editable = IsEditable;
                    // DCS::HP06112024 -- 
                }
            }

        }
        addafter("Milestone Details")
        {
            group("Agreement Details")
            {
                field("Agreement % 1"; Rec."Agreement % 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agreement % 1 field.', Comment = '%';
                }
                field("Agreement % 2"; Rec."Agreement % 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agreement % 2 field.', Comment = '%';
                }
                field("Agreement % 3"; Rec."Agreement % 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Agreement % 3 field.', Comment = '%';
                }
                field("Obrien Business Unit Code 1"; Rec."Obrien Business Unit Code 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Obrien Business Unit Code 1 field.', Comment = '%';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('OBRIEN_BUSINESS UNIT'));
                    // trigger OnValidate()
                    // var
                    //     myInt: Integer;
                    // begin
                    //     if (rec."Obrien Business Unit Code 1" <> '') and (rec."Agreement % 1" = 0) then
                    //         Error('Agreement %% 1 must be filled if Obrien Business Unit Code 1 is entered.');
                    // end;
                }
                field("Obrien Business Unit Code 2"; Rec."Obrien Business Unit Code 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Obrien Business Unit Code 2 field.', Comment = '%';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('OBRIEN_BUSINESS UNIT'));
                    // trigger OnValidate()
                    // begin
                    //     if (rec."Obrien Business Unit Code 2" <> '') and (rec."Agreement % 2" = 0) then
                    //         Error('Agreement %% 2 must be filled if Obrien Business Unit Code 2 is entered.');
                    // end;

                }
                field("Obrien Business Unit Code 3"; Rec."Obrien Business Unit Code 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Obrien Business Unit Code 3 field.', Comment = '%';
                    TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('OBRIEN_BUSINESS UNIT'));
                    // trigger onvalidate()
                    // var
                    //     myInt: Integer;
                    // begin
                    //     if (rec."Obrien Business Unit Code 3" <> '') and (rec."Agreement % 3" = 0) then
                    //         Error('Agreement %% 3 must be filled if Obrien Business Unit Code 3 is entered.');
                    // end;
                }
            }
        }
        addlast(General)
        {
            field("CPI(Yes/No)"; Rec."CPI(Yes/No)")
            {
                ApplicationArea = All;
            }
            field("CIP Renewal Date"; Rec."CIP Renewal Date")
            {
                ApplicationArea = All;
            }
            // DCS::HK 13102025 ++
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = All;
                Caption = 'Invoice Date';
            }
            field("Invoice Date"; Rec."Invoice Date")
            {
                ApplicationArea = All;
                Caption = 'Start Date';
            }
            // DCS::HK 13102025 --
            field("End Date"; Rec."End Date")
            {
                ApplicationArea = All;
            }

            field("Last Invoice Created Date"; Rec."Last Invoice Created Date")
            {
                ApplicationArea = All;
            }
            field("Invoice Frequency"; Rec."Invoice Frequency")
            {
                ApplicationArea = All;
            }
            // DCS::HP 25082025 ++
            field("Agreement ID"; Rec."Agreement ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Agreement ID field.', Comment = '%';
            }
            //DCS::HK 28102025 ++
            field("Full Topic"; Rec."Full Topic")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Topic field.', Comment = '%';
            }
            //DCS::HK 28102025 ++
        }
    }
    actions
    {
        addafter("Archi&ve Document")
        {
            action("Create Invoice")
            {
                Caption = 'Make Invoice';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = CreateDocument;

                trigger OnAction()
                var
                    BlanketOrderToInv: Codeunit "Milestone Invoicing";
                    // DCS::HP 27082025 ++
                    GlobalState: Codeunit "D01 Global State";
                begin
                    GlobalState.SetIsHandled(true);
                    // DCS::HP 27082025 --
                    BlanketOrderToInv.CreateInvoiceFromBlanketOrder(Rec);
                end;
            }
        }
        modify(MakeOrder)
        {
            trigger OnBeforeAction()
            var
                BlanketSalesOrderLine: Record "Sales Line";
            begin
                BlanketSalesOrderLine.SetRange("Document Type", BlanketSalesOrderLine."Document Type"::"Blanket Order");
                BlanketSalesOrderLine.SetRange("Document No.", Rec."No.");

                if BlanketSalesOrderLine.FindSet() then
                    repeat
                        if BlanketSalesOrderLine."Shortcut Dimension 1 Code" = '' then
                            Error('Shortcut Dimension Code cannot be empty in Blanket Sales Order Line %1', BlanketSalesOrderLine."Line No.");
                    until BlanketSalesOrderLine.Next() = 0;
            end;
        }
    }
    // DCS::HP 25082025 ++
    trigger OnOpenPage()
    var
        jobRec: Record Job;
        CurrentUserID: Text;
    begin
        // DCS::HP06112024 ++
        CurrentUserID := UserId();
        // IsEditable := (CurrentUserID = 'TESTA'); // security ID of TESTA
        IsEditable := (CurrentUserID = 'SAI'); // security ID of SAI
        // DCS::HP06112024 --
        if rec."No." = '' then
            exit;
        if rec."Obrien Business Unit Code 1" = '' then
            rec."Obrien Business Unit Code 1" := rec."Shortcut Dimension 1 Code";
        if rec."Agreement % 1" = 0 then
            rec."Agreement % 1" := 100;
        rec.modify();
    end;
    // DCS::HP 25082025 --
    var
        IsEditable: Boolean;

}
