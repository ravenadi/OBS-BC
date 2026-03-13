pageextension 50131 "Job Card Ext" extends "Job Card"
{
    layout
    {
        addafter(Description)
        {   // DCS::HK 13102025 ++
            field("Full Topic"; Rec."Full Topic")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Topic field.', Comment = '%';
            }
            // DCS::HK 13102025 --
            field("Work Order Type"; Rec."Work Order Type")
            {
                ApplicationArea = all;
                Caption = 'Work Order Type';
                Visible = true;
            }
            field("Service Account"; Rec."Service Account")
            {
                ApplicationArea = all;
                Caption = 'Service Account';
                Visible = false;
            }
        }
        // DCS::HP 081025 ++
        modify("Ending Date")
        {
            Caption = 'Closed On Date';
            ToolTip = 'Specifies the value of the Closed On Date field.', Comment = '%';
        }
        addafter("Ending Date")
        {
            field("D365 Ending Date"; Rec."D365 Ending Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
            }
        }
        // DCS::HP 081025 --
        addlast(General)
        {
            field("System Status"; Rec."System Status")
            {
                ApplicationArea = All;
                Caption = 'System Status';

            }
            field("Billing Type"; Rec."Billing Type")
            {
                ApplicationArea = All;
                Caption = 'Billing Type';
            }
            field("Customer PO Number"; Rec."Customer PO Number")
            {
                ApplicationArea = All;
                Caption = 'Customer PO Number';
            }
            field("Sales Order No."; Rec."Sales Order")
            {
                ApplicationArea = All;
                Caption = 'Blanket Order No.';
                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Blanket Order");
                    SalesHeader.SetRange("No.", Rec."Sales Order");

                    if SalesHeader.FindFirst() then
                        Page.RunModal(Page::"Blanket Sales Order", SalesHeader)
                end;
            }
            field("Substatus"; Rec."Substatus")
            {
                ApplicationArea = All;
                Caption = 'Substatus';

            }
            // DCS::HP 290925 ++
            field(Owner; Rec.Owner)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
            }
            // DCS::HP 290925 --
            field(Case_Custom; Rec."Case Custom")
            {
                ApplicationArea = All;
                Caption = 'Case';
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Caption = 'Obrien Business Unit Code';
                ShowMandatory = true;
            }
            field("Invoice Created"; Rec."Invoice Created")
            {
                ApplicationArea = All;
                Caption = 'Invoice Created';
            }
            // HP::DCS 061025 ++
            // DCS::HP02122025 ++
            field("Crm Id"; Rec."Crm Id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Crm Id field.', Comment = '%';
                Caption = 'CRM ID';
            }
            // DCS::HP02122025 --
            field("Primary Incident Type"; Rec."Primary Incident Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Primary Incident Type field.', Comment = '%';
            }
            field("SAP Service ID"; Rec."SAP Service ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SAP Service ID field.', Comment = '%';
            }
            field(Agreement; Rec.Agreement)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Agreement field.', Comment = '%';
            }
            field("Parent Work Order"; Rec."Parent Work Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Parent Work Order field.', Comment = '%';
            }
            // HP::DCS 061025 --
            //DCS ::HJ20250311 ++
            field("Status Manual Edit"; Rec."Status Manual Edit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status Manual Edit field.', Comment = '%';
            }
            //DCS ::HJ20250311 --
        }
    }
    actions
    {
        addafter("&Dimensions")
        {
            action(UpadateCRM)
            {
                Caption = 'Update To CRM';
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update this to CRM';

                trigger OnAction()
                var
                    ProjectToCRM: Codeunit "Update Project to Crm";
                begin
                    CurrPage.SaveRecord();
                    ProjectToCRM.UpdateCRMAccount(Rec);
                    Message('Successfully updated in CRM.');
                end;
            }
        }
    }
    // DCS::HP 22082025 ++
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //rec.TestField("Global Dimension 1 Code");
    end;
    // DCS::HP 22082025 --

    // DCS::HP 25082025 ++
    // trigger OnAfterGetRecord()

    trigger OnAfterGetRecord()
    var
        blanketRec: record "Sales Header";
    begin
        if not Rec."Status Manual Edit" then begin
            blanketRec.Reset();
            blanketRec.SetRange("Document Type", blanketRec."Document Type"::"Blanket Order");
            blanketRec.SetRange("No.", rec."Sales Order");
            if blanketRec.FindFirst() then
                if (rec.PercentInvoiced() = 100) or (blanketRec."Invoiced Percentage" = 100) then begin
                    rec."Invoice Created" := true;
                    rec.Validate("System Status", rec."System Status"::Invoiced);
                    rec.Modify(true);
                    Commit();
                end;
        end;
    end;

    // DCS::HP 25082025 --
}