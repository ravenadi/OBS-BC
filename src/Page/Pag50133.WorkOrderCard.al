page 50133 "Work Order Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Work Order";
    Caption = 'Work Order Card';
    AboutTitle = 'Work Order Card';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group("General")
            {
                field("Work Order Number"; rec."Work Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Work Order Number';
                    ShowMandatory = true;
                }
                field("Service Account"; rec."Service Account")
                {
                    ApplicationArea = All;
                    Caption = 'Service Account';
                    ShowMandatory = true;
                }
                field("Work Order Type"; rec."Work Order Type")
                {
                    ApplicationArea = All;
                    Caption = 'Work Order Type';
                    ShowMandatory = true;
                }
                field("System Status"; Rec."System Status")
                {
                    ApplicationArea = All;
                    Caption = 'System Status';
                }
                field("CRM ID"; Rec."CRM ID")
                {
                    ApplicationArea = all;
                }
                field("Substatus"; Rec.Substatus)
                {
                    ApplicationArea = All;
                    Caption = 'Substatus';
                }
                field("Agreement"; rec.Agreement)
                {
                    ApplicationArea = All;
                    Caption = 'Agreement';
                }
                field("Project No"; Rec."Job No.")
                {
                    ApplicationArea = all;
                    Caption = 'Project No.';
                }
                field("Project Task No"; Rec."Project Task No")
                {
                    ApplicationArea = all;
                    Caption = 'Project Task No.';
                }
                field("Billing Account"; Rec."Billing Account")
                {
                    ApplicationArea = All;
                    Caption = 'Billing Account';
                }
                field("Customer PO Number"; Rec."Customer PO Number")
                {
                    ApplicationArea = all;
                }
                field("Billing Type"; rec."Billing Type")
                {
                    ApplicationArea = All;
                    Caption = 'Billing Type';
                }
                field("Case Custom"; Rec."Case Custom")
                {
                    ApplicationArea = All;
                    Caption = 'Case';
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Terms';
                }
                field("Job Created"; Rec."Job Created")
                {
                    ApplicationArea = all;
                    Caption = 'Job Created';
                }
                field("Contact"; rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                }
                field("Currency"; rec.Currency)
                {
                    ApplicationArea = All;
                    Caption = 'Currency';
                }
            }
            part("Lines"; "Work Order Lines Subform")
            {
                ApplicationArea = basic, suite;
                SubPageLink = "Work Order No." = FIELD("Work Order No.");
            }
            group(Billing)
            {
                field("Fix Type"; rec."Fix Type")
                {
                    ApplicationArea = All;
                    Caption = 'Fix Type';
                }
                field("Functional Location"; rec."Functional Location")
                {
                    ApplicationArea = All;
                    Caption = 'Functional Location';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    ApplicationArea = all;
                }
                field("Opportunity"; rec.Opportunity)
                {
                    ApplicationArea = All;
                    Caption = 'Opportunity';
                }
                field("Owner"; rec.Owner)
                {
                    ApplicationArea = All;
                    Caption = 'Owner';
                }
                field("Parent Work Order"; rec."Parent Work Order")
                {
                    ApplicationArea = All;
                    Caption = 'Parent Work Order';
                }
                field("Sales Order"; Rec."Sales Order")
                {
                    ApplicationArea = All;
                    Caption = 'Sales Order No.';
                }
                field("Blanket Order"; Rec."Blanket Order")
                {
                    ApplicationArea = All;
                    Caption = 'Blanket Order No.';
                }
                field("Taxable"; rec.Taxable)
                {
                    ApplicationArea = All;
                    Caption = 'Taxable';
                }
                field("Time Window Start"; rec."Time Window Start")
                {
                    ApplicationArea = All;
                    Caption = 'Time Window Start';
                }
                field("Time Window End"; rec."Time Window End")
                {
                    ApplicationArea = All;
                    Caption = 'Closed On Date';
                }
                // DCS::HP 081025 ++
                field("D365 Ending Date"; Rec."D365 Ending Date")
                {
                    Caption = 'Time Window End';
                    ApplicationArea = All;
                }
                // DCS::HP 081025 --

                field("Topic"; rec.Topic)
                {
                    ApplicationArea = All;
                    Caption = 'Topic';
                    ShowMandatory = true;
                }
                field("Full Topic"; Rec."Full Topic")
                {
                    ToolTip = 'Specifies the value of the Full Topic field.', Comment = '%';
                    ApplicationArea = all;
                }
                field("Work Description"; rec."Work Description")
                {
                    ApplicationArea = All;
                    Caption = 'Work Description';
                }
                field("Work Location"; rec."Work Location")
                {
                    ApplicationArea = All;
                    Caption = 'Work Location';
                }
                field("Work Order Summary"; rec."Work Order Summary")
                {
                    ApplicationArea = All;
                    Caption = 'Work Order Summary';
                }
                field("Status"; rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
            }
        }
        area(FactBoxes)
        {
            part("Attachments"; "Document Attachment FactBox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.Update(false);
    end;

}