page 50103 "API Vendor"
{
    PageType = API;
    EntitySetName = 'Vendors';
    EntityName = 'Vendors';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    APIPublisher = 'integration';
    DelayedInsert = true;
    SourceTable = Vendor;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(abn; Rec."ABN No.")
                {
                    Caption = 'ABN';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(addressname; Rec."Address Name")
                {
                    Caption = 'Address Name';
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(address3; Rec."Address 3")
                {
                    Caption = 'Address 3';
                }
                field(blockpaymenttolerance; Rec."Block Payment Tolerance")
                {
                    Caption = 'Block Payment Tolerance';
                }
                field(capexfrom; Rec."Capex From")
                {
                    Caption = 'Capex From';
                }
                field(capexto; Rec."Capex To")
                {
                    Caption = 'Capex To';
                }
                field(city; Rec."D365 City")
                {
                    Caption = 'City';
                }
                field(contactgroup; Rec."Contact Groups")
                {
                    Caption = 'Contact Group';
                }
                field(country; Rec."D365 Country")
                {
                    Caption = 'Country/Region Code';
                }
                field(county; Rec.County)
                {
                    Caption = 'County';
                }
                field(credithold; Rec."Credit Hold")
                {
                    Caption = 'Credit Hold';
                }
                field(creditlimitlcy; Rec."Credit Amount (LCY)")
                {
                    Caption = 'Credit Limit';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(currencycode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(customerprofile; Rec."Vendor Profile")
                {
                    Caption = 'Vendor Profile';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(dimension; Rec.Dimension)
                {
                    Caption = 'Dimension';
                }
                field(dimensionid; Rec."Dimension Id")
                {
                    Caption = 'Dimension Id';
                }
                field(d365accountid; Rec."D365 Account ID")
                {
                    Caption = 'Account Id';
                }
                field(email; Rec."E-Mail")
                {
                    Caption = 'Caption';
                }
                field(faxno; Rec."Fax No.")
                {
                    Caption = 'Fax No';
                }
                field(isalsoacustomer; Rec."Is Also a Customer")
                {
                }
                // DCS:: HP 17092025 ++
                field(creditLimit; Rec."Credit Limit")
                {
                    Caption = 'Credit Limit';
                }
                // DCS:: HP 17092025 --
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(ownerid; Rec."Owner Id")
                {
                    Caption = 'Owner ID';
                }
                field(owner; Rec.Owner)
                {
                    Caption = 'Owner';
                }
                
                field(paymentmethodcode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }
                field(paymenttermscode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }
                field(phoneno; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(postcode; Rec."D365 Postal Code")
                {
                    Caption = 'Postal Code';
                }
                field(privacyblocked; Rec."Privacy Blocked")
                {
                    Caption = 'Privacy Blocked';
                }
                field(primarycontact; Rec."Primary Contact No.")
                {
                    Caption = 'No';
                }
                field(sapcustomernumber; Rec."SAP Vendor Number")
                {
                    Caption = 'SAP Vendor No.';
                }
                field(serviceagreement; Rec."Service Agreement")
                {
                    Caption = 'Service Agreement';
                }
                field(state; Rec."D365 State")
                {
                    Caption = 'State';
                }
                field(supplieraccountgroup; Rec."Supplier Account Group")
                {
                    Caption = 'Supplier Account Group';
                }
                field(territorycode; Rec."Territory Code")
                {
                    Caption = 'Territory Code';
                }
                field(territorycodeid; Rec."Territory Code ID")
                {
                    Caption = 'Territory Code Id';
                }
                field(web; Rec.WEB)
                {
                    Caption = 'WEB';
                }
                field("genbuspostinggroup"; Rec."Gen. Bus. Posting Group") { }
                field("vendorpostinggroup"; Rec."Vendor Posting Group") { }
                field(reasonCode; Rec."Reason Code")
                {

                }
            }
        }
    }
}


