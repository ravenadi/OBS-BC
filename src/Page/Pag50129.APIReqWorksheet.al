page 50129 "API Req.Worksheet"
{
    PageType = API;
    Caption = 'Req.Worksheet API';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0';
    EntityName = 'PurchaseRequest';
    EntitySetName = 'PurchaseRequest';
    SourceTable = "Requisition Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm Id';
                }
                field("WorksheetTemplateName"; Rec."Worksheet Template Name")
                {
                    Caption = 'Worksheet Template Name';
                }
                field("JournalBatchName"; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field("ObrienBusinessUnitCode"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Obrien Business Unit Code';
                }
                field("No"; Rec."No.")
                {
                    Caption = 'No.';
                }
                 // DCS::HP 071025 ++
                field(owner; Rec."Owner CRM")
                {
                    Caption = 'Owner';
                }
                // DCS::HP 071025 --
                field(product; Rec.Product)
                {
                    Caption = 'Product';
                }
                field(warehouse; Rec.Warehouse)
                {
                    Caption = 'Warehouse';
                }
                field("VendorNo"; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorItemNo; Rec."Vendor Item No.")
                {
                    Caption = 'Vendor Item No.';
                }
                // DCS::HP 071025 ++
                field(defalutUnit; Rec."Default Unit CRM")
                {
                    Caption = 'Defalut Unit';
                }
                field(currencyCode; Rec."Currency CRM")
                {
                    Caption = 'Currency Code';
                }
                // DCS::HP 071025 --
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(directUnitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field("WorkOrderNo"; Rec."Work Order No")
                {
                    Caption = 'Work Order No.';
                }

                field("LineNo"; Rec."Line No.")
                {
                    Visible = false; //YK
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    Visible = false; //YK
                }
                field("LocationCode"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    Visible = false; //YK
                }
                field("UnitofMeasureCode"; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                    Visible = false; //YK
                }
                field("BaseUnitOfMeasure"; Item."Base Unit of Measure")
                {
                    Visible = false; //YK
                }   //From item Table.
                field("DueDate"; Rec."Due Date")
                {
                    Caption = 'Due Date';
                    Visible = false; //YK
                }
                //DCS::HK 01102025 ++
                field(workCenterNo; Rec."Work Center No.")
                {
                    Caption = 'Work Center No.';
                    Visible = false; //YK
                }
                field(vendorName; Rec.VendorName)
                {
                    Caption = 'Vendor Name';
                    Visible = false;
                }

                //DCS::HK 01102025 --
            }
        }
    }
    var
        Item: Record Item;
}