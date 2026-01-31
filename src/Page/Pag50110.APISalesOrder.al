page 50110 "API Sales Order"
{
    PageType = API;
    Caption = 'API Sales Order';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'salesorder';
    EntitySetName = 'salesorder';
    SourceTable = "Sales Header";
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
                field(SystemId; Rec.SystemId) { }
                field(documenttype; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(code; Rec."No.")
                {
                    Caption = 'Code';
                }
                field(customerno; Rec."Sell-to Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customercrmid; Rec."Customer CRMID")
                {
                    Caption = 'Customer No.';
                }
                field(name; Rec.Name) { }
                field(addressname; Rec."Bill-to address name")             //Custom 
                {
                    Caption = 'Address Name';
                }
                field(city; Rec."Bill-to City")            //   default 
                {
                    Caption = 'City';
                }
                field(country; Rec."D365 Bill-to country")            // Custom
                {
                    Caption = 'Country';
                }
                field(State; Rec."Bill-to County") { }
                field(billtopostcode; Rec."D365 Bill-to Post Code")               // Custom
                {
                    Caption = 'Sell-to Post Code';
                }
                field(address; Rec."Bill-to Address")           //default
                {
                    Caption = 'Address';
                }
                field(address2; Rec."Bill-to Address 2")                //default
                {
                    Caption = 'Address 2';
                }
                field(address3; Rec."D365 Bill-to Address 3")               //custom
                {
                    Caption = 'Address 3';
                }
                field(currency; Rec."Currency Code")
                {
                    Caption = 'Currency';
                }
                field(currencycrmid; Rec."Currency CRM ID")
                {
                    Caption = 'Currency CRM ID';
                }
                field(description; Rec."Description")
                {
                    Caption = 'Work Description';
                }
                field(email; Rec."Sell-to E-Mail")
                { }
                field(dimension; Rec.Dimension)
                {
                    Caption = 'Dimension';
                }
                field(dimensioncrmid; Rec."Dimension CRM ID")
                {
                    Caption = 'Dimension CRM ID';
                }
                field(pricelist; Rec."Price List")
                {
                    Caption = 'Price List';
                }
                field(quote; Rec."Quote")
                {
                    Caption = 'Quote';
                }
                field(quotecrmid; Rec."Quote CRM ID")
                {
                    Caption = 'Quote';
                }
                field("billingtype"; Rec."Billing Type") { }
                field(opportunity; Rec."Opportunity")
                {
                    Caption = 'Opportunity';
                }
                field(opportunitycrmid; Rec."Opportunity CRM ID")
                {
                    Caption = 'Opportunity CRM ID';
                }
                field(leadtype; Rec."Lead Type")
                {
                    Caption = 'Lead Type';
                }
                field(wotype; Rec."Work Order Type")
                {
                    Caption = 'Work Order Type';
                }
                field(creationmethod; Rec."Creation Method")
                {
                    Caption = 'Creation Method';
                }
                field(shiptocity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(ShipToState; Rec."Ship-to County") { }
                field(shiptocountry; Rec."D365 ShiptoCountry/RegionCode")  //Create Custom
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shiptoname; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                }
                field(shiptopostalcode; Rec."D365 Ship-to Post Code")    // Custom
                {
                    Caption = 'Ship-to Post Code';
                }
                field(shiptoaddress; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                }
                field(shiptoaddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';
                }
                field(shiptoaddress3; Rec."Ship-to Address 3")
                {
                    Caption = 'Ship-to Address 3';
                }
                field("requesteddeliverydate"; Rec."Requested Delivery Date")
                {
                    Caption = 'Requested Delivery Date';
                }
                field("owningbusinessunit"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
            }
        }
    }
}


