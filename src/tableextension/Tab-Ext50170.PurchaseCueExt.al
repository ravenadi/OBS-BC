namespace GKBCustomizationsept.GKBCustomizationsept;

using Microsoft.Purchases.RoleCenters;
using Microsoft.Inventory.Requisition;
// DCS::HK 031025 ++

tableextension 50170 "Purchase Cue Ext" extends "Purchase Cue"
{
    fields
    {
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
    }
}
// DCS::HK 031025 --