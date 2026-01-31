page 50100 "API Contact"
{
    PageType = API;
    Caption = 'API Employee';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'Contact';
    EntitySetName = 'Contact';
    SourceTable = Contact;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field("d365contactid"; Rec."D365 Contact ID")
                {
                    Caption = 'D365 Contact ID';
                }
                field(companycontactid; Rec."Company No.")
                {
                    Caption = 'Company ID';
                }

                field(description; Rec.Description) { }
                field(firstname; Rec."Name")
                {
                    Caption = 'First Name';
                }
                field(middlename; Rec."Middle Name")
                {
                    Caption = 'Middle Name';
                }
                field(lastname; Rec."Surname")
                {
                    Caption = 'Surname';
                }
                field(addressname; Rec."Address Name") { }
                field(address; Rec.Address)
                {
                    Caption = 'Address 2 Street 1';
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2 Street 2';
                }
                field(address3; Rec."Address 3")
                {
                    Caption = 'Address 2 Street 3';
                }
                field(city; Rec."D365 City")
                {
                    Caption = 'City';
                }
                field(state; Rec."D365 State") { }
                field(county; Rec.County)
                {
                    Caption = 'County';
                }
                field(country; Rec."D365 Country")
                {
                    Caption = 'Country';
                }
                field(postcode; Rec."D365 Post Code")
                {
                    Caption = 'PostCode';
                }
                field(currency; Rec."D365 Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(currencycrmid; Rec."Currency CRM Id")
                {
                    Caption = 'Currency CRM Id';
                    // trigger OnValidate()
                    // var
                    //     currencyRec: Record Currency;
                    // begin
                    //     currencyRec.SetRange("CRM ID", Rec."Currency CRM Id");
                    //     if currencyRec.FindFirst() then
                    //         rec."D365 Currency Code" := currencyRec.Code;
                    // end;
                }
                field(faxno; Rec."Fax No.")
                {
                    Caption = 'Fax No';
                }
                // DCS:: HP 13082025 ++
                field(jobtitle; Rec."D365 Job Title")
                // DCS:: HP 13082025 --
                {
                    Caption = 'D365 Job Title';
                }
                field(phoneno; Rec."Phone No.")
                {
                    Caption = 'Phone No';
                }
                field(email; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(mobilephoneno; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No';
                }
                field(dimension; Rec.Dimension)
                {
                    Caption = 'Dimension';
                }
                field(dimensionid; Rec."Dimension ID")
                {
                    Caption = 'Dimension ID';
                }
                field(emailgroupcode; Rec."E-Mail Group Code")
                {
                    Caption = 'Email Group Code';
                }
                field(companyid; Rec."Company Name")
                {
                    Caption = 'Company Name';
                }
                field(owner; Rec.Owner)
                {
                    Caption = 'Owner';
                }

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        rec."Contact Business Relation" := rec."Contact Business Relation"::Customer;
    end;

    trigger OnInit()
    var
        myInt: Integer;
    begin
        rec."Contact Business Relation" := rec."Contact Business Relation"::Customer;
    end;
}