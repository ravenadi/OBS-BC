namespace GKBCustomizationsept.GKBCustomizationsept;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Foundation.Reporting;
using Microsoft.Purchases.Vendor;

tableextension 50168 "Gen. Journal Line Ext " extends "Gen. Journal Line"
{
    fields
    {
        // DCS::HP 250925 ++
        field(50100; "Remmitance Email"; Text[200])
        {
            Caption = 'Remmitance Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Custom Report Selection"."Send To Email"
                                 where("Source No." = field("Account No."),
                                       Usage = const("Report Selection Usage"::"V.Remittance")));
        }

        field(50101; "Remmitance Report"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // Gkblabs_Tv_03/12/25
        field(50102; Test; Boolean)
        {
            Caption = 'Select to move the batch';
            DataClassification = ToBeClassified;
            ToolTip = 'Mark this line to include it in batch consolidation and movement.';
        }
        // 08-JAN-2026 ++
        field(50103; "EFT BSB No."; Code[10])
        {
            Caption = 'EFT BSB No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Vendor Bank Account"."EFT BSB No."
                                 where("Vendor No." = field("Account No.")));
            Editable = false;
        }
        // 08-JAN-2026 --

    }
}