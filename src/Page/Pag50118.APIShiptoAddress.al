page 50118 "API Ship-to Address"
{
    PageType = API;
    APIGroup = 'api';
    APIPublisher = 'integration';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'Shiptoaddress';
    EntitySetName = 'Shiptoaddress';
    SourceTable = "Ship-to Address";
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(Code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm id';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(GLN; Rec.GLN)
                {
                    Caption = 'GLN';
                }
                field(Address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(Address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                // DCS:: HP 23092025 ++
                field(address3; Rec."Address 3")
                {
                    Caption = 'Address 3';
                }
                // DCS:: HP 23092025 --
                field(City; Rec.City)
                {
                    Caption = 'City';
                }
                field(County; Rec.County)
                {
                    Caption = 'County';
                }
                field(PostCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(Contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    Caption = 'Fax No.';
                }
                field(Email; Rec."E-Mail")
                {
                    Caption = 'E-Mail';
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code';
                }
                field(LocationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(ShipmentMethodCode; Rec."Shipment Method Code")
                {
                    Caption = 'Shipment Method Code';
                }
                field(ShippingAgentCode; Rec."Shipping Agent Code")
                {
                    Caption = 'Shipping Agent Code';
                }
                field(ShippingAgentServiceCode; Rec."Shipping Agent Service Code")
                {
                    Caption = 'Shipping Agent Service Code';
                }
                field(ServiceZoneCode; Rec."Service Zone Code")
                {
                    Caption = 'Service Zone Code';
                }
                // field(LastDateModified; Rec."Last Date Modified")
                // {
                //     Caption = 'Last Date Modified';
                // }
                // DCS::HP 22082025 ++
                field(D365AccountId; Rec."D365 Account ID")
                {
                    Caption = 'D365 Account ID';
                }
                // DCS::HP 22082025 --
                // field(SystemModifiedAt; Rec.SystemModifiedAt)
                // {
                //     Caption = 'Last Modified By';
                // }
                // field(LastModifiedDateTime; Rec."Last Date Modified")
                // {
                //     Caption = 'Last Modified Date Time';
                // }
            }
        }
    }
}