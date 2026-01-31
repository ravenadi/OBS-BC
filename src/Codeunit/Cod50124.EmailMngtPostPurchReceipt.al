codeunit 50124 "Email Mngt Post Purch Receipt"
{
    // procedure PORelease(Var Rec: Record "Purch. Rcpt. Line")
    // var
    //     greeting: Label 'Dear';
    //     attachmentLbl: Label 'Your requested item ';
    //     attachmentLbl2: Label ' has been successfully received and recorded.';
    //     vendName: Label 'Vendor Name : ';
    //     POBNumb: Label 'PO Number : ';
    //     EnsureLbl: Label 'The posted purchase receipt number is';
    //     regard: Label 'Kind regards,';
    //     Body: text;
    //     Email: Codeunit Email;
    //     EmailMessage: Record "Email Item";
    //     Subject: Text;
    //     ToRecipients: Text[250];
    //     CCRecepients: Text[250];
    //     UserSetup: Record "User Setup";
    //     DimensionValues: Record "Dimension Value";
    //     GLSetup: Record "General Ledger Setup";
    //     Outstr: OutStream;
    //     Instr: InStream;
    //     RecRef: RecordRef;
    //     User: Record User;
    //     TempBlob: Codeunit "Temp Blob";
    //     mailmngt: Codeunit "Mail Management";
    //     PurchaseReeiptHeader: Record "Purch. Rcpt. Header";
    //     ReqURL: Text;
    //     SequenceNoMgt: Codeunit "Sequence No. Mgt.";
    //     purchHeader: Record "Purchase Header";
    //     POReqURL: Text;
    // begin
    //     PurchaseReeiptHeader.Reset();
    //     PurchaseReeiptHeader.SetRange("No.", Rec."Document No.");
    //     if PurchaseReeiptHeader.FindFirst() then;
    //     if GLSetup.Get() then;
    //     EmailMessage.SendAsHTML(true);
    //     ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, page::"Posted Purchase Receipt", PurchaseReeiptHeader, true);
    //     // DCS::HP 16092025 ++
    //     purchHeader.Reset();
    //     purchHeader.SetRange("Document Type", purchHeader."Document Type"::Order);
    //     purchHeader.SetRange("No.", Rec."Order No.");
    //     if purchHeader.FindFirst() then
    //         POReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, page::"Purchase Order", purchHeader, true);
    //     Body := '<p>' + greeting + '' + Rec."Ordered By" + '<br>' + '<br>' + attachmentLbl + '<a href="' + POReqURL + '">' + Rec."No." + '</a>' + attachmentLbl2 + '<br>' + '<br>' + EnsureLbl + '' + '<a href="' + ReqURL + '">' + PurchaseReeiptHeader."No." + '</a>' + '<br>' + '<br>' + regard; //SN 09-May-2023 Space Added
    //     // DCS::HP 16092025 --
    //     Subject := ' Items Received - Purchase Receipt No. - ' + Rec."No.";

    //     If Rec."Ordered By" = '' then begin
    //         if User.Get(Rec.SystemCreatedBy) then
    //             if UserSetup.get(User."User Name") then
    //                 if UserSetup."E-Mail" <> '' then
    //                     if ToRecipients = '' then
    //                         ToRecipients := UserSetup."E-Mail"
    //                     else
    //                         ToRecipients += ';' + UserSetup."E-Mail";
    //     end
    //     else
    //         if UserSetup.get(Rec."Ordered By") then
    //             if UserSetup."E-Mail" <> '' then
    //                 if ToRecipients = '' then
    //                     ToRecipients := UserSetup."E-Mail"
    //                 else
    //                     ToRecipients += ';' + UserSetup."E-Mail";

    //     RecRef.GetTable(Rec);
    //     // if ToRecipients.Count <> 0 then begin
    //     EmailMessage."Send to" := ToRecipients;
    //     EmailMessage."Send CC" := CCRecepients;
    //     EmailMessage.Subject := Subject;
    //     EmailMessage.SetBodyText(Body);
    //     // mailmngt.Send(EmailMessage, Enum::"Email Scenario"::Default);
    //     EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    // end;

    procedure PORelease(var Rec: Record "Purch. Rcpt. Line")
    var
        greeting: Label 'Dear';
        attachmentLbl: Label 'Your requested inventory items have been successfully received and recorded:';
        vendName: Label 'Vendor Name : ';
        POBNumb: Label 'PO Number : ';
        EnsureLbl: Label 'The posted purchase receipt number is';
        regard: Label 'Kind regards,';
        Body: Text;
        ItemList: Text;
        Email: Codeunit Email;
        EmailMessage: Record "Email Item";
        Subject: Text;
        ToRecipients: Text[250];
        CCRecepients: Text[250];
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        RecRef: RecordRef;
        User: Record User;
        TempBlob: Codeunit "Temp Blob";
        mailmngt: Codeunit "Mail Management";
        PurchaseReeiptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemRec: Record Item;
        ReqURL: Text;
        POReqURL: Text;
        purchHeader: Record "Purchase Header";
        OrderedBy: Text;
    begin
        PurchaseReeiptHeader.Reset();
        PurchaseReeiptHeader.SetRange("No.", Rec."Document No.");
        if not PurchaseReeiptHeader.FindFirst() then
            exit;

        if GLSetup.Get() then;
        EmailMessage.SendAsHTML(true);

        ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Posted Purchase Receipt", PurchaseReeiptHeader, true);

        purchHeader.Reset();
        purchHeader.SetRange("Document Type", purchHeader."Document Type"::Order);
        purchHeader.SetRange("No.", Rec."Order No.");
        if purchHeader.FindFirst() then
            POReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Order", purchHeader, true);

        // Loop through all lines in the receipt
        PurchRcptLine.Reset();
        PurchRcptLine.SetRange("Document No.", Rec."Document No.");
        if PurchRcptLine.FindSet() then
            repeat
                if PurchRcptLine.Type = PurchRcptLine.Type::Item then
                    if ItemRec.Get(PurchRcptLine."No.") then
                        if ItemRec.Type = ItemRec.Type::Inventory then begin
                            ItemList += '- ' + PurchRcptLine."No." + ' (' + PurchRcptLine.Description + ')<br>';
                            if OrderedBy = '' then
                                OrderedBy := PurchRcptLine."Ordered By";
                        end;
            until PurchRcptLine.Next() = 0;

        if ItemList = '' then
            exit; // No inventory items to send

        Body := '<p>' + greeting + ' ' + OrderedBy + '<br><br>' +
                attachmentLbl + '<br>' + ItemList + '<br>' +
                EnsureLbl + ' <a href="' + ReqURL + '">' + PurchaseReeiptHeader."No." + '</a><br><br>' +
                regard;

        Subject := 'Items Received - Purchase Receipt No. ' + PurchaseReeiptHeader."No.";

        if OrderedBy = '' then begin
            if User.Get(Rec.SystemCreatedBy) then
                if UserSetup.Get(User."User Name") then
                    if UserSetup."E-Mail" <> '' then
                        ToRecipients := UserSetup."E-Mail";
        end else
            if UserSetup.Get(OrderedBy) then
                if UserSetup."E-Mail" <> '' then
                    ToRecipients := UserSetup."E-Mail";

        EmailMessage."Send to" := ToRecipients;
        EmailMessage."Send CC" := CCRecepients;
        EmailMessage.Subject := Subject;
        EmailMessage.SetBodyText(Body);
        EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    end;
}