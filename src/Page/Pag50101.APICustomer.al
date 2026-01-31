page 50101 "API Customer"
{
    PageType = API;
    Caption = 'API Customer';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'Customer';
    EntitySetName = 'Customer';
    SourceTable = Customer;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ABN; Rec."ABN No.")//Check
                {
                    Caption = 'ABN';
                }
                field(address; Rec.Address)//Check
                {
                    Caption = 'Address';
                }
                field(addressname; Rec."Address Name")//Check
                {
                    Caption = 'Address Name';
                }
                field("address2"; Rec."Address 2")//Check
                {
                    Caption = 'Address 2';
                }
                field("address3"; Rec."Address 3")//Check
                {
                    Caption = 'Address 3';
                }
                field("BlockPaymentTolerance"; Rec."Block Payment Tolerance")//Check
                {
                    Caption = 'Block Payment Tolerence';
                }
                field("CapexFrom"; Rec."Capex From")//Check
                {
                    Caption = 'Capex From';
                }
                field("CapexTo"; Rec."Capex To")//Check
                {
                    Caption = 'Capex To';
                }
                field("city"; rec."D365 City")//Check
                {
                    Caption = 'City';
                }
                field("ContactGroup"; Rec."Contact Group")//Check
                {
                    Caption = 'Contact Group';
                }
                field("country"; Rec."D365 Country")//Check
                {
                    Caption = 'Country/Region Code';
                }
                field(county; Rec.County)//Check
                {
                    Caption = 'County';
                }
                field("CreditHold"; Rec."Credit Hold")//Check
                {
                    Caption = 'Credit Hold';
                }
                field("CreditLimitLCY"; Rec."Credit Limit (LCY)")//Check
                {
                    Caption = 'Credit Limit';
                }
                field(crmid; Rec."CRM ID")//Check
                {
                    Caption = 'CRM ID';
                }
                field("CurrencyCode"; Rec."Currency Code")//Check
                {
                    Caption = 'Currency Code';
                }
                field("CustomerPriceGroup"; Rec."Customer Price Group")//Check
                {
                    Caption = 'Customer Price Group';
                }
                field("CustomerPriceGroupId"; Rec."Customer Price Group Id")//Check
                {
                    Caption = 'Customer Price Group Id';
                }
                field("CustomerProfile"; Rec."Customer Profile")//Check
                {
                    Caption = 'Customer Profile';
                }
                field(Description; Rec.Description)//Check
                {
                    Caption = 'Description';
                }
                field(Dimension; Rec.Dimension)//Check
                {
                    Caption = 'Dimension';
                }
                field("DimensionId"; Rec."Dimension Id")//Check
                {
                    Caption = 'Dimension Id';
                }
                field("d365accountid"; Rec."D365 Account ID")//Check
                {
                    Caption = 'Account Id';
                }
                field("EMail"; Rec."E-Mail")//Check
                {
                    Caption = 'Caption';
                }
                field("FaxNo"; Rec."Fax No.")//Check
                {
                    Caption = 'Fax No';
                }
                field(Name; Rec.Name)//Check
                {
                    Caption = 'Name';
                }
                field(ownerid; Rec."Owner Id")//Check
                {
                    Caption = 'Owner ID';
                }
                // DCS::HP 20253107 ++
                field(owner; Rec.Owner)
                {
                    Caption = 'Owner';
                }

                field("PaymentMethodCode"; Rec."Payment Method Code")//Check
                {
                    Caption = 'Payment Method Code';
                }
                field("PaymentTermsCode"; Rec."Payment Terms Code")//Check
                {
                    Caption = 'Payment Terms Code';
                }
                field("phoneno"; Rec."Phone No.")//Check
                {
                    Caption = 'Phone No.';
                }
                field("postcode"; Rec."D365 Post Code")//Check
                {
                    Caption = 'Postal Code';
                }
                field("privacyblocked"; Rec."Privacy Blocked")//Check
                {
                    Caption = 'Privacy Blocked';
                }
                field(primarycontact; Companycontact())//Check
                {
                    Caption = 'no';
                }
                field("sapcustomernumber"; Rec."SAP Customer Number")//Check
                {
                    Caption = 'SAP Customer No.';
                }
                field("ServiceAgreement"; Rec."Service Agreement")//Check
                {
                    Caption = 'Service Agreement';
                }
                field(state; Rec."D365 State")    //Check
                {
                    Caption = 'State';
                }
                field(supplieraccountgroup; Rec."Supplier Account Group")//Check
                {
                    Caption = 'Supplier Account Group';
                }
                field("territorycode"; Rec.Territory)//Check
                {
                    Caption = 'Territory Code';
                }
                field("territorycodeid"; Rec."Territory Code ID")//Check
                {
                    Caption = 'Territory Code Id';
                }
                field(WEB; Rec.WEB)//Check
                {
                    Caption = 'WEB';
                }
                field("genbuspostinggroup"; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field("customerpostinggroup"; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                }
                field(reasonCode; Rec."Reason Code")
                {
                    Caption = 'Reason Code';
                }
            }
        }
    }
    // trigger OnAfterGetRecord()
    // begin
    //     Rec.CalcFields("Company Contact");
    // end;

    // trigger OnAfterGetCurrRecord()
    // var
    // begin
    //     Rec.CalcFields("Company Contact");
    // end;

    local procedure Companycontact(): text
    var
        myInt: Integer;
    begin
        Rec.CalcFields("Company Contact");
        exit(format(Rec."Company Contact"));
    end;

}

