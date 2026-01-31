page 50116 "API Price List Lines"
{
    PageType = API;
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'SalesPriceListLine';
    EntitySetName = 'SalesPriceListLines';
    SourceTable = "Price List Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                // Price list code and Line No. are the PK
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm Id';
                }
                field(ProductNo; Rec."Product No.")
                {
                    Caption = 'Product No.';
                }
                field(UnitOfMeasureCode; Rec."Unit of Measure Code lookup")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field("LineNo"; Rec."Line No.") { }

            }
        }
    }
}
