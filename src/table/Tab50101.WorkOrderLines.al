table 50101 "Work Order Lines"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Work Order No."; Code[200])
        {
            Caption = 'Work Order No.';
            TableRelation = "Work Order"."Work Order No.";
        }
        // DCS::HP 081025 ++
        field(24; "Work Order No. CRM"; Code[200])
        {
            Caption = 'Work Order No. CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                woRec: Record "Work Order";
            begin
                woRec.SetRange("CRM ID", "Work Order No. CRM");
                if woRec.FindFirst() then
                    "Work Order No." := woRec."Work Order No."
            end;
        }
        // DCS::HP 081025 --
        field(3; Code; Code[200])
        {
            Caption = 'Product No.';
            TableRelation = Item."No.";
        }
        // DCS::HP 081025 ++
        field(27; "Product No. CRM"; Text[100])
        {
            Caption = 'Product No. CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                itemRec: Record Item;
            begin
                itemRec.SetRange("CRM ID", "Product No. CRM");
                if itemRec.FindFirst() then
                    Code := itemRec."No.";
            end;
        }
        // DCS::HP 081025 --
        field(4; "Name"; Text[2048])
        {
            Caption = 'Name';

        }
        field(5; "Unit Code"; Code[200])
        {
            Caption = 'Unit Code';
            TableRelation = "Unit of Measure".Code;
        }
        // DCS::HP 081025 ++
        field(26; "Unit Code CRM"; Text[100])
        {
            Caption = 'Unit Code CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                uomRec: Record "Unit of Measure";
            begin
                uomRec.SetRange("CRM ID", "Unit Code CRM");
                if uomRec.FindFirst() then
                    "Unit Code" := uomRec.Code;
            end;
        }
        // DCS::HP 081025 --
        field(6; "Line Status"; enum "Document Status Simple")
        {
            Caption = 'Line Status';
            // OptionMembers = " ",Open,Closed;
        }
        field(7; "Estimate Quantity"; Decimal)
        {
            Caption = 'Estimate Quantity';
        }
        field(8; "Quantity to Build"; Decimal)
        {
            Caption = 'Quantity to Build';
        }
        field(9; "Location Code"; Code[200])
        {
            Caption = 'Location Code';
            // DCS::HP 081025 ++
            TableRelation = Location.Code;
            // DCS::HP 081025 --
        }
        // DCS::HP 081025 ++
        field(25; "Location Code CRM"; Text[100])
        {
            Caption = 'Location Code CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                locRec: Record Location;
            begin
                locRec.SetRange("CRM ID", "Location Code CRM");
                if locRec.FindFirst() then
                    "Location Code" := locRec.Code;
            end;
        }
        // DCS::HP 081025 --
        field(10; Description; Text[250])
        {
            Caption = 'Name';
        }
        field(11; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(12; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
        }
        field(13; "Unit Amount"; Decimal)
        {
            Caption = 'Unit Amount';
        }
        field(14; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(15; "Job No."; Code[200])
        {
            Caption = 'Project No';
        }
        field(16; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(17; "Line Created"; Boolean)
        {
            Caption = 'Line Created';
            DataClassification = ToBeClassified;
        }
        field(18; "Line Type"; Enum "Job Line Type")
        {
            Caption = 'Line Type';
        }
        field(19; Type; Enum "Job Journal Line Type Custom")
        {
            Caption = 'Type';
        }
        field(20; "Work Start Time"; Date)
        {
            Caption = 'Work Start Date';
        }
        field(21; "Work End Time"; Date)
        {
            Caption = 'Work Start Date';
        }

        field(22; "Service Duration"; Decimal)
        {
            Caption = 'Service Duration';
            ToolTip = 'Stores the duration of the service provided';
            DataClassification = ToBeClassified;
        }

        field(23; "Total Cost of Service"; Decimal)
        {
            Caption = 'Total Cost of Service';
            ToolTip = 'Stores the total cost of the service';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
        }
        // DCS::HP 081025 ++
        field(28; Owner; Text[100])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(29; "Owner CRM"; Text[100])
        {
            Caption = 'Owner CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                empRec: Record Employee;
            begin
                empRec.SetRange("CRM ID", "Owner CRM");
                if empRec.FindFirst() then
                    Owner := empRec."No.";
            end;
        }
        // DCS::HP 081025 --

        // DCS::HP01122025++
        field(30; "Project Task Number"; Code[200])
        {
            Caption = 'Project Task Number';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if rec."Project Task Number" in ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8'] then
                    Rec."Project Task Number" := Rec."Project Task Number" + '.01'
                else
                    Rec."Project Task Number" := '';
            end;
        }
        // DCS::HP01122025--
    }
    keys
    {
        key(key1; "Job No.", "Work Order No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
