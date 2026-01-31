namespace GKBCustomization.GKBCustomization;

using Microsoft.Purchases.Document;
// DCS::HP 18092025 ++ 

pageextension 50185 "Purchase Credit Memo Ext" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Vendor Cr. Memo No.")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the vendor invoice number for the credit memo.';
                Editable = true;
                Caption = 'Vendor Invoice No.';
            }
        }
    }
    actions
    {
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            var
                purchLine: record "Purchase Line";
            begin
                if rec."Vendor Invoice No." = '' then begin
                    Error('Cannot Send Approval Request. The Vendor Invoice No. must have a value.');
                    exit;
                end;
                purchLine.SetRange("Document Type", rec."Document Type");
                purchLine.SetRange("Document No.", rec."No.");
                if purchLine.FindFirst() then begin
                    repeat
                        if (purchLine."Job No." = '') or
                        (purchLine."Shortcut Dimension 1 Code" = '') or
                        (purchLine."Ordered By" = '') then begin
                            Error('Cannot Send Approval Request. The (OBU/ Project No/ Ordered By) on the Purchase Line must have a value.');
                            exit;
                        end;
                    until purchLine.Next() = 0;
                end;
            end;
        }
        // DCS::HP18112025 ++
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Shortcut Dimension 1 Code" = '' then begin
                    Error('The Obrien Business Unit Code must have a value');
                    exit
                end;
            end;
        }
        // DCS::HP18112025 --
    }
}
// DCS::HP 18092025 --
