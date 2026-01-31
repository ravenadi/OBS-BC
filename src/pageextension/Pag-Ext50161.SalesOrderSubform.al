pageextension 51003 "Sales Order Subform Custom" extends "Sales Order Subform"
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
        addafter(Quantity)
        {
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
            }
        }

        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}