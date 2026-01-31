page 50122 "API Purch Pric List Lines"
{
    PageType = API;
    APIVersion = 'v2.0', 'v1.0';
    APIPublisher = 'integration';
    APIGroup = 'api';
    DelayedInsert = true;
    EntityName = 'PurchasePriceList';
    EntitySetName = 'PurchasePriceLists';
    SourceTable = "Price List Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm Id';
                }
                field(ParentSourceNo; Rec."Parent Source No.")
                {
                    Caption = 'Assign-to Project No.';
                    ToolTip = 'Specifies the project to which the prices are assigned.';
                }
                field(AssignToParentNo; Rec."Assign-to Parent No.")
                {
                    Caption = 'Assign-to Project No.';
                    ToolTip = 'Specifies the project to which the prices are assigned.';
                }
                field(SourceNo; Rec."Source No.")
                {
                    Caption = 'Source No.';
                    ToolTip = 'Specifies the entity to which the prices are assigned.';
                }
                field(AssignToNo; Rec."Assign-to No.")
                {
                    Caption = 'Assign-to No.';
                    ToolTip = 'Specifies the entity to which the prices are assigned.';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                    ToolTip = 'Specifies the currency that is used for the prices on the price list.';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                    ToolTip = 'Specifies the date from which the price is valid.';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                    ToolTip = 'Specifies the last date that the price is valid.';
                }
                field("AssetType"; Rec."Asset Type")
                {
                    Caption = 'Asset Type';
                    ToolTip = 'Specifies the type of the product.';
                }
                field("AssetNo"; Rec."Asset No.")
                {
                    Caption = 'Asset No.';
                    ToolTip = 'Specifies the identifier of the product.';
                }
                field("ProductNo"; Rec."Product No.")
                {
                    Caption = 'Product No.';
                    ToolTip = 'Specifies the identifier of the product.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the product.';
                }
                field("VariantCode"; Rec."Variant Code")
                {
                    Caption = 'Variant Code';
                    ToolTip = 'Specifies the item variant.';
                }
                field("WorkTypeCode"; Rec."Work Type Code")
                {
                    Caption = 'Work Type Code';
                    ToolTip = 'Specifies the work type code for the resource.';
                }
                field("UnitofMeasureCode"; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                    ToolTip = 'Specifies the unit of measure for the product.';
                }
                field("MinimumQuantity"; Rec."Minimum Quantity")
                {
                    Caption = 'Minimum Quantity';
                    ToolTip = 'Specifies the minimum quantity of the product.';
                }
                field("AmountType"; Rec."Amount Type")
                {
                    Caption = 'Amount Type';
                    ToolTip = 'Specifies whether the price list line defines prices, discounts, or both.';
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                    ToolTip = 'Specifies the direct unit cost of the product.';
                }
                field("UnitCost"; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                    ToolTip = 'Specifies the unit cost of the resource.';
                }
                field("AllowLineDisc"; Rec."Allow Line Disc.")
                {
                    Caption = 'Allow Line Discount';
                    ToolTip = 'Specifies if a line discount will be calculated when the price is offered.';
                }
                field("LineDiscount"; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
                    ToolTip = 'Specifies the line discount percentage for the product.';
                }
                field("AllowInvoiceDisc"; Rec."Allow Invoice Disc.")
                {
                    Caption = 'Allow Invoice Discount';
                    ToolTip = 'Specifies if an invoice discount will be calculated when the price is offered.';
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    Caption = 'Price Includes VAT';
                    ToolTip = 'Specifies if prices include VAT.';
                }
            }
        }
    }
}

