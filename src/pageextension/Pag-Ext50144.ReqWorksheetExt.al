pageextension 50144 "Req. Worksheet Ext" extends "Req. Worksheet"
{
    Caption = 'Purchase Request';

    layout
    {

        //DCS::HK 14112025 ++
        modify(Type)
        {
            Editable = Not EditAllow;
        }
        modify("Accept Action Message")
        {
            Editable = Not EditAllow;
        }
        modify(Description)
        {
            Editable = Not EditAllow;
        }
        modify("Bin Code")
        {
            Editable = Not EditAllow;
        }
        modify(Quantity)
        {
            Editable = Not EditAllow;
        }
        modify("Unit of Measure Code")
        {
            Editable = Not EditAllow;
        }
        modify("Direct Unit Cost")
        {
            Editable = Not EditAllow;
        }
        modify("Currency Code")
        {
            Editable = Not EditAllow;
        }
        modify("Vendor No.")
        {
            Editable = Not EditAllow;
        }
        modify("Vendor Item No.")
        {
            Editable = Not EditAllow;
        }
        //DCS::HK 14112025 --

        modify("No.")
        {
            //DCS::HK 14112025 ++
            Editable = Not EditAllow;
            //DCS::HK 14112025 ++
            trigger OnAfterValidate()
            var
                ItemVendorCat: Record "Item Vendor";
                Item: Record Item;
            begin

                // Rec."Vendor Item No." := ItemVendorCat."Vendor Item No.";
                if Item.Get(Rec."No.") then begin
                    Rec."Vendor Item No." := Item."Vendor 1 Catalogue Number";
                    Rec.Description := Item.Description;
                    Rec."Direct Unit Cost" := Item."Unit Cost";
                end;
                ItemVendorCat.Reset();
                ItemVendorCat.SetRange("Item No.", Rec."No.");
                if ItemVendorCat.FindFirst() then
                    Rec."Unit Cost" := ItemVendorCat."Current Cost";
                // Rec.Validate("Due Date", Today);
                // Rec.Validate("Vendor No.");
                if Rec."No." <> xRec."No." then
                    Rec.Quantity := 0;

            end;

        }

        modify("Location Code")
        {
            Caption = 'Warehouse'; // Changing the location code to warehouse in req. worksheet.
            ShowMandatory = true;
            //DCS::HK 14112025 ++
            Editable = Not EditAllow;
            //DCS::HK 14112025 ++
        }
        modify("Requester ID")
        {
            Caption = 'Current User';
            //DCS::HK 14112025 ++
            Editable = Not EditAllow;
            //DCS::HK 14112025 ++
        }
        modify("Buy-from Vendor Name")
        {
            Visible = false;
        }
        modify("Description 2")
        {
            Visible = false;
        }
        modify(Control1903326807)
        {
            Visible = false;
        }

        modify("Due Date")
        {
            Caption = 'Required by date';
            ShowMandatory = true;
            //DCS::HK 14112025 ++
            Editable = Not EditAllow;
            //DCS::HK 14112025 --
        }
        modify("Shortcut Dimension 1 Code")
        {
            Caption = 'Obrien_Business Unit Code';
            ApplicationArea = all;
            //DCS::HK 14112025 ++
            Editable = Not EditAllow;
            //DCS::HK 14112025 ++
        }
        addlast(Control1)
        {
            field("Obrien Business Unit Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
        }
        addafter("Replenishment System")//DCS:SK 19/05/2025 ExtMerged NS
        {
            field("StatusReq"; Rec."StatusReq")//DCS:SK 19/05/2025 ExtMerged
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the current status of the customer';
                Importance = Promoted;
                Editable = true;
                //DCS::HK 14112025 ++
                trigger OnValidate()
                var
                    myInt: Integer;
                    UserSetup: Record "User Setup";
                begin
                    UserSetup.SetRange("User ID", UserId);
                    if UserSetup.FindFirst() then begin

                        UserSetup.TestField("Req. Worksheet Status Allowed");
                    end;

                    IsEditable();
                    CurrPage.Update(true);

                end;
                //DCS::HK 14112025 --
            }
        }//DCS:SK 19/05/2025 ExtMerged NE
        addafter("Vendor No.")
        {
            field(VendorName; Rec.VendorName)
            {
                ApplicationArea = all;
                Visible = true;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
            }
            field("Requested By Name"; Rec."Requested By Name")
            {
                ApplicationArea = all;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
            }
            //DCS::HP04112025 ++
            field("Requested By Name2"; Rec."Requested By Name2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested By Name field.', Comment = '%';
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
            }
            //DCS::HP04112025 --

            //DCS:SK 17/04/2025 NS
            field(Availability; CalcAvailability(Rec)) //DCS:SK 17/04/2025 NS
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Total Availability';
                DecimalPlaces = 0 : 5;
                DrillDown = true;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
                ToolTip = 'Specifies the available quantity of the item in open item ledger entries.';

                trigger OnDrillDown()
                begin
                    ShowItemLedgerEntries(Rec);
                    CurrPage.Update(true);
                end;
            } //DCS:SK 17/04/2025 NE
            field("Alternate Vendor For Item"; Rec."Alternate Vendor For Item")
            {
                ApplicationArea = all;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
                ToolTip = 'Checks item has alternate vendor or not';
            }
            field("Ship To"; Rec."Ship To")
            {
                ApplicationArea = all;
            }
        }
        addafter(Control1903326807)
        {
            part(ItemAvailability; "Req WO FactBox")
            {
                ApplicationArea = Planning;
                SubPageLink = "Worksheet Template Name" = field("Worksheet Template Name"), "Journal Batch Name" = field("Journal Batch Name"), "Line No." = field("Line No.");
                Visible = true;
            }
            part("Document Attchment"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(246), "No." = field("No."),
                                  "Line No." = field("Line No.");
            }
        }
        addafter(Control1)
        {
            part(Inventory; "Req WO FactBox")
            {
                ApplicationArea = Planning;
                SubPageLink = "Worksheet Template Name" = field("Worksheet Template Name"), "Journal Batch Name" = field("Journal Batch Name"), "Line No." = field("Line No.");
                Visible = false;
            }
        }

        addafter("Location Code")
        {
            field("Item Availability By Location"; Rec."Item Availability By Location")
            {
                ApplicationArea = all;
                //DCS::HK 14112025 ++
                // Editable = false;
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
            }

        }
        addafter("Vendor Item No.")
        {
            field("project no"; Rec.projectNo)
            {
                ApplicationArea = all;
                ShowMandatory = true;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
            }
            field("Project Task No"; Rec."Project Task No")
            {
                ApplicationArea = all;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
            }
        }
        // DCS::HP13112025 ++
        addafter("Bin Code")
        {
            field("Gen. Business Posting Group"; Rec."Gen. Business Posting Group")
            {
                ApplicationArea = All;
                //DCS::HK 14112025 ++
                Editable = Not EditAllow;
                //DCS::HK 14112025 ++
                ToolTip = 'Specifies the code of the general business posting group to be used for the item when you post the planning worksheet.';
            }
        }
        // DCS::HP13112025 --
        // DCS::HP17112025 ++
        addbefore(StatusReq)
        {
            field("Deafult PO"; rec."Default PO")
            {
                ApplicationArea = all;
                Caption = 'Default PO';
            }
        }
        // DCS::HP17112025 --
    }
    actions
    {
        // Jathin's Code strts from here
        addafter(Reserve)
        {
            action("Create Purchase Order")
            {
                ApplicationArea = All;
                Caption = 'Create Purchase Order', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CreateDocuments;

                trigger OnAction()
                var
                    CreatedOrderHelper: Codeunit "Create Order helper";
                    // RequisitionLine: Record "Requisition Line";
                    RequisitionLine: record "Requisition Line";//DCS:SK 19/05/2025 ExtMErged
                    Archieve: Record "D01 Requisition Line"; //DCS HJ 20251121

                begin
                    //DCS:SK 01/04/2025 NS
                    if Confirm('Do you want to create purchase orders?', false) then begin
                        CreatedOrderHelper.CreatePurchpurchaseorder();
                        //DCS HJ 20251121++
                        // RequisitionLine.Reset();
                        // if RequisitionLine.FindSet() then begin
                        //     repeat
                        //         Archieve.Init();
                        //         Archieve.TransferFields(RequisitionLine);
                        //         Archieve.Insert();
                        //     until RequisitionLine.Next() = 0;
                        // end;
                        //DCS HJ 20251121--
                        // RequisitionLine.Reset();
                        // RequisitionLine.SetCurrentKey("Vendor No.", "Location Code", "Shortcut Dimension 1 Code"); //20000 //DCS:SK 19/05/2025 ExtMerged
                        // if RequisitionLine.FindSet() then
                        //     repeat
                        //         if (RequisitionLine.StatusReq <> RequisitionLine.StatusReq::Released) and RequisitionLine."Accept Action Message" then Error('Status must be released');
                        //     until RequisitionLine.Next() = 0; //DCS:SK 19/05/2025 ExtMerged
                        // RequisitionLine.Reset();
                        // RequisitionLine.SetRange("Worksheet Template Name", Rec."Worksheet Template Name");
                        // RequisitionLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        // RequisitionLine.DeleteAll();
                        // DCS:SK 01/04/2025 NE
                    end;
                end;
            }
            action(Submit)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Email;
                trigger OnAction()
                var
                    ReqWorksheetEmail: Codeunit "Email Mngt Req worksheet";
                begin
                    ReqWorksheetEmail.RequisitionPendingStatus(Rec);

                end;
            }
        }
    }

    local procedure FilterItem(var Item: Record Item; LocationCode: Code[20]; VariantCode: Code[20]; Date: Date)
    begin
        // Do not make global
        // Request to make function global has been rejected as it is a skeleton function of the codeunit
        Item.SetRange("No.", Item."No.");
        Item.SetRange("Date Filter", 0D, Date);
        Item.SetRange("Variant Filter", VariantCode);
        Item.SetRange("Location Filter", LocationCode);
    end;

    local procedure CalcAvailability(var ReqLine: Record "Requisition Line"): Decimal //DCS:SK 17/04/2025 NS
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
    begin
        if ReqLine."No." = '' then exit(0);
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ReqLine."No.");
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindSet() then
            repeat
                TotalQuantity += ItemLedgerEntry."Remaining Quantity";
            until
               ItemLedgerEntry.Next() = 0;
        exit(TotalQuantity);
    end; //DCS:SK 17/04/2025 NE

    local procedure ShowItemLedgerEntries(var ReqLine: Record "Requisition Line") //DCS:SK 17/04/2025 NS added
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntries: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ReqLine."No.");
        ItemLedgerEntry.SetRange(Open, true);
        ItemLedgerEntries.SetTableView(ItemLedgerEntry);
        ItemLedgerEntries.RunModal();
    end;
    //DCS::HK 14112025 ++
    // procedure CanEditField(): Boolean
    // begin
    //     // Check if the Status is Released (or any other condition you want)
    //     if rec.StatusReq = rec.StatusReq::Released then
    //         exit(false);  // Field is non-editable

    //     exit(true);  // Field is editable if status is not 'Released'
    // end;

    trigger OnAfterGetCurrRecord()
    begin
        IsEditable();
    end;

    local procedure IsEditable(): Boolean
    begin
        if rec.StatusReq = Status::Released then begin
            // Editable only if NOT Released
            EditAllow := true;
        end else begin
            EditAllow := false;
        end;
    end;
    //DCS::HK 14112025 --

    //DCS:SK 17/04/2025 NE

    // DCS::HP 09092025 HP ++
    // trigger OnNewRecord(Belowx: Boolean)
    // var
    //     userRec: Record "User Setup";
    // begin
    //     IF userRec.GET(userID) THEN begin
    //         Rec."Requested By Name" := userRec."User ID";
    //     end;
    // end;
    // DCS::HP 09092025 HP --
    var
        EditAllow: Boolean;

}