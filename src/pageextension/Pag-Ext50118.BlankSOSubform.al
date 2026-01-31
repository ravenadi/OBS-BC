pageextension 50118 "Blank SO Subform" extends "Blanket Sales Order Subform"
{
    layout
    {
        // DCS::HP 20252207 ++
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                GenPosSetup: Record "General Posting Setup";
            begin

                if GenPosSetup.get(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group") then begin
                    Rec."G/L Account No." := GenPosSetup."Sales Account";
                end;
            end;
        }
        // DCS::HP 20252207 --
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        modify(Quantity)
        {
            Editable = Rec."Outstanding Qty. (Base)" = Rec.Quantity;
            trigger OnBeforeValidate()
            begin
                if Rec."Quantity" <> 0 then begin
                    if Rec."Remaining Quantity" >= 0 then
                        Rec."Remaining Quantity" := Rec."Quantity";
                end;
            end;
        }
        addafter(Quantity)
        {
            field("Remaining Quantity"; Rec."Remaining Quantity")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("QuantityShippedtillnow"; Rec."QuantityShippedtillnow")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Location Code")
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                editable = true;
            }
            field("Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                editable = true;
            }
        }
    }
}