tableextension 50129 "Sales Cue Ext" extends "Sales Cue" //DCS:SK 19/05/2025 ExtMerged NS
{
    fields
    {
        field(50100; "Primary Key."; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(50101; "Pending Approval"; Integer)
        {
            Caption = 'Pending Approval';
            FieldClass = FlowField;
            CalcFormula = count("Requisition Line" where("StatusReq" = filter("Pending Approval"), "Worksheet Template Name" = const('REQ')));
        }
        field(50102; "Rejected"; Integer)
        {
            Caption = 'Rejected';
            FieldClass = FlowField;
            CalcFormula = count("Requisition Line" where("StatusReq" = const("Rejected"), "Worksheet Template Name" = const('REQ')));
        }
        field(50103; Released; Integer)
        {
            Caption = 'Released';
            FieldClass = FlowField;
            CalcFormula = count("Requisition Line" where("StatusReq" = const(Released), "Worksheet Template Name" = const('REQ')));
        }
        field(50104; "PO Created"; Integer)
        {
            Caption = 'PO Created';
            FieldClass = FlowField;
            CalcFormula = count("Purchase Header" where("Document Type" = const(Order), "No." = filter(<> 0)));
        }

    }
}//DCS:SK 19/05/2025 ExtMerged NE
