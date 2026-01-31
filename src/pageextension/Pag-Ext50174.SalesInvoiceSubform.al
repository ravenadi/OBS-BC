namespace GKBCustomization.GKBCustomization;
using Microsoft.Sales.Document;
using Microsoft.Finance.GeneralLedger.Setup;

pageextension 50174 "Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                GenPosSetup: Record "General Posting Setup";
            begin

                if GenPosSetup.get(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group") then begin
                    Rec."G/L Account No." := GenPosSetup."Sales Account";
                    Rec.Modify();
                end;
            end;
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
