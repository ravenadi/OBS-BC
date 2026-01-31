codeunit 50225 "Email Mngt Receipt Notify"
{
    // procedure SendReceiptEmail(PurchRcptHeader: Record "Purch. Rcpt. Header")
    // var
    //     Body, ItemList, Subject, ToRecipients : Text;
    //     EmailMessage: Record "Email Item";
    //     PurchRcptLine: Record "Purch. Rcpt. Line";
    //     UserSetup: Record "User Setup";
    //     ReqURL: Text;
    //     OrderedBy: Text;
    //     ItemRec: Record Item;
    //     ReceiptURL: Text;
    //     User: Record User;
    // begin
    //     ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Posted Purchase Receipt", PurchRcptHeader, true);

    //     PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
    //     if PurchRcptLine.FindSet() then
    //         repeat
    //             if PurchRcptLine.Type = PurchRcptLine.Type::Item then begin

    //                 if ItemRec.Get(PurchRcptLine."No.") then
    //                     if ItemRec.Type = ItemRec.Type::Inventory then begin
    //                         ReceiptURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Posted Purchase Receipt", PurchRcptHeader, true);
    //                         ItemList += '- <a href="' + ReceiptURL + '">' + PurchRcptLine."No." + '</a> (' + PurchRcptLine.Description + ')<br>';
    //                         if OrderedBy = '' then begin
    //                             if User.Get(PurchRcptLine.SystemCreatedBy) then
    //                                 if UserSetup.Get(User."User Name") then
    //                                     if UserSetup."E-Mail" <> '' then
    //                                         ToRecipients := UserSetup."E-Mail";
    //                         end else
    //                             if UserSetup.Get(OrderedBy) then
    //                                 if UserSetup."E-Mail" <> '' then
    //                                     ToRecipients := UserSetup."E-Mail";
    //                     end;
    //             end;
    //         until PurchRcptLine.Next() = 0;
    //     Body := '<p>Dear ' + OrderedBy + '<br><br>' +
    //             'Your requested inventory items have been successfully received and recorded:<br>' +
    //             ItemList + '<br>' +
    //             'The posted purchase receipt number is <a href="' + ReqURL + '">' + PurchRcptHeader."No." + '</a><br><br>' +
    //             'Kind regards';

    //     Subject := 'Items Received - Purchase Receipt No. ' + PurchRcptHeader."No.";

    //     if UserSetup.Get(OrderedBy) then
    //         ToRecipients := UserSetup."E-Mail";

    //     EmailMessage."Send to" := ToRecipients;
    //     EmailMessage.Subject := Subject;
    //     EmailMessage.SetBodyText(Body);
    //     EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    // end;
    //DCS ::HJ20250311 ++
    // procedure SendReceiptEmail(PurchRcptHeader: Record "Purch. Rcpt. Header")
    // var
    //     greeting: Label 'Dear';
    //     attachmentLbl: Label 'Your requested inventory items have been successfully received and recorded:';
    //     vendNameLbl: Label 'Vendor Name : ';
    //     poNumberLbl: Label 'PO Number : ';
    //     ensureLbl: Label 'The posted purchase receipt number is';
    //     regardLbl: Label 'Kind regards,';
    //     Body, ItemList, Subject, ToRecipients, CCRecipients : Text;
    //     EmailMessage: Record "Email Item";
    //     PurchRcptLine: Record "Purch. Rcpt. Line";
    //     UserSetup: Record "User Setup";
    //     ItemRec: Record Item;
    //     User: Record User;
    //     ReqURL, POReqURL : Text;
    //     PurchHeader: Record "Purchase Header";
    //     OrderedBy: Text;
    // begin
    //     ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Posted Purchase Receipt", PurchRcptHeader, true);
    //     PurchHeader.Reset();
    //     PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
    //     PurchHeader.SetRange("No.", PurchRcptHeader."Order No.");
    //     if PurchHeader.FindFirst() then
    //         POReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Order", PurchHeader, true);
    //     PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
    //     if PurchRcptLine.FindSet() then
    //         repeat
    //             if PurchRcptLine.Type = PurchRcptLine.Type::Item then
    //                 if ItemRec.Get(PurchRcptLine."No.") then
    //                     if ItemRec.Type = ItemRec.Type::Inventory then begin
    //                         ItemList += '- <a href="' + ReqURL + '">' + PurchRcptLine."No." + '</a> <br>';
    //                         if OrderedBy = '' then
    //                             OrderedBy := PurchRcptLine."Ordered By";
    //                     end;
    //         until PurchRcptLine.Next() = 0;

    //     if ItemList = '' then
    //         exit;

    //     Body := '<p>' + greeting + ' ' + OrderedBy + '<br><br>' +
    //             attachmentLbl + '<br>' + ItemList + '<br>' +
    //             ensureLbl + ' <a href="' + ReqURL + '">' + PurchRcptHeader."No." + '</a><br><br>' +
    //             regardLbl;

    //     Subject := 'Items Received - Purchase Receipt No. ' + PurchRcptHeader."No.";

    //     if OrderedBy = '' then begin
    //         if User.Get(PurchRcptLine.SystemCreatedBy) then
    //             if UserSetup.Get(User."User Name") then
    //                 if UserSetup."E-Mail" <> '' then
    //                     ToRecipients := UserSetup."E-Mail";
    //     end else
    //         if UserSetup.Get(OrderedBy) then
    //             if UserSetup."E-Mail" <> '' then
    //                 ToRecipients := UserSetup."E-Mail";

    //     EmailMessage."Send to" := ToRecipients;
    //     EmailMessage."Send CC" := CCRecipients;
    //     EmailMessage.Subject := Subject;
    //     EmailMessage.SetBodyText(Body);
    //     EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    // end;
    //DCS ::HJ20250311 -- 
    //DCS ::HJ20250311 ++

    procedure SendReceiptEmail(PurchRcptHeader: Record "Purch. Rcpt. Header")
    var
        greeting: Label 'Dear';
        attachmentLbl: Label 'Your requested inventory items have been successfully received and recorded:';
        vendNameLbl: Label 'Vendor Name : ';
        poNumberLbl: Label 'PO Number : ';
        invoiceNumberLbl: Label 'Purchase Invoice No. : ';
        ensureLbl: Label 'The posted purchase receipt number is';
        regardLbl: Label 'Kind regards,';
        Body: Text;
        ItemList: Text;
        Email: Codeunit Email;
        EmailMessage: Record "Email Item";
        Subject: Text;
        ToRecipients: Text[250];
        CCRecipients: Text[250];
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        RecRef: RecordRef;
        User: Record User;
        TempBlob: Codeunit "Temp Blob";
        mailmngt: Codeunit "Mail Management";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcptLineRec: Record "Purch. Rcpt. Line";
        PurchHeader: Record "Purchase Header";
        PurchInvline: Record "Purch. Inv. Line";
        ItemRec: Record Item;
        ReqURL: Text;
        POReqURL: Text;
        OrderedBy: Text;
        OrderedByname: Text;
        employeeRec: Record Employee;
        xOrderBy: Text;
    // PurchInvoiceNo: Code[20];
    begin
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        if PurchRcptLine.FindFirst() then begin
            if GLSetup.Get() then;
            EmailMessage.SendAsHTML(true);

            ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Posted Purchase Receipt", PurchRcptHeader, true);

            PurchHeader.Reset();
            PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
            PurchHeader.SetRange("No.", PurchRcptHeader."Order No.");
            if PurchHeader.FindFirst() then
                POReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Order", PurchHeader, true);

            // Find related Purchase Invoice
            // PurchInvline.Reset();
            // // PurchInvline.SetRange("Order No.", PurchRcptHeader."Order No.");
            // PurchInvline.SetRange("Receipt No.", PurchRcptLineRec."Document No.");
            // PurchInvline.SetRange("Receipt Line No.", PurchRcptLineRec."Line No.");
            // if PurchInvline.FindFirst() then
            //     PurchInvoiceNo := PurchInvline."Document No.";

            PurchRcptLine.Reset();
            PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
            PurchRcptLine.SetCurrentKey("Ordered By");
            if PurchRcptLine.FindSet() then
                repeat
                    OrderedBy := '';
                    ItemList := '';
                    ToRecipients := '';
                    if xOrderBy <> PurchRcptLine."Ordered By" then begin
                        xOrderBy := PurchRcptLine."Ordered By";

                        PurchRcptLineRec.Reset();
                        PurchRcptLineRec.SetRange("Document No.", PurchRcptHeader."No.");
                        PurchRcptLineRec.SetRange("Ordered By", PurchRcptLine."Ordered By");
                        if PurchRcptLineRec.FindSet() then
                            repeat
                                if PurchRcptLineRec.Type = PurchRcptLineRec.Type::Item then
                                    if ItemRec.Get(PurchRcptLineRec."No.") then
                                        if ItemRec.Type = ItemRec.Type::Inventory then begin
                                            ItemList += 'Item No- <a href="' + ReqURL + '">' + PurchRcptLineRec."No." + '</a>' + ' Description :- ' + PurchRcptLineRec.Description;
                                            OrderedByname := purchRcptLineRec."Name Ordered By";
                                            if OrderedBy = '' then
                                                OrderedBy := PurchRcptLineRec."Ordered By";
                                        end;
                            until PurchRcptLineRec.Next() = 0;

                        if ItemList = '' then
                            continue;

                        Body := '<p>' + greeting + ' ' + OrderedByname + '<br><br>' +
                                attachmentLbl + '<br>' + ItemList + '<br>' +
                                poNumberLbl + PurchHeader."No." + '<br>' +
                                // invoiceNumberLbl + PurchInvoiceNo + '<br>' +
                                ensureLbl + ' <a href="' + ReqURL + '">' + PurchRcptHeader."No." + '</a><br><br>' +
                                regardLbl;

                        Subject := 'Items Received - Purchase Receipt No. ' + PurchRcptHeader."No.";

                        if OrderedBy = '' then begin
                            if User.Get(PurchRcptLineRec.SystemCreatedBy) then
                                if UserSetup.Get(User."User Name") then
                                    if UserSetup."E-Mail" <> '' then
                                        ToRecipients := UserSetup."E-Mail"
                        end else begin
                            if UserSetup.Get(OrderedBy) then begin
                                if UserSetup."E-Mail" <> '' then
                                    ToRecipients := UserSetup."E-Mail"
                            end else
                                if employeeRec.Get(PurchRcptLine."Ordered By") then begin
                                    if employeeRec."Company E-Mail" <> '' then
                                        ToRecipients := employeeRec."Company E-Mail";
                                end else
                                    Message('No employee found for Ordered By = %1', PurchRcptLine."Ordered By");
                        end;

                        RecRef.GetTable(PurchRcptHeader);
                        EmailMessage."Send to" := ToRecipients;
                        EmailMessage."Send CC" := CCRecipients;
                        EmailMessage.Subject := Subject;
                        EmailMessage.SetBodyText(Body);
                        EmailMessage.Send(true, Enum::"Email Scenario"::Default);
                    end;
                until PurchRcptLine.Next() = 0;
        end;
    end;
    //DCS ::HJ20250311 --

    // procedure SendInvoiceEmail(PurchInvHeader: Record "Purch. Inv. Header")
    // var
    //     greeting: Label 'Dear';
    //     attachmentLbl: Label 'Your requested inventory items have been successfully invoiced:';
    //     poNumberLbl: Label 'PO Number : ';
    //     invoiceNumberLbl: Label 'Purchase Invoice No. : ';
    //     regardLbl: Label 'Kind regards,';
    //     Body: Text;
    //     EmailMessage: Record "Email Item";
    //     Subject: Text;
    //     ToRecipients: Text[250];
    //     CCRecipients: Text[250];
    //     UserSetup: Record "User Setup";
    //     PurchInvLine: Record "Purch. Inv. Line";
    //     ItemRec: Record Item;
    //     ReqURL: Text;
    //     OrderedBy: Text;
    //     OrderedByName: Text;
    //     GLSetup: Record "General Ledger Setup";
    //     PurchHeader: Record "Purchase Header";
    //     PurchHeader1: Record "Purchase Header";
    //     PurchLine: Record "Purchase Line";
    //     POReqURL: Text;
    // begin
    //     PurchInvLine.Reset();
    //     PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
    //     if PurchInvLine.FindSet() then begin
    //         if GLSetup.Get() then;
    //         EmailMessage.SendAsHTML(true);

    //         ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Posted Purchase Invoice", PurchInvHeader, true);

    //         PurchHeader.Reset();
    //         PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
    //         PurchHeader.SetRange("No.", PurchInvHeader."Order No.");
    //         if PurchHeader.FindFirst() then
    //             POReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Order", PurchHeader, true);

    //         PurchLine.Reset();
    //         PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
    //         PurchLine.SetRange("No.", PurchHeader1."Document No.");
    //         // PurchHeader1.Reset();
    //         // PurchHeader1.SetRange("Document Type", PurchHeader1."Document Type"::Order);
    //         // PurchHeader1.SetRange("No.", PurchLine."Document No.");
    //         if PurchHeader1.FindFirst() then begin
    //             OrderedBy := PurchLine."Ordered By";
    //             OrderedByName := PurchLine."Name Ordered By";
    //         end;

    //         repeat
    //             if PurchInvLine.Type = PurchInvLine.Type::Item then
    //                 if ItemRec.Get(PurchInvLine."No.") then
    //                     if ItemRec.Type = ItemRec.Type::Inventory then begin

    //                         Body := '<p>' + greeting + ' ' + OrderedByName + '<br><br>' +
    //                                 attachmentLbl + '<br>' +
    //                                 poNumberLbl + PurchInvHeader."Order No." + '<br>' +
    //                                 invoiceNumberLbl + PurchInvHeader."No." + '<br>' +
    //                                 'Invoice link: <a href="' + ReqURL + '">' + PurchInvHeader."No." + '</a><br><br>' +
    //                                 regardLbl;

    //                         Subject := 'Purchase Invoice Posted - Invoice No. ' + PurchInvHeader."No.";

    //                         if UserSetup.Get(OrderedBy) then
    //                             ToRecipients := UserSetup."E-Mail";

    //                         EmailMessage."Send to" := ToRecipients;
    //                         EmailMessage."Send CC" := CCRecipients;
    //                         EmailMessage.Subject := Subject;
    //                         EmailMessage.SetBodyText(Body);
    //                         EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    //                     end;
    //         until PurchInvLine.Next() = 0;
    //     end;
    // end;

}