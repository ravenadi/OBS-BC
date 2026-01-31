pageextension 50124 "Purch Invoice Ext" extends "Purchase invoice"
{
    layout
    {
        // DCS::HP08122025 ++
        modify(PayToOptions)
        {
            Editable = false;
        }
        // DCS::HP08122025 --
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin

            end;
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if rec."Shortcut Dimension 1 Code" = '' then begin
                    Error('The Obrien Business Unit Code must have a value.');
                    exit;
                end;
            end;
        }
        // DCS::HP 18092025 ++
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                purchLine: record "Purchase Line";
            begin
                purchLine.SetRange("Document Type", rec."Document Type");
                purchLine.SetRange("Document No.", rec."No.");
                if purchLine.FindFirst() then begin
                    repeat
                        if purchLine."Location Code" = '' then begin
                            Error('Cannot Send Approval Request. The Location Code on the Purchase Line must have a value.');
                            exit;
                        end;
                    until purchLine.Next() = 0;
                end;
            end;
        }
        // DCS::HP 18092025 --
    }

}