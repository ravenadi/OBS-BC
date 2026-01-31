tableextension 50125 "JOb Task Ext" extends "Job Task"
{
    fields
    {
        field(50100; "Billing Type"; enum "Charge Status")
        {
            Caption = 'Billing Type';
            DataClassification = CustomerContent;
            // OptionMembers = " ","Charge Up","Quoted","Monthly Billing","Not Chargeable","N/A";
        }

        field(50101; "Contact"; Code[200])
        {
            Caption = 'Contact';
            TableRelation = Contact;
        }

        field(50102; "Fix Type"; enum "First Time Fix Status")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = " ","First Time Fix","First Time Fix With Multiple Bookings","Not a First Time Fix";
        }

        field(50103; "Functional Location"; Code[200])
        {
            Caption = 'Functional Location';
            TableRelation = "Ship-to Address".Name;
            // ValidateTableRelation = false;
        }
        // Newly added fields
        field(50104; "Description 2"; Text[200])
        {
            Caption = 'Description 2';
        }

        field(50105; "Work Order Type"; Text[200])
        {
            Caption = 'Work Order Type';
            TableRelation = "GKB Work Order Type";
        }
        // DCS::HK 13102025 ++
        field(50106; "Work Order Summary"; Text[1000])   // DCS::HK 13102025 --
        {
            Caption = 'Work Order Summary';
        }
        field(50107; "Parent Task No."; Code[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "Work Order";
        }
        field(50108; "Case"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(50109; "Opportunity"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = Opportunity;
        }
        field(50110; "System Status"; enum "Task Status1")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ",Cancelled,Completed,"In-Progress",Invoiced,Scheduled,Unscheduled;
            // OptionCaption = ' ,Cancelled,Completed,In-Progress,Invoiced,Scheduled,Unscheduled';
        }
        // DCS::HP 02092025 ++
        field(50111; "Substatus"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Work Order Substatus".Name;
            // DCS::HP 02092025 --
        }
        field(50112; "Customer PO Number"; Text[200])
        {
            Caption = 'Customer PO Number';
            DataClassification = ToBeClassified;
        }
        field(50113; "GST Posting Group"; Code[50])
        {
            Caption = 'GST Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
        }
        field(50114; "Total Line Cost"; Decimal)
        {
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("Job No.")));
            Caption = 'Total Line Cost';
            Editable = false;
        }
        field(50115; "Total Line Amount"; Decimal)
        {
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            CalcFormula = Sum("Job Planning Line"."Line Amount" WHERE("Job No." = FIELD("Job No.")));
            Caption = 'Total Line Amount';
            Editable = false;
        }
        // DCS::HK 13102025 ++
        field(50116; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        // DCS::HK 13102025 --

        // DCS::HK 13102025 ++
    }
}
