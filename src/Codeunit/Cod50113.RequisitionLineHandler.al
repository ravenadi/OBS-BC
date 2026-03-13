codeunit 50113 "Requisition Line Handler"
{
    // DCS::HP13112025 ++ commented the code and written on page codeunit 50108
    // [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnAfterValidateEvent, "Vendor No.", false, false)]
    // local procedure CheckAlternateVendorsOnAfterInsertPurchaseLine(var Rec: Record "Requisition Line")
    // begin
    //     if Rec.Type = Rec.Type::Item then
    //         SetAlternateVendorField(Rec);
    // end;

    // local procedure SetAlternateVendorField(var ReqLine: Record "Requisition Line")
    // var
    //     ItemVendor: Record "Item Vendor";
    //     VendorCount: Integer;
    // begin
    //     if ReqLine."No." = '' then
    //         exit;

    //     ItemVendor.Reset();
    //     ItemVendor.SetRange("Item No.", ReqLine."No.");
    //     VendorCount := ItemVendor.Count;

    //     if VendorCount > 1 then begin
    //         ReqLine."Alternate Vendor For Item" := true;
    //         // ReqLine.Modify();
    //     end;
    // end;
    // DCS::HP13112025 +--

    // Auto incerement Line No. in Requisition Line while inserting the record from the other system.
    // Line line no will be incremented only manually inserted records in BC.
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertRequisitionLine(var Rec: Record "Requisition Line")
    begin
        if (Rec."Line No." = 0) then
            Rec.Validate("Line No.", GetLastLineNo(Rec));
    end;

    local procedure GetLastLineNo(ReqLine: Record "Requisition Line"): Integer
    var
        RequisitionLine: Record "Requisition Line";
        LastLineNo: Integer;
    begin
        RequisitionLine.Reset();
        RequisitionLine.SetCurrentKey("Worksheet Template Name", "Journal Batch Name", "Line No.");
        RequisitionLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        RequisitionLine.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");

        if RequisitionLine.FindLast() then
            LastLineNo := RequisitionLine."Line No." + 10000
        else
            LastLineNo := 10000;

        exit(LastLineNo);
    end;

    //Auto Increatment Line No. In Blanket Order Lines while inserting the record from the other system.
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertBlanketSalesLine(var Rec: Record "Sales Line")
    begin
        if (Rec."Line No." = 0) then
            Rec.Validate("Line No.", GetLastLineNo(Rec));
    end;

    local procedure GetLastLineNo(BlanketSalesLine: Record "Sales Line"): Integer
    var
        LastBlanketSalesLine: Record "Sales Line";
        LastLineNo: Integer;
    begin
        LastBlanketSalesLine.Reset();
        LastBlanketSalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
        LastBlanketSalesLine.SetRange("Document Type", BlanketSalesLine."Document Type"::"Blanket Order");
        LastBlanketSalesLine.SetRange("Document No.", BlanketSalesLine."Document No.");

        if LastBlanketSalesLine.FindLast() then
            LastLineNo := LastBlanketSalesLine."Line No." + 10000
        else
            LastLineNo := 10000;

        exit(LastLineNo);
    end;

    // Update Item Availability By Location in Req. Worksheet
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure UpdateItemAvailabilityOnLocationChange(var Rec: Record "Requisition Line"; var xRec: Record "Requisition Line")
    begin

        if Rec.Type = Rec.Type::Item then
            UpdateItemAvailabilityByLocation(Rec);
    end;

    local procedure UpdateItemAvailabilityByLocation(var ReqLine: Record "Requisition Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
    begin
        if (ReqLine."No." = '') then
            exit;

        if (ReqLine."Location Code" = '') then begin
            ReqLine."Item Availability By Location" := 0;
            exit;
        end;

        TotalQuantity := 0;
        ItemLedgerEntry.SetFilter("Item No.", ReqLine."No.");
        ItemLedgerEntry.SetFilter("Location Code", ReqLine."Location Code");

        if ItemLedgerEntry.FindSet() then
            repeat
                TotalQuantity += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next() = 0;

        ReqLine."Item Availability By Location" := TotalQuantity;
    end;


    // Item Quantity based on Location code in Item Journel
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure UpdateItemAvailabilityOnLocationChangeForItemJournel(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line")
    begin
        UpdateItemAvailabilityByLocation(Rec);
    end;

    local procedure UpdateItemAvailabilityByLocation(var ItemJnlLine: Record "Item Journal Line")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
    begin
        if (ItemJnlLine."Item No." = '') or (ItemJnlLine."Location Code" = '') then
            exit;

        TotalQuantity := 0;
        ItemLedgerEntry.SetFilter("Item No.", ItemJnlLine."Item No.");
        ItemLedgerEntry.SetFilter("Location Code", ItemJnlLine."Location Code");

        if ItemLedgerEntry.FindSet() then
            repeat
                TotalQuantity += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next() = 0;

        ItemJnlLine."Item Availability By Location" := TotalQuantity;
        // ItemJnlLine.Modify();
    end;

    // Upadate the Comment value from Item journel to Item Ledger Entry.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; TransferItem: Boolean; OldItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLineOrigin: Record "Item Journal Line")
    begin
        ItemLedgerEntry.Comment := ItemJournalLine.Comment;
        // copy bin code so the ledger entry carries it for CRM sync
        ItemLedgerEntry."Bin Code" := ItemJournalLine."Bin Code";
    end;

    // Update the trasfer note from the Tranfer line to Posted Transfer Note.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforeInsertTransRcptLine', '', false, false)]
    local procedure OnBeforeInsertTransRcptLine(var TransRcptLine: Record "Transfer Receipt Line"; TransLine: Record "Transfer Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; TransferReceiptHeader: Record "Transfer Receipt Header")
    begin
        TransRcptLine."Transfer Note" := TransLine."Transfer Note";
    end;
}