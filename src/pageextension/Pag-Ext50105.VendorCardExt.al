pageextension 50105 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        modify(ABN)
        {
            Editable = true;
            Enabled = true;
            Visible = true;
            ShowMandatory = true;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        // modify("Country/Region Code")
        // {
        //     Visible = false;
        // }
        modify(City)
        {
            Visible = false;
        }
        modify(County)
        {
            Visible = false;
        }
        modify(MobilePhoneNo)
        {
            visible = false;
        }
        // DCS::HP 14082025 ++
        modify("Primary Contact No.")
        {
            trigger OnAfterValidate()
            var
                contactRec: Record Contact;
            begin
                contactRec.SetRange("No.", rec."Primary Contact No.");
                if contactRec.FindFirst() then
                    rec."Primary Contact ID" := contactRec."CRM ID";
            end;
        }
        modify("Currency Code")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                CurrencyRec: Record Currency;
                CurrencyPage: Page "Currencies";
            begin
                CurrencyRec.SetRange(Code);
                CurrencyRec.SetFilter(Code, '<>%1', 'AUD');

                CurrencyPage.SetTableView(CurrencyRec);
                CurrencyPage.LookupMode(true);

                if CurrencyPage.RunModal() = Action::LookupOK then begin
                    CurrencyPage.GetRecord(CurrencyRec);
                    Rec."Currency Code" := CurrencyRec.Code;
                end;

                exit(true);
            end;
        }
        addafter(General)
        {
            group("D365 CUSTOM FIELDS")
            {
                field("Is Also a Customer"; Rec."Is Also a Customer")
                {
                    ApplicationArea = All;
                    Caption = 'Is Also a Customer';
                }
                field("Vendor Profile"; Rec."Vendor Profile")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Profile';
                }
                field("D365 Account ID"; Rec."D365 Account ID")
                {
                    ApplicationArea = All;
                    Caption = 'D365 Account ID';
                }
                field("SAP Vendor Number"; Rec."SAP Vendor Number")
                {
                    ApplicationArea = All;
                    Caption = 'SAP Vendor Number';
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
                field("Customer Group"; Rec."Customer Group")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Group';
                    Visible = false;
                }
                field("Contact Groups"; Rec."Contact Groups")
                {
                    ApplicationArea = All;
                    Caption = 'Contact Group';
                }
                field(Dimension; Rec.Dimension)
                {
                    ApplicationArea = all;
                    Caption = 'Dimension';
                    TableRelation = "Dimension Value".Code;
                }
                field("Dimension ID"; Rec."Dimension ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimension ID field.', Comment = '%';
                }

                field("CreditHold"; Rec."Credit Hold")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Hold';
                    // DCS:: HP 17092025 ++
                    visible = false;
                    // DCS:: HP 17092025 --

                }
                // DCS:: HP 17092025 ++
                field("Credit Limit"; Rec."Credit Limit")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Limit';
                    ToolTip = 'Specifies the value of the Credit Limit field.', Comment = '%';
                }
                // DCS:: HP 17092025 --
                // DCS::HP 30072025++
                field("Owner"; Rec."Owner")
                {
                    ApplicationArea = all;
                }
                // DCS::HP 30072025--
                field("Owner Ship"; Rec."Owner Ship")
                {
                    ApplicationArea = all;
                }
                field("Supplier account Group"; Rec."Supplier account Group")
                {
                    ApplicationArea = all;
                    Caption = 'Supplier Account Group';
                }
                field(WEB; Rec.WEB)
                {
                    ApplicationArea = all;
                    Caption = 'Web';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Caption = 'Description';
                }
                field("Company Conatct"; Rec."Company Conatct")
                {
                    ApplicationArea = all;
                    Caption = 'Company Contact';
                }
                field("CRM ID"; Rec."CRM Id")
                {
                    ApplicationArea = all;
                    Caption = 'CRM ID';
                    Editable = true;
                    ToolTip = 'Specifies the CRM ID for this vendor';
                }
                field("Territory"; Rec."Territory Code")
                {
                    ApplicationArea = all;
                    Caption = 'Territory Code';
                    TableRelation = Territory.Code;
                }
                field("Primary Contact ID"; Rec."Primary Contact ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Primary Contact ID field.', Comment = '%';
                }
            }
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
                Visible = false;
            }

            field("D365 City"; Rec."D365 City")
            {
                ApplicationArea = All;
                Caption = 'City';
            }

            field("D365 Postal Code"; Rec."D365 Postal Code")
            {
                ApplicationArea = All;
                Caption = 'PostCode';
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
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                Rec."Payment Method Code" := 'EFT';
                Rec."EFT Payment" := true;

                // Rec."EFT Bank Account No." := 'ANZ';
                Rec.Modify();
            end;
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
                    VendorCRM: Codeunit "Vendor CRM Integration";
                begin
                    rec.testfield(owner);//Pankaj_10Oct2025
                    VendorCRM.UpdateCRMAccount(Rec);
                    Message('Vendor successfully updated in CRM.');
                end;
            }


        }
        modify("Vendor - Summary Aging")
        {
            Visible = false;
        }
        addafter("Vendor - Summary Aging")
        {
            action("Aged Accounts Payable")
            {
                ApplicationArea = All;
                Caption = 'Aged Accounts Payable';
                Image = Aging;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'ViewAged Accounts Payable';

                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.Reset();
                    Vendor.SetRange("No.", Rec."No.");
                    if Vendor.FindFirst() then begin
                        Report.RunModal(Report::"Aged Accounts Payable", true, false, Vendor);
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage();
    var
        UserSetupRec: Record "User Setup";
        IsUserAllowed: Boolean;
        Vendor: Record Vendor;
    begin
        Vendor.Reset();
        Vendor.SetRange("No.", Rec."No.");
        if Vendor.FindFirst() then begin
            Vendor."Payment Method Code" := 'EFT';
            Vendor."EFT Payment" := true;
            // Vendor."EFT Bank Account No." := 'ANZ';
            Vendor.Modify(true);
        end;
        if UserSetupRec.Get(UserId()) then begin
            IsUserAllowed := UserSetupRec."Allow Edit Mode";
        end else begin
            IsUserAllowed := false;
        end;

        if not IsUserAllowed then
            CurrPage.Editable(false);
    end;

    // trigger OnAfterGetRecord()
    // var
    //     UserSetupRec: Record "User Setup";
    // begin
    //     if UserSetupRec.Get(UserId()) then begin
    //         rec.owner := UserSetupRec."User ID";
    //         rec.modify();
    //         rec."Owner Ship" := UserSetupRec."Owner Ship";
    //     end;
    // end;
}
