codeunit 50119 "Create Order helper"
{
    trigger OnRun()
    var
    begin
        CreatePurchpurchaseorder();
    end;

    procedure CreatePurchpurchaseorder()
    var
        vendorNo: Code[20];
        PurchaseOrderHdr: Record "Purchase Header";
        PurchaseOrderHdr1: Record "Purchase Header";
        NextLine: Integer;
        RequisitionLine: Record "Requisition Line";
        LocationCode: Code[10];
        DimensionCode: Code[20];
        Count: Integer;
        index: Integer;   // Added newly
        PurchaseHeaderNo: Code[20];
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowManagement: Codeunit "Workflow Management";
        PurchaseCrmSync: Codeunit "PO CRM Sync Mgmt";
        PurchaseHeaderNoList: list of [Code[20]];
        Part: Code[20];
        MessageText: Text;
        Archieve: Record "D01 Requisition Line";
        LastEntryNo: Integer;
    begin
        Clear(PurchaseHeaderNoList);
        RequisitionLine.Reset();
        RequisitionLine.SetCurrentKey("Vendor No.", "Location Code", "Shortcut Dimension 1 Code");
        RequisitionLine.SetRange("Accept Action Message", true);
        RequisitionLine.SetFilter(StatusReq, '=%1', RequisitionLine.StatusReq::Released);//DCS:Jatin
        if RequisitionLine.FindSet() then begin
            if RequisitionLine."Requested By Name" <> '' then begin
                repeat
                    if RequisitionLine."Default PO" then begin
                        PurchaseHeaderNo := CreatePurchaseHeader(RequisitionLine, PurchaseOrderHdr);
                        NextLine := 0;
                        Count += 1;
                        PurchaseHeaderNoList.Add(PurchaseHeaderNo);
                    end else begin
                        if (RequisitionLine."Vendor No." <> vendorNo)
                        or (RequisitionLine."Location Code" <> LocationCode)
                        or (RequisitionLine."Shortcut Dimension 1 Code" <> DimensionCode) then begin
                            PurchaseHeaderNo := CreatePurchaseHeader(RequisitionLine, PurchaseOrderHdr);
                            vendorNo := RequisitionLine."Vendor No.";
                            LocationCode := RequisitionLine."Location Code";
                            DimensionCode := RequisitionLine."Shortcut Dimension 1 Code";
                            NextLine := 0;
                            Count += 1;
                            PurchaseHeaderNoList.Add(PurchaseHeaderNo);
                        end;
                    end;
                    NextLine += 10000;
                    CreatePurchaseLine(PurchaseHeaderNo, RequisitionLine);
                    Archieve.Reset();
                    Archieve.SetCurrentKey("Entry No ");
                    if Archieve.FindLast() then
                        LastEntryNo := Archieve."Entry No ";
                    Archieve.Init();
                    Archieve.TransferFields(RequisitionLine);
                    Archieve."Entry No " := LastEntryNo + 1;
                    if not Archieve.Insert() then
                        Archieve.Modify();

                    RequisitionLine.Delete();
                until RequisitionLine.Next() = 0;
                // Process approvals
                foreach Part in PurchaseHeaderNoList do begin
                    PurchaseOrderHdr1.Reset();
                    PurchaseOrderHdr1.SetRange("Document Type", PurchaseOrderHdr1."Document Type"::Order);
                    PurchaseOrderHdr1.SetRange("No.", Part);
                    if PurchaseOrderHdr1.FindFirst() then begin
                        if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchaseOrderHdr1) then
                            ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchaseOrderHdr1);
                         //GKBLabs_Tv_29/06/24 ++
                        // Send to CRM after approval to ensure record is committed
                        // Guard to avoid duplicate sends if an insert subscriber already sent
                        if PurchaseOrderHdr1."CRM ID" = '' then
                            PurchaseCrmSync.SendPurchaseOrderToCRM(Part);
                        // DCS::HP16032026 ++
                        // Send PO lines to CRM after header is synced
                        PurchaseCrmSync.SendPurchaseOrderLinesToCRM(Part);
                        // DCS::HP16032026 --
                    end;
                    //GKBLabs_Tv_29/06/24 --
                end;
                if PurchaseHeaderNoList.Count > 0 then begin
                    MessageText := 'Purchase Order(s) created with No.: ';
                    Index := 1;
                    foreach Part in PurchaseHeaderNoList do begin
                        if StrLen(MessageText) > 100 then begin
                            MessageText += '...';
                            break;
                        end;
                        MessageText += Part;
                        if Index < PurchaseHeaderNoList.Count then
                            MessageText += ', ';
                        Index += 1;
                    end;
                    Message(MessageText);
                end;
            end
            else
                Error('Cannot create Purchase Order as Requested By = '' ''.');
        end;
    end;

    local procedure CreatePurchaseHeader(IMpurchReqline: Record "Requisition Line"; PurchaseHDR: Record "Purchase Header"): Code[20]
    var
        PurchaseReceivableSetup_LRec: Record "Purchases & Payables Setup";
    begin
        PurchaseReceivableSetup_LRec.Get();
        PurchaseHDR.Init();
        PurchaseHDR."No." := NoSeriesManagment.GetNextNo(PurchaseReceivableSetup_LRec."Order Nos.", Today, true);
        PurchaseHDR.Validate("Document Type", PurchaseHDR."Document Type"::Order);
        PurchaseHDR.Validate("Buy-from Vendor No.", IMpurchReqline."Vendor No.");
        PurchaseHDR.Insert(true);
        PurchaseHDR.Validate(Status, PurchaseHDR.Status::Open);
        PurchaseHDR.Validate("Location Code", IMpurchReqline."Location Code");
        PurchaseHDR.Validate("Shortcut Dimension 1 Code", IMpurchReqline."Shortcut Dimension 1 Code");
        // DCS::HP17112025 ++
        PurchaseHDR.Validate("Gen. Bus. Posting Group", IMpurchReqline."Gen. Business Posting Group");
        // DCS::HP17112025 --
        if PurchaseHDR.Modify(true) then begin
            exit(PurchaseHDR."No.");
        end;
    end;

    local procedure CreatePurchaseLine(PurchaseHeaderNo: Code[20]; IMpurchReqline: Record "Requisition Line")
    var
        PurchLine: Record "Purchase Line";
        Lineno: Integer;
        PurchaseLine: Record "Purchase Line";
        FromDocumentAttachment: Record "Document Attachment";
        FromDocumentAttachment2: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        empRec: Record Employee;
        // GkbLabs_Tv_03/12/25
        ReqLineArchive: Record "Requisition Line Archive";
    begin
        // DCS::HP 10092025 ++
        if (IMpurchReqline.Quantity = 0) OR (IMpurchReqline."Location Code" = '') OR (IMpurchReqline."Shortcut Dimension 1 Code" = '') then
            Error('Cannot create a Purchase Order Line because Quantity, Warehouse or Obrien Business unit code for item %1 cannot be empty.', IMpurchReqline."No.");
        // DCS::HP 10092025 --
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("Document No.", PurchaseHeaderNo);
        if PurchaseLine.FindLast() then
            Lineno := PurchaseLine."Line No." + 10000
        else
            Lineno := 10000;
        PurchLine.Init();
        PurchLine."Document Type" := PurchLine."Document Type"::Order;
        PurchLine."Document No." := PurchaseHeaderNo;
        PurchLine."Line No." := Lineno;
        PurchLine.Insert(true);
        PurchLine.Validate("Buy-from Vendor No.", IMpurchReqline."Vendor No.");
        PurchLine.type := IMpurchReqline.Type;
        PurchLine.Validate("No.", IMpurchReqline."No.");
        PurchLine.Validate("Job No.", IMpurchReqline.projectNo);
        PurchLine.Validate("Job Task No.", IMpurchReqline."Project Task No");
        PurchLine.Validate("Location Code", IMpurchReqline."Location Code");
        PurchLine.Validate("Shortcut Dimension 1 Code", IMpurchReqline."Shortcut Dimension 1 Code");
        PurchLine.Validate(Quantity, IMpurchReqline.Quantity);
        PurchLine.Validate("Direct Unit Cost", IMpurchReqline."Direct Unit Cost");
        PurchLine.Validate("Expected Receipt Date", IMpurchReqline."Due Date");
        // DCS::HP17112025 ++
        PurchLine.Validate("Gen. Bus. Posting Group", IMpurchReqline."Gen. Business Posting Group");
        // DCS::HP17112025 --
        // DCS::HP 031025 ++
        PurchLine.validate("Job Line Type", PurchLine."Job Line Type"::"Both Budget and Billable");
        // DCS::HP 031025 --
        // DCS::HP04112025 ++ (Changes field "Ordered By" to "requested By Name")
        PurchLine.Validate("Ordered By", IMpurchReqline."Requested By Name");
        PurchLine.Validate("expected Receipt Date", IMpurchReqline."Due Date");
        PurchLine.Modify(true);

        //GkbLabs_Tv_03/12/25
        if IMpurchReqline.StatusReq = IMpurchReqline.StatusReq::Released then begin
            Clear(ReqLineArchive);
            ReqLineArchive.Init();
            ReqLineArchive.TransferFields(IMpurchReqline);
            ReqLineArchive."Archived Date" := CurrentDateTime;
            ReqLineArchive."Archived By" := UserId;
            ReqLineArchive."PO Number" := PurchaseHeaderNo;
            ReqLineArchive."PO Line Number" := PurchLine."Line No.";
            if ReqLineArchive.Insert(true) then;
        end;


        // Attachments to be flowed
        FromDocumentAttachment.Reset();
        FromDocumentAttachment.SetRange("Table ID", Database::"Requisition Line");
        if FromDocumentAttachment.IsEmpty() then
            exit;
        FromDocumentAttachment.SetRange("No.", IMpurchReqline."No.");
        FromDocumentAttachment.SetRange("Line No.", IMpurchReqline."Line No.");
        if FromDocumentAttachment.FindSet() then
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init();
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", Database::"Purchase Line");
                ToDocumentAttachment.Validate("Document Type", Enum::"Attachment Document Type"::Order);
                ToDocumentAttachment.Validate("No.", PurchaseHeaderNo);
                ToDocumentAttachment.Validate("Line No.", PurchLine."Line No.");
                if not ToDocumentAttachment.Insert(true) then;
                ToDocumentAttachment."Attached Date" := FromDocumentAttachment."Attached Date";
                ToDocumentAttachment.Modify();
            until FromDocumentAttachment.Next() = 0;
        FromDocumentAttachment2.Reset();
        FromDocumentAttachment2.SetRange("Table ID", Database::"Requisition Line");
        FromDocumentAttachment2.SetRange("No.", IMpurchReqline."No.");
        FromDocumentAttachment2.SetRange("Line No.", IMpurchReqline."Line No.");
        if FromDocumentAttachment2.FindSet() then
            FromDocumentAttachment2.DeleteAll();
    end;


    procedure GetPercentageValue(PriceListHeader: Record "Price List Header"; Item_lRec: Record Item): Decimal
    var
        PercentageValue: Decimal;
        UnitPrice: Decimal;
    begin
        Clear(PercentageValue);
        Clear(UnitPrice);
        if PriceListHeader."D01 Percentage" <> 0 then begin
            PercentageValue := (Item_lRec."Unit Price" * PriceListHeader."D01 Percentage") / 100;
            UnitPrice := Item_lRec."Unit Price" + PercentageValue;
        end
        else
            UnitPrice := Item_lRec."Unit Price";
        exit(UnitPrice);
    end;

    var
        NoSeriesManagment: Codeunit "No. Series";
}