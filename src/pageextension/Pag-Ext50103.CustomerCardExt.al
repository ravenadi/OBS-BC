pageextension 50103 "Customer Card Ext" extends "Customer Card"
{
    layout
    {

        modify(ABN)             // Used Custom Field ABN No. instead of ABN
        {
            Editable = true;
            Enabled = true;
            Visible = true;

        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
        addafter(General)
        {
            group("D365 CUSTOM FIELDS")
            {

                field("Customer Profile"; Rec."Customer Profile")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Profile';
                }
                field("Supplier account Group"; Rec."Supplier account Group")
                {
                    ApplicationArea = All;
                    Caption = 'Supplier account Group';
                    ShowMandatory = true;
                    Editable = true;
                    Visible = true;
                }
                field("D365 Account ID"; Rec."D365 Account ID")
                {
                    ApplicationArea = All;
                    Caption = 'D365 Account ID';
                }
                field("SAP Customer Number"; Rec."SAP Customer Number")
                {
                    ApplicationArea = All;
                    Caption = 'SAP Customer Number';
                }
                field("Service Agreement"; Rec."Service Agreement")
                {
                    Caption = 'Service Agreement';
                    ApplicationArea = All;
                }
                field("Account Contract Manager"; Rec."Account Contract Manager")
                {
                    ApplicationArea = All;
                    Caption = 'Account Contract Manager';

                }
                field("Capex From"; Rec."Capex From")
                {
                    ApplicationArea = All;
                }
                field("Capex To"; Rec."Capex To")
                {
                    ApplicationArea = All;
                    Caption = 'Capex To';
                }
                field("Contact Group"; Rec."Contact Group")
                {
                    ApplicationArea = all;
                }
                field(Dimension; Rec.Dimension)
                {
                    ApplicationArea = all;
                    Caption = 'Dimension';
                }
                field("Dimension ID"; Rec."Dimension ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimension ID field.', Comment = '%';
                }

                field("Credit Hold"; Rec."Credit Hold")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    MultiLine = true;
                }
                field("Import Serial No"; Rec."Import Serial No")
                {
                    ApplicationArea = all;
                }
                // DCS::HP 30072025++
                field("Owner"; Rec."Owner")
                {
                    ApplicationArea = all;
                }
                // DCS::HP 30072025--
                field("Owner Ship"; Rec."Owner Ship")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("crmid"; Rec."CRM ID")
                {
                    ApplicationArea = all;
                }
                field(WEB; Rec.WEB)
                {
                    ApplicationArea = all;
                    Caption = 'Web';
                }
                field("Territory Code"; Rec."Territory")
                {
                    ApplicationArea = all;
                    Caption = 'Territory Code';
                    // ::DCS HP-01082025++
                    Visible = false;
                    // ::DCS HP-01082025--
                }
                field("Primary Contact"; Rec."Company Contact")
                {
                    ApplicationArea = all;
                    Caption = 'Company Contact';
                }
                // ::DCS HP-01082025++
                field("Territory Code 1"; Rec."Territory Code")
                {
                    ApplicationArea = all;
                    Caption = 'Territory Code';
                }
                // ::DCS HP-01082025--
            }
        }
        addlast("Address & Contact")
        {
            field("D365 State"; Rec."D365 State")
            {
                ApplicationArea = All;
                Caption = 'State';
            }

            field("D365 Country"; Rec."D365 Country")
            {
                ApplicationArea = All;
                Caption = 'Country';
            }

            field("D365 City"; Rec."D365 City")
            {
                ApplicationArea = All;
                Caption = 'City';
            }

            field("D365 PostCode"; Rec."D365 Post Code")
            {
                ApplicationArea = All;
                Caption = 'PostCode';
                trigger OnValidate()
                begin
                    if Rec."D365 Post Code" <> '' then
                        Rec."Post Code" := Rec."D365 Post Code";
                end;
            }
            field("Custom No."; Rec."Custom No")
            {
                ApplicationArea = All;
                Caption = 'Custom No';
                Lookup = true;
                LookupPageId = "Customer List";
                // trigger OnLookup(var txt: Text): Boolean
                // var
                //     customer2: Record Customer;
                //     customerlist: Page "Customer List";
                //     Counter: Integer;
                //     OldCusNo: code[250];
                //     Count: integer;
                // begin
                //     customerlist.LookupMode(true);
                //     if customerlist.RunModal() = Action::LookupOK then begin
                //         customerlist.SetSelection(customer2);
                //         customerlist.SetTableView(customer2);
                //         customerlist.GetRecord(customer2);
                //         if customer2.FindSet() then
                //             repeat
                //                 count := customer2.count();
                //                 if OldCusNo <> customer2."No." then
                //                     Counter := Counter + 1;
                //                 if Count > Counter then begin
                //                     Rec."Custom No" += format(customer2."No.") + '|'
                //                 end else
                //                     Rec."Custom No" += format(customer2."No.");
                //                 OldCusNo := customer2."No.";
                //             until customer2.Next() = 0;

                //     end;
                // end;


            }
            // DCS::HP30092025 ++
            field("Address 2: Name"; Rec."Address 2: Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: Name field.', Comment = '%';
            }
            field("Address 2: Street 1"; Rec."Address 2: Street 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: Street 1 field.', Comment = '%';
            }
            field("Address 2: Street 2"; Rec."Address 2: Street 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: Street 2 field.', Comment = '%';
            }
            field("Address 2: Street 3"; Rec."Address 2: Street 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: Street 3 field.', Comment = '%';
            }
            field("Address 2: City"; Rec."Address 2: City")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: City field.', Comment = '%';
            }
            field("Address 2: State/Province"; Rec."Address 2: State/Province")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: State/Province field.', Comment = '%';
            }
            field("Address 2: ZIP/Postal Code"; Rec."Address 2: ZIP/Postal Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: ZIP/Postal Code field.', Comment = '%';
            }
            field("Address 2: Country/Region"; Rec."Address 2: Country/Region")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address 2: Country/Region field.', Comment = '%';
            }
            field("Billing Account"; Rec."Billing Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Billing Account field.', Comment = '%';
            }
            // DCS::HP30092025 --
        }
        addafter("Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = all;
            }
        }
        addbefore(Address)
        {
            field("Address Name"; Rec."Address Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Privacy Blocked")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Privacy Blocked" then begin
                    Rec."Reason Code" := rec."Reason Code"::Inactive;
                    Rec.Modify();
                end;
            end;
        }
        addlast(General)
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
            }
        }


    }

    actions
    {
        addlast(navigation)
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
                    CustomerCRM: Codeunit "Customer Crm Management";
                    // ShipToCRM: Codeunit "Ship-To Add Crm Management";
                    // ShipTo: Record "Ship-to Address";
                begin
                    CustomerCRM.UpdateCRMAccount(Rec);
                    // ShipTo.SetRange("Customer No.", Rec."No.");
                    // if ShipTo.FindSet() then
                    //     repeat
                    //         ShipToCRM.UpdateTheRecord(ShipTo);
                    //     until ShipTo.Next() = 0;
                    Message('Successfully updated in CRM.');
                end;
            }
            action(CustomerStatementExcel)
            {
                Caption = 'Customer Statement Excel';
                ApplicationArea = All;
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // ToolTip = 'Update this to CRM';

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    CurrPage.SetSelectionFilter(Customer);
                    Report.Run(Report::"Customer Statement Cust Excel", true, false, Customer);
                end;
            }
            action("Report Statement Custom")
            {
                ApplicationArea = All;
                Caption = 'Statement Custom';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = "Report";
                ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomReportSelection: Record "Custom Report Selection";
                    ReportSelections: Record "Report Selections";
                    CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                    RecRef: RecordRef;
                begin
                    RecRef.Open(Database::Customer);
                    CustomLayoutReporting.SetOutputFileBaseName(StatementFileNameTxt);
                    CustomReportSelection.SetRange(Usage, Enum::"Report Selection Usage"::"C.Statement");
                    CustomReportSelection.SetRange("Source Type", Database::Customer);
                    CustomReportSelection.SetRange("Source No.", Rec."No.");
                    if CustomReportSelection.FindFirst() then
                        CustomLayoutReporting.SetTableFilterForReportID(CustomReportSelection."Report ID", '')
                    else begin
                        ReportSelections.SetRange(Usage, Enum::"Report Selection Usage"::"C.Statement");
                        if ReportSelections.FindFirst() then
                            CustomLayoutReporting.SetTableFilterForReportID(ReportSelections."Report ID", Rec."No.")
                        else
                            CustomLayoutReporting.SetTableFilterForReportID(Report::"Standard Statement", Rec."No.");
                    end;
                    CustomLayoutReporting.ProcessReportData(
                    Enum::"Report Selection Usage"::"C.Statement", RecRef, Customer.FieldName("No."),
                    Database::Customer, Customer.FieldName("No."), true);
                end;
            }
        }
    }
    // trigger OnAfterGetRecord()
    // var
    //     UserSetupRec: Record "User Setup";
    // begin
    //     if UserSetupRec.Get(UserId()) then begin
    //         rec.owner := UserSetupRec."User ID";
    //         rec.Modify();
    //     end;
    // end;

    trigger OnOpenPage();
    var
        UserSetupRec: Record "User Setup";
        IsUserAllowed: Boolean;
        ContactRec: Record Contact;

    begin

        if UserSetupRec.Get(UserId()) then begin
            IsUserAllowed := UserSetupRec."Customer Card";
        end else begin
            IsUserAllowed := false;
        end;

        if not IsUserAllowed then
            CurrPage.Editable(false);
    end;

    var
        StatementFileNameTxt: Label 'Statement', Comment = 'Shortened form of ''Customer Statement''';
}

