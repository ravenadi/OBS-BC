codeunit 50114 "Event Subscriber"
{
    Permissions = tabledata "Sales Shipment Header" = RIMD;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", OnCreateSalesInvoiceLinesOnBeforeCreateSalesLine, '', false, false)]
    local procedure "Job Create-Invoice_OnCreateSalesInvoiceLinesOnBeforeCreateSalesLine"(var JobPlanningLine: Record "Job Planning Line"; SalesHeader: Record "Sales Header"; SalesHeader2: Record "Sales Header"; NewInvoice: Boolean; var NoOfSalesLinesCreated: Integer)
    var
        job: Record Job;
    begin
        SalesHeader."Job No." := JobPlanningLine."Job No.";
        SalesHeader."Job Task No" := JobPlanningLine."Job Task No.";
        job.Reset();
        job.SetRange("No.", JobPlanningLine."Job No.");
        if job.FindFirst() then begin
            SalesHeader."Customer PO Number" := job."Customer PO Number";
            SalesHeader."Sales Order No." := job."Sales Order";
            SalesHeader.Name := job.Description;
            SalesHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", OnBeforeShowMessageLinesTransferred, '', false, false)]
    local procedure OnBeforeShowMessageLinesTransferred(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    // DCS::HP 26082025 ++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnAfterCreateSalesInvoiceLines', '', false, false)]
    local procedure OnAfterCreateSalesInvoiceLines(NewInvoice: Boolean; SalesHeader: Record "Sales Header")
    var
        ConfirmText: Label 'The lines were successfully transferred to an invoice. Do you want to open Invoice %1?';
        SalesInvoicePage: Page "Sales Invoice";
    begin
        if Confirm(ConfirmText, true, SalesHeader."No.") then begin
            SalesInvoicePage.SetRecord(SalesHeader);
            SalesInvoicePage.Run();
        end;
    end;
    // DCS::HP 26082025 --

    [EventSubscriber(ObjectType::Table, Database::"Sales line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertJobPlanningLine(var Rec: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Gen. Prod. Posting Group" = '') and (Rec."Unit of Measure" <> '') then begin
            if Item.Get(Rec."No.") then begin
                Rec."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                Rec."Unit of Measure" := Item."Base Unit of Measure";
                Rec.Modify();
            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterInsertInvoiceHeader', '', false, false)]
    local procedure OnAfterInsertSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header")
    begin
        SalesInvHeader."Customer PO Number" := SalesHeader."Customer PO Number";
        // SalesInvHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", OnBeforeInsertEvent, '', false, false)]
    local procedure OnBeforeCreateSalesInvoice1(var rec: Record "Job Planning Line")
    var
        Item: Record Item;
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            if Item.Get(Rec."No.") then begin
                Rec."Unit of Measure Code" := Item."Base Unit of Measure";
                Rec."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
            end;
        end;
    end;

    // Quantity error ::HP::
    // [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", OnAfterInsertEvent, '', false, false)]
    // local procedure QtyToQtytojournelUpdate(var rec: Record "Job Planning Line")
    // var
    //     Item: Record Item;
    // begin
    //     if (Rec.Type = Rec.Type::Item) and (Rec.Quantity <> 0) then begin
    //         rec.Validate(Quantity, rec."Qty. to Transfer to Journal");
    //     end;
    // end;

    [EventSubscriber(ObjectType::Page, Page::"Job Card", 'OnBeforeActionEvent', 'Create Job &Sales Invoice', true, true)]
    local procedure OnAfterActionEvent(var Rec: Record Job)
    var
        salesheader: Record "Sales Header";
    begin
        salesheader.Reset();
        salesheader.SetRange("Document Type", salesheader."Document Type"::Invoice);
        salesheader.SetRange("Job No.", Rec."No.");
        if salesheader.FindFirst() then;

        if Rec."Invoice Created" = true then
            Error('Invoice already created for this job sales invoice No%1', salesheader."No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptHeaderInsert', '', false, false)]
    local procedure OnAfterPurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean)
    begin
        if PurchaseHeader."Ordered By" <> '' then
            PurchRcptHeader.Validate("Ordered By", PurchaseHeader."Ordered By");
        if PurchaseHeader."Created By" <> '' then
            PurchRcptHeader.Validate("Created By", PurchaseHeader."Created By");
        if PurchaseHeader."Delivery Docket No." <> '' then
            PurchRcptHeader.Validate("Delivery Document No", PurchaseHeader."Delivery Docket No.");
        PurchRcptHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        if PurchHeader."Ordered By" <> '' then
            PurchInvHeader.Validate("Ordered By", PurchHeader."Ordered By");
        if PurchHeader."Created By" <> '' then
            PurchInvHeader.Validate("Created By", PurchHeader."Created By");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Work Order Lines", 'OnAfterValidateEvent', 'Code', false, false)]
    local procedure UpdateVendorDetailsOnItemChange(var Rec: Record "Work Order Lines")
    var
        WO: Record "Work Order";
    begin
        WO.SetRange("Work Order No.", Rec."Work Order No.");
        if WO.FindFirst() then begin
            Rec."Job No." := WO."Job No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterModifyEvent', '', false, false)]
    local procedure UpdateGSTonSalesLines(var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        // Check if the document is an Order and is in Open status
        if (Rec."Document Type" = Rec."Document Type"::Order) and
           (Rec.Status = Rec.Status::Open) and

           ((Rec."GST Prod Posting Group" <> '') or (Rec."GST Prod Posting Group" <> xRec."GST Prod Posting Group")) then begin
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange("Document No.", Rec."No.");

            if SalesLine.FindSet() then
                repeat
                    SalesLine.Validate("Gen. Prod. Posting Group", Rec."GST Prod Posting Group");
                    SalesLine.Modify(true);
                until SalesLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Wksh.-Make Order", OnInsertPurchOrderLineOnAfterTransferFromReqLineToPurchLine, '', false, false)]
    local procedure OnAfterTransferFromReqLineToPurchaseLine(var PurchOrderLine: Record "Purchase Line"; RequisitionLine: Record "Requisition Line")
    var
        Purchorder: Record "Purchase Header";
    begin
        if PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::Order then begin
            if RequisitionLine."Shortcut Dimension 1 Code" <> '' then
                PurchOrderLine.Validate("Shortcut Dimension 1 Code", RequisitionLine."Shortcut Dimension 1 Code");

            if RequisitionLine.projectNo <> '' then
                PurchOrderLine."Job No." := RequisitionLine.projectNo;

            if RequisitionLine."Project Task No" <> '' then
                PurchOrderLine."Job Task No." := RequisitionLine."Project Task No";


        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Purch. Rcpt. Header")
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("No.", Rec."Order No.");
        if PurchHeader.FindFirst() then begin
            Rec.Validate("Delivery Docket No.", PurchHeader."Delivery Docket No.");
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Posted Whse. Receipt Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventpostedwarehouselines(var Rec: Record "Posted Whse. Receipt Line")
    var
        postedwarehouse: Record "Posted Whse. Receipt Header";
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("No.", Rec."Source No.");
        if PurchHeader.FindFirst() then begin
            postedwarehouse.Reset();
            postedwarehouse.SetRange("No.", Rec."No.");
            if postedwarehouse.FindFirst() then begin
                postedwarehouse.Validate("Delivery Docket No.", PurchHeader."Delivery Docket No.");
                postedwarehouse.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventpostedwarehouseputwaylines(var Rec: Record "Warehouse Activity Line")
    var
        wwarehouseactivityheader: Record "Warehouse Activity Header";
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.Reset();
        PurchHeader.SetRange("No.", Rec."Source No.");
        if PurchHeader.FindFirst() then begin
            wwarehouseactivityheader.Reset();
            wwarehouseactivityheader.SetRange("No.", Rec."No.");
            if wwarehouseactivityheader.FindFirst() then begin
                wwarehouseactivityheader.Validate("Delivery Docket No.", PurchHeader."Delivery Docket No.");
                wwarehouseactivityheader.Modify();
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Shipment Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventShipmentLine(var Rec: Record "Sales Shipment Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", Rec."Order No.");
        if SalesHeader.FindFirst() then begin
            Rec.Validate("Delivery Docket No.", SalesHeader."Delivery Docket No.");
            Rec.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Posted Whse. Shipment Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventpostedwarehouseshiplines(var Rec: Record "Posted Whse. Shipment Line")
    var
        postedwarehouseshipment: Record "Posted Whse. Shipment Header";
        salesheader: Record "Sales Header";
    begin
        salesheader.Reset();
        salesheader.SetRange("No.", Rec."Source No.");
        if salesheader.FindFirst() then begin
            postedwarehouseshipment.Reset();
            postedwarehouseshipment.SetRange("No.", Rec."No.");
            if postedwarehouseshipment.FindFirst() then begin
                postedwarehouseshipment.Validate("Delivery Docket No.", salesheader."Delivery Docket No.");
                postedwarehouseshipment.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventpostedwarehousepickslines(var Rec: Record "Warehouse Activity Line")
    var
        wwarehouseactivityheader: Record "Warehouse Activity Header";
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", Rec."Source No.");
        if SalesHeader.FindFirst() then begin
            wwarehouseactivityheader.Reset();
            wwarehouseactivityheader.SetRange("No.", Rec."No.");
            if wwarehouseactivityheader.FindFirst() then begin
                wwarehouseactivityheader.Validate("Delivery Docket No.", SalesHeader."Delivery Docket No.");
                wwarehouseactivityheader.Modify();
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        RequisationLine: Record "Requisition Line";
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Requisition Line":
                begin
                    RecRef.Open(DATABASE::"Requisition Line");
                    if RequisationLine.Get('REQ', 'DEFAULT', DocumentAttachment."Line No.") then
                        RecRef.GetTable(RequisationLine);

                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Requisition Line":
                begin
                    DocumentAttachment.SetRange("Table ID", RecRef.Number);
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Line No.", LineNo);
                    if DocumentAttachment.FindSet() then
                        DocumentAttachment.DeleteAll();
                    FieldRef := RecRef.Field(3);
                    LineNo := FieldRef.Value;
                    FieldRef := RecRef.Field(5);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Table ID", RecRef.Number);
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Line No.", LineNo);
                end;
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Requisition Line":
                begin
                    FieldRef := RecRef.Field(3);
                    LineNo := FieldRef.Value;
                    FieldRef := RecRef.Field(5);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("Table ID", RecRef.Number);
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachment.Validate("Line No.", LineNo);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterPostedWhseRcptLineInsert', '', false, false)]
    local procedure OnAfterInsertPostedWhseReceipt(var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        postedwarehouse: Record "Posted Whse. Receipt Header";
    begin
        postedwarehouse.Reset();
        postedwarehouse.SetRange("No.", PostedWhseReceiptLine."No.");
        if postedwarehouse.FindFirst() then begin
            if PostedWhseReceiptLine."Line No." <= 10000 then
                if Dialog.Confirm('Warehouse Receipt %1 posted successfully.\Do you want to open it?', false, postedwarehouse."No.") then
                    PAGE.Run(PAGE::"Posted Whse. Receipt", postedwarehouse);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterCreatePostedShptHeader', '', false, false)]
    local procedure OnAfterPostWhseShipment(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header")
    begin
        if Dialog.Confirm('Warehouse Shipment %1 posted successfully.\Do you want to open it?', false, PostedWhseShptHeader."No.") then
            PAGE.Run(PAGE::"Posted Whse. Shipment", PostedWhseShptHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertEventputaway(var Rec: Record "Warehouse Activity Header")
    begin
        if Rec.Type = Rec.Type::"Put-away" then
            if Dialog.Confirm('Warehouse Put A way  %1 Created successfully.\Do you want to open it?', false, Rec."No.") then
                PAGE.Run(PAGE::"Warehouse Put-away", Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Header", 'OnAfterInsertEvent', '', true, true)]
    local procedure OnAfterInsertEventPicks(var Rec: Record "Warehouse Activity Header")
    begin
        if Rec.Type = Rec.Type::Pick then
            if Dialog.Confirm('Warehouse Pick %1 Created successfully.\Do you want to open it?', false, Rec."No.") then
                PAGE.Run(PAGE::"Warehouse Pick", Rec);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", "OnAfterGetEmailSubject", '', true, true)]
    local procedure OnAfterGetEmailSubject(var EmailSubject: Text[250]; ReportUsage: Integer; EmailDocumentName: Text[250]; PostedDocNo: Code[20])
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        if Enum::"Report Selection Usage".FromInteger(ReportUsage) = Enum::"Report Selection Usage"::"C.Statement" then
            EmailSubject := StrSubstNo('From %1 - Monthly Statement', CompanyInfo.Name);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', false, false)]
    local procedure OnAfterReleasePurchaseDocument(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    var
        emailmanagement: Codeunit "Email Mngt PO Release";
        EmailPI: Codeunit "Email Mngt PI Release";
    begin
        if PreviewMode then
            exit;
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
            emailmanagement.PORelease(PurchaseHeader);
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            EmailPI.PIRelease(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnBeforePostCommitPurchaseDoc, '', false, false)]
    local procedure OnAfterPostPurchaseDoc2(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean)

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        EmailManagement: Codeunit "Email Mngt Receipt Notify";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        if PreviewMode then
            exit;
        if (PurchaseHeader.receive = true) then begin
            if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
                PurchRcptHeader.Reset();
                PurchRcptHeader.SetRange("Order No.", PurchaseHeader."No.");
                if PurchRcptHeader.FindLast() then
                    EmailManagement.SendReceiptEmail(PurchRcptHeader);
            end;
        end;

        // ✅ Case 2: Invoice posting
        // if (PurchaseHeader.Invoice = true) then begin
        //     if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then begin
        //         PurchInvHeader.Reset();
        //         PurchInvHeader.SetRange("Order No.", PurchaseHeader."No.");
        //         if PurchInvHeader.FindLast() then
        //             EmailManagement.SendInvoiceEmail(PurchInvHeader);
        //     end;
        // end;
    end;


    // [eventsubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeFinalizePosting', '', false, false)]   
    // local procedure OnBeforeFinalizePosting(PurchaseHeader: Record "Purchase Header")
    // var
    //     EmailManagement: Codeunit "Email Mngt Post Purch Receipt";
    //     IsPreview: Boolean; 
    //     itemRec: Record item;
    // begin
    //     // DCS::HP 15092025 ++
    //     IsPreview := DetectPreviewMode();
    //     if IsPreview then
    //         exit;
    //     // DCS::HP 15092025 --
    //     if PurchaseHeader.Receive and not PurchaseHeader.Invoice then begin
    //         EmailManagement.PORelease(PurchaseHeader);
    //     end;
    // end;

    // DCS::HP 11092025 ++
    local procedure DetectPreviewMode(): Boolean
    var
        ErrorMessageMgt: Codeunit "Error Message Management";
    begin
        exit(ErrorMessageMgt.IsActive());
    end;
    // DCS::HP 11092025 --

    // [EventSubscriber(ObjectType::Table, Database::"Purchase Line", OnAfterInsertEvent, '', false, false)]
    // local procedure OnAfterInsertEventPurchase(var Rec: Record "Purchase Line")
    // begin
    //     Rec."Ordered By" := UserId;
    // end;

    // DCS::HP 11092025 ++
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    // local procedure ValidateShortcutDimensionsBeforePosting(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    // var
    //     PurchInvLine: Record "Purchase Line";
    // begin
    //     if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) or (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
    //         if PurchaseHeader."Shortcut Dimension 1 Code" = '' then
    //             Error('Obrien Business unit code on Purchase Header must be filled before posting.');
    //         PurchInvLine.SetRange("Document Type", PurchaseHeader."Document Type");
    //         PurchInvLine.SetRange("Document No.", PurchaseHeader."No.");
    //         if PurchInvLine.FindSet() then
    //             repeat
    //                 if PurchInvLine."Shortcut Dimension 1 Code" = '' then
    //                     Error('Obrien Business unit code on line %1 must be filled before posting.', PurchInvLine."Line No.");
    //             until PurchInvLine.Next() = 0;
    //     end;
    // end;
    // DCS::HP 11092025 --Global Dimension 1 Code"


    // DCS::HP 091025 ++
    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterModifyEvent', '', true, true)]
    local procedure OnAfterVendorBankAccountModify(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    begin
        begin
            SendVendorBankAccountUpdateEmail(Rec);
        end;
    end;

    procedure SendVendorBankAccountUpdateEmail(VendorBankAcc: Record "Vendor Bank Account")
    var
        greeting: Label 'Dear Sir/Madam';
        updateLbl: Label 'The following vendor bank account has been updated:';
        vendorLbl: Label 'Vendor Name : ';
        accountLbl: Label 'Bank Account No. : ';
        updatedByLbl: Label 'Updated by : ';
        regardLbl: Label 'Kind regards,';
        Body, Subject, ToRecipients, CCRecipients : Text;
        EmailMessage: Record "Email Item";
        Vendor: Record Vendor;
        UserSetup: Record "User Setup";
        AggPerSetup: record "Aggregate Permission Set";
        User: Record User;
        UserId: Guid;
        EmailText: Text;
        UserName: Text;
        ReqURL: Text;
        Email: Text;
        AccessControl: Record "Access Control";
        TempEmails: List of [Text];

    begin
        if not Vendor.Get(VendorBankAcc."Vendor No.") then
            Error('Vendor not found.');
        if UserSetup.Get(UserId()) then
            UserName := UserSetup."User Id";
        ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Vendor Bank Account card", VendorBankAcc, true);
        Body := '<p>' + greeting + ' <br><br>' +
                updateLbl + '<br><br>' +
                vendorLbl + Vendor.Name + '<br>' +
                accountLbl + '<a href="' + ReqURL + '">' + VendorBankAcc."Bank Account No." + '</a><br>' +
                updatedByLbl + UserName + '<br><br>' +
                regardLbl + '</p>';
        Subject := 'Vendor Bank Account Updated for ' + Vendor.Name;
        AccessControl.SetFilter("Role ID", 'SUPER|D365 ACC. PAYABLE');
        if AccessControl.FindSet() then
            repeat
                if User.Get(AccessControl."User Security ID") then
                    if User."Authentication Email" <> '' then begin
                        Email := User."Authentication Email";
                        if not TempEmails.Contains(Email) then
                            TempEmails.Add(Email);
                    end;
            until AccessControl.Next() = 0;

        foreach Email in TempEmails do begin
            Clear(EmailMessage);
            EmailMessage."Send to" := Email;
            EmailMessage.Subject := Subject;
            EmailMessage.SetBodyText(Body);
            EmailMessage.Send(true, Enum::"Email Scenario"::Default);
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Res. Jnl.-Post Line", OnAfterPostResJnlLine, '', false, false)]
    local procedure "Res. Jnl.-Post Line_OnAfterPostResJnlLine"(var ResJournalLine: Record "Res. Journal Line"; var ResLedgEntry: Record "Res. Ledger Entry"; var NextEntryNo: Integer)
    var
        GenJnlLine: record "Gen. Journal Line";
        RS: record "Resources Setup";
        RPS: record "Resource Posting";
        lineno: integer;
        GenJnlPostLine: codeunit "Post Gen. Jnl. Line";
    begin
        rs.Get();
        rps.Get();
        GenJnlLine.SetFilter("Journal Template Name", rs.Journal);
        GenJnlLine.SetFilter("Journal Batch Name", rs.Batch);
        if GenJnlLine.Findlast() then begin
            lineno := GenJnlLine."Line No." + 10000;
        end;
        GenJnlLine.Init();
        GenJnlLine."Line No." := lineno;
        GenJnlLine.Validate("Gen. Prod. Posting Group", rps."Gen. Product Posting");
        GenJnlLine.validate("Journal Template Name", rs.Journal);
        GenJnlLine.validate("Journal Batch Name", rs.Batch);
        GenJnlLine.Validate(Quantity, ResJournalLine.Quantity);
        GenJnlLine.validate("Document No.", ResJournalLine."Document No.");
        GenJnlLine.validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.validate("Posting Date", ResJournalLine."Posting Date");
        GenJnlLine.validate(Amount, ResJournalLine."Total Cost");
        GenJnlLine.validate("Account No.", rps."Cost G/L");
        GenJnlLine.Validate("Bal. Account No.", rps."Balance G/L");
        GenJnlLine.Validate("Source Code", ResJournalLine."Source Code");
        GenJnlLine.Validate("Shortcut Dimension 1 Code", ResJournalLine."Shortcut Dimension 1 Code");
        GenJnlLine.Validate("Shortcut Dimension 2 Code", ResJournalLine."Shortcut Dimension 2 Code");

        GenJnlLine.Insert();
        GenJnlPostLine.PostGenJnlLine(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::Contact, OnBeforeCheckIfTypeChangePossibleForPerson, '', false, false)]
    local procedure Contact_OnBeforeCheckIfTypeChangePossibleForPerson(var Contact: Record Contact; xContact: Record Contact; var IsHandled: Boolean)
    begin
        if contact.Type = contact.Type::Person then
            IsHandled := true;
    end;


    //13Oct2025 Pankaj +
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforeSalesInvHeaderInsert, '', false, false)]
    local procedure "Sales-Post_OnBeforeSalesInvHeaderInsert"(var SalesInvHeader: Record "Sales Invoice Header"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; WhseShip: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; InvtPickPutaway: Boolean)
    begin
        SalesHeader.CalcFields("D01 Description");
        if SalesHeader."D01 Description".HasValue() then
            SalesInvHeader."D01 Description" := SalesHeader."D01 Description";
    end;
    //13Oct2025 Pankaj -

    // DCS :: HJ20251028++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", OnBeforeInsertSalesHeader, '', false, false)]
    local procedure "Job Create-Invoice_OnBeforeInsertSalesHeader"(var SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line")
    begin
        SalesHeader."Blanket Sales Order No." := JobPlanningLine."Job No.";
        salesheader."Full Topic" := Job."Full Topic";
    end;
    // DCS :: HJ20251028--

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", OnCreateSalesHeaderOnBeforeCheckBillToCustomerNo, '', false, false)]
    // local procedure "Job Create-Invoice_OnCreateSalesHeaderOnBeforeCheckBillToCustomerNo"(var SalesHeader: Record "Sales Header"; Job: Record Job; JobPlanningLine: Record "Job Planning Line"; var IsHandled: Boolean)
    // begin
    //     SalesHeader.Validate("Shortcut Dimension 1 Code", Job."Global Dimension 1 Code");
    //     SalesHeader.Modify();
    // end;

    // procedure RollbackBlanketOrderFields(InvoiceNo: Code[20])
    // var
    //     BSOInvoiceRec: Record "BSO Invoice Records";
    //     BlanketOrderRec: Record "Sales Header";
    //     SalesInvoiceHeader: Record "Sales Header";
    //     SalesLine: Record "Sales Line";
    //     InvoicePercentage: Decimal;
    //     InvoiceAmount: Decimal;
    //     TotalAmount: Decimal;
    // begin
    //     // Find the invoice record in BSO Invoice Records
    //     BSOInvoiceRec.Reset();
    //     BSOInvoiceRec.SetRange("Invoice No.", InvoiceNo);
    //     if BSOInvoiceRec.FindFirst() then begin
    //         InvoicePercentage := BSOInvoiceRec."Invoiced %";
    //         InvoiceAmount := BSOInvoiceRec.Amount;

    //         // Find the blanket order
    //         if BlanketOrderRec.Get(BlanketOrderRec."Document Type"::"Blanket Order", BSOInvoiceRec."Blanket Order No.") then begin
    //             // Calculate total amount including VAT for the blanket order
    //             TotalAmount := 0;
    //             SalesLine.Reset();
    //             SalesLine.SetRange("Document Type", BlanketOrderRec."Document Type");
    //             SalesLine.SetRange("Document No.", BlanketOrderRec."No.");
    //             if SalesLine.FindSet() then
    //                 repeat
    //                     TotalAmount += SalesLine."Amount Including VAT";
    //                 until SalesLine.Next() = 0;

    //             // Rollback the percentage fields
    //             BlanketOrderRec."Invoiced Percentage" := BlanketOrderRec."Invoiced Percentage" - InvoicePercentage;
    //             BlanketOrderRec."Remaining Percentage" := 100 - BlanketOrderRec."Invoiced Percentage";

    //             // CORRECTED: Rollback the amount fields
    //             BlanketOrderRec."Amount Invoiced" := BlanketOrderRec."Amount Invoiced" - InvoiceAmount;

    //             // Recalculate remaining amount based on total amount
    //             BlanketOrderRec."Remaining Amount" := TotalAmount - BlanketOrderRec."Amount Invoiced";

    //             // Validate that amounts don't go negative
    //             if BlanketOrderRec."Amount Invoiced" < 0 then
    //                 BlanketOrderRec."Amount Invoiced" := 0;

    //             if BlanketOrderRec."Remaining Amount" < 0 then
    //                 BlanketOrderRec."Remaining Amount" := 0;

    //             BlanketOrderRec.Modify(true);

    //             // Also rollback job status if needed
    //             RollbackJobStatus(BlanketOrderRec."No.");
    //         end;

    //         // Delete the BSO invoice record
    //         BSOInvoiceRec.Delete();
    //     end;
    // end;

    // local procedure RollbackJobStatus(BlanketOrderNo: Code[20])
    // var
    //     Job: Record Job;
    // begin
    //     Job.Reset();
    //     Job.SetRange("Sales Order", BlanketOrderNo);
    //     if Job.FindFirst() then begin
    //         Job."Invoice Created" := false;
    //         // Set appropriate system status based on your business logic
    //         if Job."System Status" = Job."System Status"::Invoiced then
    //             Job."System Status" := Job."System Status"::Unscheduled; // or whatever status it should be
    //         Job.Modify();
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    // local procedure OnBeforeSalesHeaderDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    // begin
    //     // Only handle Sales Invoice deletions
    //     if Rec."Document Type" = Rec."Document Type"::Invoice then begin
    //         RollbackBlanketOrderFields(Rec."No.");
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterRenameEvent', '', false, false)]
    // local procedure OnAfterSalesHeaderRename(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    // begin
    //     // Handle if invoice number is changed (renamed)
    //     if Rec."Document Type" = Rec."Document Type"::Invoice then begin
    //         if Rec."No." <> xRec."No." then begin
    //             // Update the BSO Invoice Records with new invoice number
    //             UpdateBSOInvoiceRecord(xRec."No.", Rec."No.");
    //         end;
    //     end;
    // end;

    // local procedure UpdateBSOInvoiceRecord(OldInvoiceNo: Code[20]; NewInvoiceNo: Code[20])
    // var
    //     BSOInvoiceRec: Record "BSO Invoice Records";
    // begin
    //     BSOInvoiceRec.Reset();
    //     BSOInvoiceRec.SetRange("Invoice No.", OldInvoiceNo);
    //     if BSOInvoiceRec.FindFirst() then begin
    //         BSOInvoiceRec."Invoice No." := NewInvoiceNo;
    //         BSOInvoiceRec.Modify();
    //     end;
    // end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure CheckShortcutDimOnSalesInvoice(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then begin
            if SalesHeader."Shortcut Dimension 1 Code" = '' then
                Error('Shortcut Dimension 1 Code must be filled before posting Sales Invoice %1.', SalesHeader."No.");
            if SalesHeader."Blanket Sales Order No." = '' then
                Error('Work Order No. must have a value before posting Sales Invoice %1.', SalesHeader."No.");
        end;
    end;


}