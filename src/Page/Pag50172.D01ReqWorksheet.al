namespace GKBCustomizationnov.GKBCustomizationnov;
using Microsoft.Inventory.Requisition;

page 50172 "D01 Req. Worksheet" //DCS HJ 20251121
{
    AdditionalSearchTerms = 'supply planning,mrp,mps';
    ApplicationArea = Basic, Suite, Planning;
    AutoSplitKey = true;
    Caption = 'Archive Req. Worksheet';
    // DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "D01 Requisition Line";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Worksheet Template Name"; Rec."Worksheet Template Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Worksheet Template Name field.', Comment = '%';

                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';

                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description 2 field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Direct Unit Cost field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("Requester ID"; Rec."Requester ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requester ID field.', Comment = '%';
                }
                field(Confirmed; Rec.Confirmed)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Confirmed field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Location Code field.', Comment = '%';
                }
                field("Recurring Method"; Rec."Recurring Method")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Recurring Method field.', Comment = '%';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field("Recurring Frequency"; Rec."Recurring Frequency")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Recurring Frequency field.', Comment = '%';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Order Date field.', Comment = '%';
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Item No. field.', Comment = '%';
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
                }
                field("Sales Order Line No."; Rec."Sales Order Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sales Order Line No. field.', Comment = '%';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Sell-to Customer No. field.', Comment = '%';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ship-to Code field.', Comment = '%';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Order Address Code field.', Comment = '%';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency Factor field.', Comment = '%';
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reserved Quantity field.', Comment = '%';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purchaser Code field.', Comment = '%';
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Drop Shipment field.', Comment = '%';
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dimension Set ID field.', Comment = '%';
                }
                field("Prod. Order No."; Rec."Prod. Order No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Prod. Order No. field.', Comment = '%';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Variant Code field.', Comment = '%';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bin Code field.', Comment = '%';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty. per Unit of Measure field.', Comment = '%';
                }
                field("Qty. Rounding Precision"; Rec."Qty. Rounding Precision")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty. Rounding Precision field.', Comment = '%';
                }
                field("Qty. Rounding Precision (Base)"; Rec."Qty. Rounding Precision (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty. Rounding Precision (Base) field.', Comment = '%';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit of Measure Code field.', Comment = '%';
                }
                field("Quantity (Base)"; Rec."Quantity (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Quantity (Base) field.', Comment = '%';
                }
                field("Reserved Qty. (Base)"; Rec."Reserved Qty. (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reserved Qty. (Base) field.', Comment = '%';
                }
                field("Demand Type"; Rec."Demand Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Type field.', Comment = '%';
                }
                field("Demand Subtype"; Rec."Demand Subtype")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Subtype field.', Comment = '%';
                }
                field("Demand Order No."; Rec."Demand Order No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Order No. field.', Comment = '%';
                }
                field("Demand Line No."; Rec."Demand Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Line No. field.', Comment = '%';
                }
                field("Demand Ref. No."; Rec."Demand Ref. No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Ref. No. field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Demand Date"; Rec."Demand Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Date field.', Comment = '%';
                }
                field("Demand Quantity"; Rec."Demand Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Quantity field.', Comment = '%';
                }
                field("Demand Quantity (Base)"; Rec."Demand Quantity (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Quantity (Base) field.', Comment = '%';
                }
                field("Needed Quantity"; Rec."Needed Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Needed Quantity field.', Comment = '%';
                }
                field("Needed Quantity (Base)"; Rec."Needed Quantity (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Needed Quantity (Base) field.', Comment = '%';
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reserve field.', Comment = '%';
                }
                field("Qty. per UOM (Demand)"; Rec."Qty. per UOM (Demand)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Qty. per UOM (Demand) field.', Comment = '%';
                }
                field("Unit Of Measure Code (Demand)"; Rec."Unit Of Measure Code (Demand)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit Of Measure Code (Demand) field.', Comment = '%';
                }
                field("Supply From"; Rec."Supply From")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Supply From field.', Comment = '%';
                }
                field("Original Item No."; Rec."Original Item No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Item No. field.', Comment = '%';
                }
                field("Original Variant Code"; Rec."Original Variant Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Variant Code field.', Comment = '%';
                }
                field(Level; Rec.Level)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Level field.', Comment = '%';
                }
                field("Demand Qty. Available"; Rec."Demand Qty. Available")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Demand Qty. Available field.', Comment = '%';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the User ID field.', Comment = '%';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item Category Code field.', Comment = '%';
                }
                field(Nonstock; Rec.Nonstock)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Catalog field.', Comment = '%';
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Purchasing Code field.', Comment = '%';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transfer-from Code field.', Comment = '%';
                }
                field("Transfer Shipment Date"; Rec."Transfer Shipment Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Transfer Shipment Date field.', Comment = '%';
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Price Calculation Method field.', Comment = '%';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Line Discount % field.', Comment = '%';
                }
                field("Blanket Purch. Order Exists"; Rec."Blanket Purch. Order Exists")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Blanket Purch. Order Exists field.', Comment = '%';
                }
                field("Custom Sorting Order"; Rec."Custom Sorting Order")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Custom Sorting Order field.', Comment = '%';
                }
                field(StatusReq; Rec.StatusReq)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(projectNo; Rec.projectNo)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Project No. field.', Comment = '%';
                }
                field("AlternateVendorNo."; Rec."AlternateVendorNo.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor No field.', Comment = '%';
                }
                field("Crm Id"; Rec."Crm Id")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Crm Id field.', Comment = '%';
                }
                field(VendorName; Rec.VendorName)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Requested By Name"; Rec."Requested By Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requested By field.', Comment = '%';
                }
                field("Project Task No"; Rec."Project Task No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Project Task No field.', Comment = '%';
                }
                field("Dimension Value"; Rec."Dimension Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Dimension Value field.', Comment = '%';
                }
                field("Work Order No"; Rec."Work Order No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Work Order No field.', Comment = '%';
                }
                field("Stock Check"; Rec."Stock Check")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Stock Check field.', Comment = '%';
                }
                field("Ship To"; Rec."Ship To")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ship To field.', Comment = '%';
                }
                field("Alternate Vendor For Item"; Rec."Alternate Vendor For Item")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Alternate Vendor For Item field.', Comment = '%';
                }
                field("Item Availability By Location"; Rec."Item Availability By Location")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item Availability By Location field.', Comment = '%';
                }
                field("Item Inventory"; Rec."Item Inventory")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Item Inventory field.', Comment = '%';
                }
                field("PO Created"; Rec."PO Created")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PO Created field.', Comment = '%';
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
                }
                field(Product; Rec.Product)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Product field.', Comment = '%';
                }
                field(Warehouse; Rec.Warehouse)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Warehouse field.', Comment = '%';
                }
                field("Defalut Unit"; Rec."Defalut Unit")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Defalut Unit field.', Comment = '%';
                }
                field("Owner CRM"; Rec."Owner CRM")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Owner CRM field.', Comment = '%';
                }
                field("Default Unit CRM"; Rec."Default Unit CRM")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default Unit CRM field.', Comment = '%';
                }
                field("Currency CRM"; Rec."Currency CRM")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Currency CRM field.', Comment = '%';
                }
                field("Requested By Name2"; Rec."Requested By Name2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Requested By Name field.', Comment = '%';
                }
                field("Default PO"; Rec."Default PO")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default PO field.', Comment = '%';
                }
                field("Routing No."; Rec."Routing No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Routing No. field.', Comment = '%';
                }
                field("Operation No."; Rec."Operation No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Operation No. field.', Comment = '%';
                }
                field("Work Center No."; Rec."Work Center No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Work Center No. field.', Comment = '%';
                }
                field("Prod. Order Line No."; Rec."Prod. Order Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Prod. Order Line No. field.', Comment = '%';
                }
                field("MPS Order"; Rec."MPS Order")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the MPS Order field.', Comment = '%';
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Planning Flexibility field.', Comment = '%';
                }
                field("Routing Reference No."; Rec."Routing Reference No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Routing Reference No. field.', Comment = '%';
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.', Comment = '%';
                }
                field("Gen. Business Posting Group"; Rec."Gen. Business Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Gen. Business Posting Group field.', Comment = '%';
                }
                field("Low-Level Code"; Rec."Low-Level Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Low-Level Code field.', Comment = '%';
                }
                field("Production BOM Version Code"; Rec."Production BOM Version Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Production BOM Version Code field.', Comment = '%';
                }
                field("Routing Version Code"; Rec."Routing Version Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Routing Version Code field.', Comment = '%';
                }
                field("Routing Type"; Rec."Routing Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Routing Type field.', Comment = '%';
                }
                field("Original Quantity"; Rec."Original Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Quantity field.', Comment = '%';
                }
                field("Finished Quantity"; Rec."Finished Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Finished Quantity field.', Comment = '%';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining Quantity field.', Comment = '%';
                }
                field("Original Due Date"; Rec."Original Due Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Original Due Date field.', Comment = '%';
                }
                field("Scrap %"; Rec."Scrap %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Scrap % field.', Comment = '%';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Date field.', Comment = '%';
                }
                field("Starting Time"; Rec."Starting Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Time field.', Comment = '%';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
                }
                field("Ending Time"; Rec."Ending Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ending Time field.', Comment = '%';
                }
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Production BOM No. field.', Comment = '%';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Indirect Cost % field.', Comment = '%';
                }
                field("Overhead Rate"; Rec."Overhead Rate")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Overhead Rate field.', Comment = '%';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Unit Cost field.', Comment = '%';
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Cost Amount field.', Comment = '%';
                }
                field("Replenishment System"; Rec."Replenishment System")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Replenishment System field.', Comment = '%';
                }
                field("Ref. Order No."; Rec."Ref. Order No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ref. Order No. field.', Comment = '%';
                }
                field("Ref. Order Type"; Rec."Ref. Order Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ref. Order Type field.', Comment = '%';
                }
                field("Ref. Order Status"; Rec."Ref. Order Status")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ref. Order Status field.', Comment = '%';
                }
                field("Ref. Line No."; Rec."Ref. Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ref. Line No. field.', Comment = '%';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }
                field("Expected Operation Cost Amt."; Rec."Expected Operation Cost Amt.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expected Operation Cost Amt. field.', Comment = '%';
                }
                field("Expected Component Cost Amt."; Rec."Expected Component Cost Amt.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expected Component Cost Amt. field.', Comment = '%';
                }
                field("Finished Qty. (Base)"; Rec."Finished Qty. (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Finished Qty. (Base) field.', Comment = '%';
                }
                field("Remaining Qty. (Base)"; Rec."Remaining Qty. (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Remaining Qty. (Base) field.', Comment = '%';
                }
                field("Related to Planning Line"; Rec."Related to Planning Line")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Related to Planning Line field.', Comment = '%';
                }
                field("Planning Level"; Rec."Planning Level")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Planning Level field.', Comment = '%';
                }
                field("Planning Line Origin"; Rec."Planning Line Origin")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Planning Line Origin field.', Comment = '%';
                }
                field("Action Message"; Rec."Action Message")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Action Message field.', Comment = '%';
                }
                field("Accept Action Message"; Rec."Accept Action Message")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accept Action Message field.', Comment = '%';
                }
                field("Net Quantity (Base)"; Rec."Net Quantity (Base)")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Net Quantity (Base) field.', Comment = '%';
                }
                field("Starting Date-Time"; Rec."Starting Date-Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Starting Date-Time field.', Comment = '%';
                }
                field("Ending Date-Time"; Rec."Ending Date-Time")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ending Date-Time field.', Comment = '%';
                }
                field("Order Promising ID"; Rec."Order Promising ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Order Promising ID field.', Comment = '%';
                }
                field("Order Promising Line No."; Rec."Order Promising Line No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Order Promising Line No. field.', Comment = '%';
                }
                field("Order Promising Line ID"; Rec."Order Promising Line ID")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Order Promising Line ID field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                }
            }
        }
    }

}
