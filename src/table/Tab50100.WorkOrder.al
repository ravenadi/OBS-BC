table 50100 "Work Order"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "Work Order List";
    LookupPageId = "Work Order Card";
    fields
    {
        field(1; "Work Order No."; Text[200])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Service Account"; Code[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "Customer"."No.";
        }
        field(40; "Service Account CRM"; Text[200])
        {
            Caption = 'Service Account CRM';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                cusRec: Record Customer;
            begin
                cusRec.Reset();
                cusRec.SetRange("CRM ID", Rec."Service Account CRM");
                if cusRec.FindFirst() then
                    Rec."Service Account" := cusRec."No.";
            end;
        }

        field(3; "System Status"; enum "Task Status1")
        {
            DataClassification = CustomerContent;
            // OptionMembers = Unscheduled,Scheduled,"In Progress",Completed,Invoiced,Cancelled;
        }
        field(4; "Substatus"; Code[50])
        {
            // DCS::HP 02092025 ++
            DataClassification = CustomerContent;
            // DCS::HP 0209202 --
            // DCS::HP 071025 ++
            TableRelation = "Work Order Substatus".Name;
        }
        field(39; "Substatus CRM"; Text[200])
        {
            Caption = 'Substatus CRM';
            DataClassification = CustomerContent;
            trigger onvalidate()
            var
                worOrdRec: Record "Work Order Substatus";
            begin
                worOrdRec.Reset();
                worOrdRec.SetRange("CRM ID", Rec."Substatus CRM");
                if worOrdRec.FindFirst() then
                    Rec.Substatus := worOrdRec.Name
            end;
        }
        field(5; "Agreement"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Billing Account"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(41; "Billing Account CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                cusRec: Record Customer;
            begin
                cusRec.Reset();
                cusRec.SetRange("CRM ID", Rec."Billing Account CRM");
                if cusRec.FindFirst() then
                    Rec."Billing Account" := cusRec."No.";
            end;
        }
        field(7; "Billing Type"; enum "Charge Status")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ","Charge Up","Quoted","Monthly Billing","Not Chargeable","N/A";
        }
        field(8; "Case Custom"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Completed On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Contact"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = Contact."No.";
        }
        field(42; "Contact CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                conRec: Record Contact;
            begin
                conRec.Reset();
                conRec.SetRange("CRM ID", Rec."Contact CRM");
                if conRec.FindFirst() then
                    Rec."Contact" := conRec."No.";
            end;
        }
        field(11; "Currency"; Text[200])  //Changed from Code to Text.
        {
            DataClassification = CustomerContent;
            TableRelation = "Currency"."Code";
        }
        field(43; "Currency CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                currRec: Record Currency;
            begin
                currRec.Reset();
                currRec.SetRange("CRM ID", Rec."Currency CRM");
                if currRec.FindFirst() then
                    Rec."Currency" := currRec.code;
            end;
        }
        field(12; "Fix Type"; enum "First Time Fix Status")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ","First Time Fix","First Time Fix With Multiple Bookings","Not a First Time Fix";
        }
        field(13; "Functional Location"; Code[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code;
        }
        field(45; "Functional Location CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                shipToRec: Record "Ship-to Address";
            begin
                shipToRec.Reset();
                shipToRec.SetRange("CRM ID", Rec."Functional Location CRM");
                if shipToRec.FindFirst() then
                    Rec."Functional Location" := shipToRec.code;
            end;
        }
        field(14; "Opportunity"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(15; "Owner"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = Employee."No.";
        }
        field(48; "Owner CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                EmpRec: Record Employee;
            begin
                EmpRec.Reset();
                EmpRec.SetRange("CRM ID", Rec."Owner CRM");
                if EmpRec.FindFirst() then
                    Rec."Owner" := EmpRec."No.";
            end;
        }
        field(16; "Sales Order"; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(17; "Parent Work Order"; Code[200])
        {
            DataClassification = CustomerContent;
            // TableRelation = "Work Order";
        }
        field(18; "Taxable"; enum "Choice")
        {
            DataClassification = CustomerContent;
            // OptionMembers = Yes,No;
        }
        field(19; "Time Window Start"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Time Window End"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Topic"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(22; "Shortcut Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,2,1';
            Caption = 'Obrien_Business unit Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(47; "Shortcut Dimension 1 Code CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                DimRec: Record "Dimension Value";
            begin
                DimRec.Reset();
                DimRec.SetRange("Dimension Code", 'Obrien_Business Unit');
                DimRec.SetRange("CRM ID", Rec."Shortcut Dimension 1 Code CRM");
                if DimRec.FindFirst() then
                    Rec."Shortcut Dimension 1 Code" := DimRec.code;
            end;
        }
        field(23; "Work Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Work Location"; enum "Work Location")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ",Onsite,Remote;
            // OptionCaption = ' ,Onsite,Remote';
        }
        field(25; "Work Order Type"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "GKB Work Order Type"."Work Order Type Name";
        }
        field(44; "Work Order Type CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                workorderRec: Record "GKB Work Order Type";
            begin
                workorderRec.Reset();
                workorderRec.SetRange("CRM ID", Rec."Work Order Type CRM");
                if workorderRec.FindFirst() then
                    Rec."Work Order Type" := workorderRec."Work Order Type Name";
            end;
        }
        field(26; "Work Order Summary"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(27; "Status"; enum "Activity Status")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ",Active,InActive;
            // OptionCaption = 'Active,InActive';
        }
        field(28; "Job No."; Code[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "Job";
        }
        field(29; "Project Task No"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No.";
        }
        field(30; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(31; "Job Created"; Boolean)
        {
            Caption = 'job Created';
            DataClassification = ToBeClassified;
        }
        field(32; "Customer PO Number"; Text[200])
        {
            Caption = 'Customer PO Number';
            DataClassification = ToBeClassified;
        }
        field(33; "Description 2"; Text[200])
        {
            Caption = 'Description 2';
        }
        field(34; "Location Code"; Code[200])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
            DataClassification = CustomerContent;
        }
        field(35; "Blanket Order"; Code[200])
        {
            Caption = 'Blanket Order';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
            DataClassification = CustomerContent;
        }
        field(46; "Blanket Order CRM"; Text[200])
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                blanOrdRec: Record "Sales Header";
            begin
                if rec."Blanket Order CRM" = '' then
                    exit;
                blanOrdRec.Reset();
                blanOrdRec.SetRange("CRM ID", Rec."Blanket Order CRM");
                if blanOrdRec.FindFirst() then
                    Rec."Blanket Order" := blanOrdRec."No.";
            end;
        }
        field(36; "Payment Terms"; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        // HK::DCS 061025 ++
        field(37; "Primary Incident Type"; text[250])
        {
            Caption = 'Primary Incident Type';
            DataClassification = ToBeClassified;
            TableRelation = "Primary Incident Type".Name;
        }
        field(38; "SAP Service ID"; Integer)
        {
            Caption = 'SAP Service ID';
            DataClassification = ToBeClassified;
        }
        // HK::DCS 061025 --
        // DCS::HP 081025 ++
        field(49; "D365 Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        // DCS::HP 081025 --

        field(60; "Work Order Summary ML"; Blob)
        {
            Caption = 'Work Order Summary ML';
            DataClassification = CustomerContent;
        }
        field(50117; "Full Topic"; text[300])
        {
            caption = 'Full Topic';
            DataClassification = CustomerContent;
        }

    }


    keys
    {
        key(PK1; "Work Order No.")
        {
            Clustered = true;
        }
        key(PK2; "Work Order Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Dropdown; "Work Order No.", "Work Order Type", "Service Account")
        {
        }
    }

    procedure GetWorkDescription1() WorkDescription1: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Work Order Summary ML");
        "Work Order Summary ML".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("Work Order Summary ML")));
    end;

    procedure SetWorkDescription1(NewWorkDescription1: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Work Order Summary ML");
        "Work Order Summary ML".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription1);
        Modify();
    end;
}