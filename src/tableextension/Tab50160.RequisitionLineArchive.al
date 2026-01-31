namespace GKBCustomization.GKBCustomization;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Finance.Currency;
using Microsoft.Projects.Project.Job;
using Microsoft.HumanResources.Employee;
using Microsoft.Inventory.Location;
using GKBCustomizationsept.GKBCustomizationsept;

/// <summary>
/// Table Requisition Line Archive (ID 50160).
/// Archives requisition lines when they are converted to Purchase Orders with "Released" status.
/// Maintains historical record of all requisitions that have been processed.
/// </summary>


//Gkblabs_Tv_03/12/25
table 50160 "Requisition Line Archive"
{
    Caption = 'Requisition Line Archive';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            NotBlank = true;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            NotBlank = true;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            NotBlank = true;
        }
        field(4; Type; Text[20])
        {
            Caption = 'Type';
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(9; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
        }
        field(10; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(11; "Vendor Item No."; Code[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(12; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            AutoFormatType = 2;
        }
        field(13; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
        }
        field(50100; "StatusReq"; Enum "Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(50101; "projectNo"; Code[30])
        {
            Caption = 'Project No.';
        }
        field(50102; "AlternateVendorNo."; Code[30])
        {
            Caption = 'Alternate Vendor No';
        }
        field(50103; "Crm Id"; Text[100])
        {
            Caption = 'Crm Id';
            DataClassification = ToBeClassified;
        }
        field(50104; "VendorName"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(50106; "Requested By Name"; Code[30])
        {
            Caption = 'Requested By';
        }
        field(50157; "Requested By Name2"; Text[100])
        {
            Caption = 'Requested By Name';
        }
        field(50107; "Project Task No"; Code[30])
        {
            Caption = 'Project Task No';
            DataClassification = ToBeClassified;
        }
        field(50108; "Dimension Value"; Code[30])
        {
            Caption = 'Dimension Value';
            DataClassification = ToBeClassified;
        }
        field(50109; "Work Order No"; Code[30])
        {
            Caption = 'Work Order No';
            DataClassification = ToBeClassified;
        }
        field(50110; "Stock Check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Stock Check';
        }
        field(50111; "Ship To"; enum "Customer Location")
        {
            Caption = 'Ship To';
            DataClassification = ToBeClassified;
        }
        field(50112; "Alternate Vendor For Item"; Boolean)
        {
            Caption = 'Alternate Vendor For Item';
            DataClassification = CustomerContent;
        }
        field(50113; "Item Availability By Location"; Decimal)
        {
            Caption = 'Item Availability By Location';
        }
        field(50114; "Item Inventory"; Decimal)
        {
            Caption = 'Item Inventory';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50115; "PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PO Created';
        }
        field(50150; "Owner"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(50154; "Owner CRM"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50151; "Product"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50152; "Warehouse"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50153; "Defalut Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50155; "Default Unit CRM"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50156; "Currency CRM"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50158; "Default PO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Default PO';
        }
        field(50200; "Archived Date"; DateTime)
        {
            Caption = 'Archived Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(50201; "Archived By"; Code[50])
        {
            Caption = 'Archived By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(50202; "PO Number"; Code[20])
        {
            Caption = 'PO Number';
            Editable = false;
        }
        field(50203; "PO Line Number"; Integer)
        {
            Caption = 'PO Line Number';
            Editable = false;
        }
        field(50204; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Vendor No.")
        {
        }
        key(SK2; "Archived Date")
        {
        }
        key(SK3; "PO Number")
        {
        }
    }
}
