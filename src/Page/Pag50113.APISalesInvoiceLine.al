page 50113 "API Sales Invoice Line"
{
    PageType = API;
    APIGroup = 'api';
    APIPublisher = 'integration';
    APIVersion = 'v2.0', 'v1.0';
    SourceTable = "Sales Line";
    EntityName = 'SalesInvoiceLine';
    EntitySetName = 'SalesInvoiceLines';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm Id';
                }
                field("SellToCustomerNo"; Rec."Sell-to Customer No.")
                {
                    Caption = 'Sell-to Customer No.';
                }
                field("DocumentNo"; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field("LineNo"; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("Type"; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(Topic; Rec.Topic) { }
                field("No"; Rec."No.")
                {
                    Caption = 'No.';
                }
                field("LocationCode"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field("PostingGroup"; Rec."Posting Group")
                {
                    Caption = 'Posting Group';
                }
                field("ShipmentDate"; Rec."Shipment Date")
                {
                    Caption = 'Shipment Date';
                }
                field("Description"; Rec.Description)
                {
                    Caption = 'Description';
                }
                field("Description2"; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field("UnitOfMeasure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field("Quantity"; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field("UnitPrice"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field("UnitCostLCY"; Rec."Unit Cost (LCY)")
                {
                    Caption = 'Unit Cost (LCY)';
                }
                field("VATPercentage"; Rec."VAT %")
                {
                    Caption = 'VAT %';
                }
                field("LineDiscountPercentage"; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
                }
                field("LineDiscountAmount"; Rec."Line Discount Amount")
                {
                    Caption = 'Line Discount Amount';
                }
                field("Amount"; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field("AmountIncludingVAT"; Rec."Amount Including VAT")
                {
                    Caption = 'Amount Including VAT';
                }
                field("AllowInvoiceDisc"; Rec."Allow Invoice Disc.")
                {
                    Caption = 'Allow Invoice Disc.';
                }
                field("GrossWeight"; Rec."Gross Weight")
                {
                    Caption = 'Gross Weight';
                }
                field("NetWeight"; Rec."Net Weight")
                {
                    Caption = 'Net Weight';
                }
                field("UnitsPerParcel"; Rec."Units per Parcel")
                {
                    Caption = 'Units per Parcel';
                }
                field("UnitVolume"; Rec."Unit Volume")
                {
                    Caption = 'Unit Volume';
                }
                field("ApplToItemEntry"; Rec."Appl.-to Item Entry")
                {
                    Caption = 'Appl.-to Item Entry';
                }
                field("ShortcutDimension1Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field("ShortcutDimension2Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field("CustomerPriceGroup"; Rec."Customer Price Group")
                {
                    Caption = 'Customer Price Group';
                }
                field("JobNo"; Rec."Job No.")
                {
                    Caption = 'Project No.';
                }
                field("WorkTypeCode"; Rec."Work Type Code")
                {
                    Caption = 'Work Type Code';
                }
                field("ShipmentNo"; Rec."Shipment No.")
                {
                    Caption = 'Shipment No.';
                }
                field("ShipmentLineNo"; Rec."Shipment Line No.")
                {
                    Caption = 'Shipment Line No.';
                }
                field("BillToCustomerNo"; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field("InvDiscountAmount"; Rec."Inv. Discount Amount")
                {
                    Caption = 'Inv. Discount Amount';
                }
                field("DropShipment"; Rec."Drop Shipment")
                {
                    Caption = 'Drop Shipment';
                }
            }
        }
    }
}