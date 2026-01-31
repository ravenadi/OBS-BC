page 50104 "API Items"
{
    PageType = API;
    Caption = 'API Item';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'Item';
    EntitySetName = 'Item';
    SourceTable = Item;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("baseunitofmeasure"; Rec."Base Unit of Measure")   //lookup
                {
                    Caption = 'Base Unit Of Measure';
                }
                field(code; Rec."No.")
                {
                    Caption = 'no';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(currency; Rec.Currency)
                {
                    Caption = 'Currency';
                }
                field(currencyid; Rec."Currency Id")
                {
                    Caption = 'Currency Id';
                }
                field("customvendorid"; Rec."Custom Vendor Id")
                {
                    Caption = 'Custom Vendor Id';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Name';
                }
                field("description2"; Rec."Description 2")
                {
                    Caption = 'Description';
                }
                field("no"; Rec."No.")
                {
                    Caption = 'No';
                }
                field("customerproductname"; Rec."OBS Item Name")
                {
                    Caption = 'OBS Item Name';
                }
                field("postinggroup"; Rec."Posting Group")
                {
                    Caption = 'Posting Group';
                }
                field("productstructure"; Rec."Product Structure")
                {
                    Caption = 'Product Structure';
                }
                field("producttype"; Rec."Product Type")
                {
                    Caption = 'Product Type';
                }
                field("standardcost"; Rec."Standard Cost")
                {
                    Caption = 'Standard Cost';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field("tradetype"; Rec."Trade Type")
                {
                    Caption = 'Trade Type';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field("unitcost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field("unitprice"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field("vendor1cataloguenumber"; Rec."Vendor 1 Catalogue Number")
                {
                    Caption = 'Vendor Catalogue Number';
                }
                field("vendorid"; Rec."Vendor Id")
                {
                    Caption = 'Vendor Id';
                }
                field(sapitemnumber; Rec.SAPITEMID) { }
                field("d365productid"; Rec."D365 Product ID") { }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                }
                field(owner; Rec.Owner)
                {
                    Caption = 'Owner';
                }

            }
        }
    }
}

