tableextension 50126 "Job Planning Line Ext" extends "Job Planning Line"
{
    fields
    {
        field(50100; "Service Duration"; Decimal)
        {
            Caption = 'Service Duration';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                if (Rec."Service Duration" <> 0) and (Rec."Service Duration" <> xRec."Service Duration") then
                    Rec."Total Cost For Service" := Round("Unit Price" * "Service Duration");
            end;
        }
        field(50101; "Total Cost For Service"; Decimal)
        {
            Caption = 'Total Service Cost';
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50102; "Total Line Cost"; Decimal)
        {
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("Job No.")));
            Caption = 'Total Line Cost';
            Editable = false;
        }
        field(50103; "Total Line Amount"; Decimal)
        {
            FieldClass = FlowField;
            DecimalPlaces = 0 : 5;
            CalcFormula = Sum("Job Planning Line"."Line Amount" WHERE("Job No." = FIELD("Job No.")));
            Caption = 'Total Line Amount';
            Editable = false;
        }
        field(50104; "Owner"; Text[100])
        {
            Caption = 'Owner CRM';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        // DCS::HP01122025++
        field(50105; "Project Sub-Task No."; Text[100])
        {
            Caption = 'Project Sub-Task No.';
            DataClassification = ToBeClassified;
        }
        // DCS::HP01122025--
        field(50106; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }

        //GKb-surender
        field(50110; "Is Labour"; Boolean)
        {
            Caption = 'Is Labour';
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    var
        JobLabourMgt: Codeunit "Job Labour Summary Mgt";

    trigger OnAfterInsert()
    begin
        JobLabourMgt.RecalculateJobLabour(Rec."Job No.");
    end;

    trigger OnAfterModify()
    begin
        JobLabourMgt.RecalculateJobLabour(Rec."Job No.");
    end;

    trigger OnBeforeDelete()
    begin
        JobLabourMgt.RecalculateJobLabour(Rec."Job No.");
    end;
}
//GKb-surender-