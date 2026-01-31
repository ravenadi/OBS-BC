pageextension 50121 "Purchase Order Card Ext" extends "Purchase Order"
{
    layout
    {
        // DCS::HP08122025 ++
        modify(PayToOptions)
        {
            Editable = false;
        }
        // DCS::HP08122025 --
        addfirst(factboxes)
        {
            part(ItemDetailsFactBox; "Item Details Fact Box")
            {
                ApplicationArea = All;
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
        }
        addafter(ItemDetailsFactBox)
        {
            part(AlternateVendorFactbox; "Alternate Vendor Factbox")
            {
                ApplicationArea = All;
                Provider = PurchLines;
                SubPageLink = "Item No." = field("No.");

            }
        }

        moveafter("Status"; "Shortcut Dimension 1 Code")
        modify("Shortcut Dimension 1 Code")
        {
            ShowMandatory = true;
        }
        modify("Vendor Invoice No.")
        {
            ShowMandatory = false;
        }
        addlast(General)
        {
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = All;
                Caption = 'CRM ID';
                Editable = false;
                ToolTip = 'Shows the CRM record ID linked to this Purchase Order.';
            }
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = all;
                Caption = 'Ordered By';

            }
            field("Name Ordered By"; Rec."Name Ordered By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name Ordered By field.', Comment = '%';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
                Caption = 'Created By';
                Editable = false;
            }
            field("Job No"; Rec."Job No")
            {
                ApplicationArea = all;
                Caption = 'Work Order No.';
            }
            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = all;
                Caption = 'Delivery Docket No.';
            }
            // DCS::HP11112025 ++
            field("Special Instruction"; Rec."Special Instruction")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Special Instruction field.', Comment = '%';
            }
            // DCS::HP11112025 --
        }
        addafter("Buy-from Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("&Print")
        {
            Enabled = (Rec.Status = Rec.Status::Released);
            trigger OnBeforeAction()
            begin
                if Rec.Status <> Rec.Status::Released then begin
                    Message('Cannot print. The Purchase Order status must be Released.');
                    exit;
                end;
            end;
        }
        modify(SendCustom)
        {
            Enabled = (Rec.Status = Rec.Status::Released);
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                if Rec.Status <> Rec.Status::Released then begin
                    Message('Cannot Send. The Purchase Order status must be Released.');
                    exit;
                end;
            end;
        }
        // modify(Release)
        // {
        //     Enabled = (Rec.Status = Rec.Status::Released);
        //     trigger OnBeforeAction()
        //     begin
        //         if Rec.Status <> Rec.Status::Released then begin
        //             Message('Cannot Release. The Purchase Order status must be Released.');
        //             exit;
        //         end;
        //     end;
        // }
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
        // DCS::HP 18092025 --
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

    trigger OnAfterGetRecord()
    var
        PurchLine: Record "Purchase Line";
        VendorRec: Record Vendor;
    begin
        if VendorRec.Get(Rec."Buy-from Vendor No.") then begin
            Rec."Address 3" := VendorRec."Address 3";
            CurrPage.Update(false);
        end;

        // PurchLine.SetRange("Document Type", Rec."Document Type");
        // PurchLine.SetRange("Document No.", Rec."No.");
        // if PurchLine.FindFirst() then begin
        //     Rec."Ordered By" := PurchLine."Ordered By"; 
        // end;
    end;
}