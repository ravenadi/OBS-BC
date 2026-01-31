tableextension 50124 "Job Ext" extends Job
{
    fields
    {
        field(50100; Comments2; Text[200])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; Name; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Service Account"; Code[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "Customer"; // Replace with the related table if different
        }
        field(50103; "Work Order Type"; Text[200])
        {
            DataClassification = CustomerContent;
            TableRelation = "GKB Work Order Type";
        }
        field(50104; "System Status"; enum "Task Status1")
        {
            DataClassification = CustomerContent;
            // OptionMembers = Unscheduled,Scheduled,"In Progress",Completed,Invoiced,Cancelled;
            // DCS::HP 03092025 ++
            trigger OnValidate()
            var
                workOrderSubRec: Record "Work Order Substatus";
            begin
                workOrderSubRec.Reset();
                workOrderSubRec.SetRange("System SubStatus", Rec."System status");
                if workOrderSubRec.Findset() then
                    if "System Status"::Unscheduled = workOrderSubRec."System Substatus"::Unscheduled then
                        workOrderSubRec.SetFilter("CRM ID", '78046c36-405c-ee11-be6f-000d3a7940d7');
                if workOrderSubRec.FindFirst() then begin
                    Substatus := '';
                    Substatus := workOrderSubRec.Name;
                end
                else if "System Status"::Scheduled = workOrderSubRec."System Substatus"::scheduled then begin
                    Substatus := '';
                end
                else
                    Substatus := '';
                Substatus := workOrderSubRec.Name;

            end;
            // DCS::HP 03092025 --
        }

        field(50105; "Sales Order"; Code[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Blanket Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Blanket Order"));
            //  HK::DCS 14102025 (Made the field editable true from false on the requirement of GKB)
            Editable = True;
        }

        field(50106; "Billing Type"; enum "Charge Status")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ","Charge Up","Quoted","Monthly Billing","Not Chargeable","N/A";
        }
        field(50107; "Customer PO Number"; Text[200])
        {
            Caption = 'Customer PO Number';
            DataClassification = ToBeClassified;
        }
        field(50108; "Substatus"; Code[50])
        {
            DataClassification = CustomerContent;
            // DCS::HP 02092025 ++
            TableRelation = "Work Order Substatus".Name where("System Substatus" = field("System Status"));
            ValidateTableRelation = false;
            // DCS::HP 02092025 --
        }
        field(50109; "Invoice Created"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50110; "Case Custom"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(50111; Owner; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
            Caption = 'Owner';
        }
        // HP::DCS 061025 ++
        field(50112; "Primary Incident Type"; text[250])
        {
            Caption = 'Primary Incident Type';
            DataClassification = ToBeClassified;
            TableRelation = "Primary Incident Type".Name;
        }
        field(50113; "SAP Service ID"; Integer)
        {
            Caption = 'SAP Service ID';
            DataClassification = ToBeClassified;
        }
        field(50114; "Agreement"; Text[200])
        {
            DataClassification = CustomerContent;
        }
        field(50115; "Parent Work Order"; Code[200])
        {
            DataClassification = CustomerContent;
        }
        // HP::DCS 061025 --
        // DCS::HP 081025 ++
        field(50116; "D365 Ending Date"; Date)
        {
            Caption = 'D365 Ending Date';
            DataClassification = CustomerContent;
        }
        // DCS::HP 081025 --

        // DCS::HK 13102025 ++
        field(50117; "Full Topic"; text[300])
        {
            caption = 'Full Topic';
            DataClassification = CustomerContent;
        }
        // DCS::HK 13102025 --
        field(50119; "Status Manual Edit"; Boolean)
        {
            DataClassification = CustomerContent;
        }
        // DCS::HP01122025++
        field(50120; "Project Usage (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = sum("Job Ledger Entry"."Total Cost (LCY)" where("Job No." = field("No."),
                                                                           "Entry Type" = const(Usage),
                                                                           "Posting Date" = field("Posting Date Filter")));
            Caption = 'Project Actual (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        // DCS::HP01122025--
        // DCS::HP02122025 ++
        field(50121; "CRM ID"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'CRM ID';
        }
        //GKb-surender


        field(50122; "Total Labour Quantity"; Decimal)
        {
            Caption = 'Total Labour Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        //GKb-surender---
        // DCS::HP02122025 --
    }

    // DCS::HP30102025 ++
    trigger OnAfterInsert()
    begin
        fieldUpdate()
    end;

    trigger OnAfterModify()
    begin
        fieldUpdate()
    end;

    trigger OnBeforeDelete()
    begin
        fieldDelete();
    end;

    procedure fieldUpdate()
    var
        SalesHeader: Record "Sales Header";
    begin
        if "Sales Order" <> '' then begin
            if SalesHeader.Get(SalesHeader."Document Type"::"Blanket Order", "Sales Order") then begin
                SalesHeader."Customer PO Number" := rec."Customer PO Number";
                SalesHeader."Full Topic" := rec."Full Topic";
                SalesHeader.Modify(true);
            end;
        end;
    end;

    procedure fieldDelete()
    var
        SalesHeader: Record "Sales Header";
    begin
        if "Sales Order" <> '' then begin
            if SalesHeader.Get(SalesHeader."Document Type"::"Blanket Order", "Sales Order") then begin
                SalesHeader."Customer PO Number" := '';
                SalesHeader."Full Topic" := '';
                SalesHeader."Blanket Sales Order No." := '';
                SalesHeader.Modify(true);
            end;
        end;
    end;
    // DCS::HP30102025 --
}
