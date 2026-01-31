pageextension 50101 "Contact Card Ext" extends "Contact Card"
{
    layout
    {
        modify("Company Name")
        {
            Visible = false;
        }
        modify("Company No.")
        {
            Visible = false;
        }
        // DSC::HP 08082025 ++
        modify("Currency Code")
        {
            Visible = false;
        }
        // DSC::HP 08082025 --
        modify("Contact Business Relation")
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
            trigger OnbeforeValidate()
            begin
                if (rec."D365 City" <> '') or (Rec."D365 City" <> xRec."D365 City") then begin
                    Rec.City := Rec."D365 City";
                end;
            end;
        }
        modify("Post Code")
        {
            Visible = false;
        }

        modify(County)
        {
            Caption = 'County';
            Visible = false;
        }
        addafter(General)
        {
            group("D365 CUSTOM FIELDS")
            {
                field("D365 Contact ID"; Rec."D365 Contact ID")
                {
                    ApplicationArea = All;
                    Caption = 'D365 Contact ID';
                }
                field("E-Mail Group Code"; Rec."E-Mail Group Code")
                {
                    ApplicationArea = All;
                    Caption = 'E-Mail Group Code';
                }
                // DCS::HP 290925 ++
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
                }
                // DCS::HP 290925 --
                // DCS::HP30092025 ++
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.', Comment = '%';
                }
                field("Preferred Method of Contact"; Rec."Preferred Method of Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Preferred Method of Contact field.', Comment = '%';
                }
                field("E-Mail 2"; Rec."E-Mail 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email 2 field.', Comment = '%';
                }
                field("Business Phone 2"; Rec."Business Phone 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business Phone 2 field.', Comment = '%';
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Method field.', Comment = '%';
                }
                field("Payment terms"; Rec."Payment terms")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment terms field.', Comment = '%';
                }
                field("Address 2: Name"; Rec."Address 2: Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2: Name field.', Comment = '%';
                }
                field("Address 2 Street1"; Rec."Address 2 Street1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
                }
                field("Address 2 Street 2"; Rec."Address 2 Street 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field.', Comment = '%';
                }
                field("Address 2 Street 3"; Rec."Address 2 Street 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 3 Street 3 field.', Comment = '%';
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
                field(Fax; Rec.Fax)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Fax field.', Comment = '%';
                }
                // DCS::HP30092025 --
            }
        }
        addbefore(Address)
        {
            field("Address Name"; Rec."Address Name")
            {
                Caption = 'Address Name';
                ApplicationArea = all;
            }

        }
        addafter(Name)
        {
            field(Surname; Rec.Surname)
            {
                Caption = 'Last Name';
                ApplicationArea = All;
            }
        }

        addafter("Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = all;
            }
        }
        addafter("D365 Contact ID")
        {
            field("Description"; Rec.Description)
            {
                Caption = 'Description';
                ApplicationArea = All;
            }
            field(Dimension; Rec.Dimension)
            {
                Caption = 'Dimension';
                ApplicationArea = All;
            }
            field("CRM Id"; Rec."CRM ID")
            {
                Caption = 'CRM Id';
                ApplicationArea = All;
            }
            field("Company Name Crm"; Rec."Company Name Crm")
            {
                Caption = 'Company Name';
                ApplicationArea = all;
            }
            field("Company Contact"; Rec."Company Contact")
            {
                Caption = 'Company Contact';
                ApplicationArea = all;
            }
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
            field("D365 Postal Code"; Rec."D365 Post Code")
            {
                ApplicationArea = All;
                Caption = 'Post Code';
            }
            field("D365 Job Title"; Rec."D365 Job Title")
            {
                ApplicationArea = All;
                Caption = 'Job Title';
            }
            // DCS::HP 12082025 ++
            field("Dimension ID"; Rec."Dimension ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Dimension ID field.', Comment = '%';
            }
            field("D365 Currency Code"; Rec."D365 Currency Code")
            {
                ApplicationArea = All;
                Caption = 'Currency Code';
                ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
            }
            field("Currency CRM Id"; Rec."Currency CRM Id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency CRM Id field.', Comment = '%';
            }

            // DCS::HP 12082025 --

        }

    }
    actions
    {
        addlast(processing)
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
                    ContactCrm: Codeunit "Contact Crm Management";
                begin
                    ContactCrm.UpadeToCrm(Rec);
                    Message('Contact successfully updated in CRM.');
                end;
            }
        }
    }
}
