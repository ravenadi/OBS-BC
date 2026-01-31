tableextension 50119 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; VendorCatalogueNo; Code[20])
        {
            ToolTip = 'Specifies vendor given name to the item';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                item: Record Item;
            begin
                item."Vendor 1 Catalogue Number" := Rec.VendorCatalogueNo;
            end;
        }
        field(50102; "Line Approval Sent"; Boolean)
        {
            Caption = 'Approval Sent';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50103; "Obrien_Business_Unit"; Code[40])
        {
            Caption = 'Obrien_Business_Unit_Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value";
        }
        field(50104; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50105; "ItemDescription"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("No.")));
            Editable = false;
        }
        field(50106; "ItemAvailability"; Decimal)
        {
            Caption = 'Item Availability';
            Editable = false;
        }
        field(50108; "Alternate Vendor for Item"; Code[50])
        {
            Caption = 'Alternate Vendor for Item';
            DataClassification = ToBeClassified;
            TableRelation = "Item Vendor"."Vendor No." where("Item No." = field("No."));
        }
        field(50109; "Work Order No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Work Order No.';
        }
        field(50110; "Ordered By"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ordered By';
            TableRelation = Employee."No.";
            ValidateTableRelation = true;

            // DCS::HP 11092025 ++
            // trigger OnValidate()
            // var
            //     FirstLine: Record "Purchase Line";
            //     PurchHeader: Record "Purchase Header";
            // begin
            //     FirstLine.Reset();
            //     FirstLine.SetRange("Document Type", rec."Document Type");
            //     FirstLine.SetRange("Document No.", rec."Document No.");
            //     FirstLine.SetCurrentKey("Line No.");
            //     if FirstLine.FindFirst() then begin
            //         if PurchHeader.Get(rec."Document Type", rec."Document No.") then begin
            //             PurchHeader."Ordered By" := rec."Ordered By";
            //             PurchHeader.Modify(true);
            //         end;
            //     end;
            // end;
            // DCS::HP 11092025 --
            //DCS::HJ 20251103++
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Rec."Ordered By" <> '' then begin
                    if Employee.Get(Rec."Ordered By") then
                        Rec."Name Ordered By" := Employee."First Name" + ' ' + Employee."Last Name"
                    else
                        Rec."Name Ordered By" := '';
                end else
                    Rec."Name Ordered By" := '';
            end;
            //DCS::HJ 20251103--
            
            
        }
        field(50211; "Name Ordered By"; text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."First Name";

        }
        field(50107; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        // DCS::HP 18092025 ++
        field(50210; "Car Registration No."; Code[50])
        {
            Caption = 'Car Registration No.';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 18092025 --
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                GenPosSetup: Record "General Posting Setup";
            begin
                if GenPosSetup.get(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group") then begin
                    Rec."G/L Account No." := GenPosSetup."Purch. Account";
                    // Rec.Modify();
                end;
            end;
        }
    }
    // trigger OnInsert()
    // var
    //     UserSetup: Record "User Setup";
    // begin
    //     if UserSetup.Get(UserId()) then
    //         Rec."Ordered By" := UserSetup."User ID";
    // end;
}
