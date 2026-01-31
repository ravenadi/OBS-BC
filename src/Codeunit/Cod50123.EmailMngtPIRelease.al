// codeunit 50123 "Email Mngt PI Release"
// {
//     procedure PIRelease(Rec: Record "Purchase Header")
//     var
//         greeting: Label 'Dear';
//         attachmentLbl: Label 'Your purchase invoice for Item No.';
//         vendName: Label 'Vendor Name : ';
//         POBNumb: Label 'PO Number : ';
//         EnsureLbl: Label 'Please ensure any related invoice(s) quote the PO number above.';
//         regard: Label 'Kind regards,';
//         Body: text;
//         Email: Codeunit Email;
//         EmailMessage: Record "Email Item";
//         Subject: Text;
//         ToRecipients: Text[250];
//         CCRecepients: Text[250];
//         UserSetup: Record "User Setup";
//         DimensionValues: Record "Dimension Value";
//         GLSetup: Record "General Ledger Setup";
//         Outstr: OutStream;
//         Instr: InStream;
//         RecRef: RecordRef;
//         User: Record User;
//         TempBlob: Codeunit "Temp Blob";
//         mailmngt: Codeunit "Mail Management";
//         PurchaseHeader: Record "Purchase Header";
//         PurchaseLine: Record "Purchase Line";
//         ReqURL: Text;
//     begin
//         PurchaseHeader.Reset();
//         PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Invoice);
//         PurchaseHeader.SetRange("No.", Rec."No.");
//         if PurchaseHeader.FindFirst() then begin
//             PurchaseLine.Reset();
//             PurchaseLine.SetRange("Document Type", Rec."Document Type"::Invoice);
//             PurchaseLine.SetRange("Document No.", Rec."No.");
//             if PurchaseLine.FindSet() then
//                 repeat
//                     if GLSetup.Get() then;
//                     EmailMessage.SendAsHTML(true);
//                     ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, page::"Purchase Invoice", PurchaseHeader, true);
//                     Body := '<p>' + greeting + '' + PurchaseLine."Ordered By" + '<br>' + '<br>' + attachmentLbl + '' + '<a href="' + ReqURL + '">' + PurchaseLine."No." + '</a>' + ' ' + 'has been approved.' + '<br>' + '<br>' + 'You will be notified once the procurement process is completed or if any further information is required.' + '<br>' + '<br>' + regard; //SN 09-May-2023 Space Added
//                     Subject := 'Purchase Invoice Approved - ' + PurchaseLine."No.";

//                     If PurchaseLine."Ordered By" = '' then begin
//                         if User.Get(Rec.SystemCreatedBy) then
//                             if UserSetup.get(User."User Name") then
//                                 if UserSetup."E-Mail" <> '' then
//                                     if ToRecipients = '' then
//                                         ToRecipients := UserSetup."E-Mail"
//                                     else
//                                         ToRecipients += ';' + UserSetup."E-Mail";
//                     end
//                     else
//                         if UserSetup.get(PurchaseLine."Ordered By") then
//                             if UserSetup."E-Mail" <> '' then
//                                 if ToRecipients = '' then
//                                     ToRecipients := UserSetup."E-Mail"
//                                 else
//                                     ToRecipients += ';' + UserSetup."E-Mail";

//                     RecRef.GetTable(PurchaseHeader);
//                     // if ToRecipients.Count <> 0 then begin

//                     EmailMessage."Send to" := ToRecipients;
//                     EmailMessage."Send CC" := CCRecepients;
//                     EmailMessage.Subject := Subject;
//                     EmailMessage.SetBodyText(Body);
//                     // mailmngt.Send(EmailMessage, Enum::"Email Scenario"::Default);
//                     EmailMessage.Send(true, Enum::"Email Scenario"::Default);
//                 // end;
//                 until PurchaseLine.Next() = 0;
//         end;
//     end;


// }



codeunit 50123 "Email Mngt PI Release"
{
    // DCS: HJ20250311++
    // procedure PIRelease(Rec: Record "Purchase Header")
    // var
    //     greeting: Label 'Dear';
    //     attachmentLbl: Label 'Your purchase invoice for the following items has been approved:';
    //     vendName: Label 'Vendor Name : ';
    //     POBNumb: Label 'PO Number : ';
    //     EnsureLbl: Label 'Please ensure any related invoice(s) quote the PO number above.';
    //     regard: Label 'Kind regards,';
    //     Body: Text;
    //     ItemList: Text;
    //     Email: Codeunit Email;
    //     EmailMessage: Record "Email Item";
    //     Subject: Text;
    //     ToRecipients: Text[250];
    //     CCRecepients: Text[250];
    //     UserSetup: Record "User Setup";
    //     GLSetup: Record "General Ledger Setup";
    //     RecRef: RecordRef;
    //     User: Record User;
    //     TempBlob: Codeunit "Temp Blob";
    //     mailmngt: Codeunit "Mail Management";
    //     PurchaseHeader: Record "Purchase Header";
    //     PurchaseLine: Record "Purchase Line";
    //     ReqURL: Text;
    //     OrderedBy: Text;
    // begin
    //     PurchaseHeader.Reset();
    //     PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Invoice);
    //     PurchaseHeader.SetRange("No.", Rec."No.");
    //     if PurchaseHeader.FindFirst() then begin
    //         if GLSetup.Get() then;
    //         EmailMessage.SendAsHTML(true);
    //         ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Invoice", PurchaseHeader, true);

    //         PurchaseLine.Reset();
    //         PurchaseLine.SetRange("Document Type", Rec."Document Type"::Invoice);
    //         PurchaseLine.SetRange("Document No.", Rec."No.");
    //         if PurchaseLine.FindSet() then
    //             repeat
    //                 if PurchaseLine.Type = PurchaseLine.Type::Item then begin
    //                     ItemList += '- <a href="' + ReqURL + '">' + PurchaseLine."No." + '</a><br>';
    //                     if OrderedBy = '' then
    //                         OrderedBy := PurchaseLine."Ordered By";
    //                 end;
    //             until PurchaseLine.Next() = 0;

    //         Body := '<p>' + greeting + ' ' + OrderedBy + '<br><br>' +
    //                 attachmentLbl + '<br>' + ItemList + '<br>' +
    //                 EnsureLbl + '<br><br>' +
    //                 regard;

    //         Subject := 'Purchase Invoice Approved - Invoice No. ' + Rec."No.";

    //         if OrderedBy = '' then begin
    //             if User.Get(Rec.SystemCreatedBy) then
    //                 if UserSetup.Get(User."User Name") then
    //                     if UserSetup."E-Mail" <> '' then
    //                         ToRecipients := UserSetup."E-Mail";
    //         end else
    //             if UserSetup.Get(OrderedBy) then
    //                 if UserSetup."E-Mail" <> '' then
    //                     ToRecipients := UserSetup."E-Mail";

    //         RecRef.GetTable(PurchaseHeader);
    //         EmailMessage."Send to" := ToRecipients;
    //         EmailMessage."Send CC" := CCRecepients;
    //         EmailMessage.Subject := Subject;
    //         EmailMessage.SetBodyText(Body);
    //         EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    //     end;
    // end;
    procedure PIRelease(Rec: Record "Purchase Header")
    var
        greeting: Label 'Dear';
        PINoLbl: Label 'Purchase Invoice No :- ';
        VndNoLbl: label 'Vendor Invoice No :- ';
        VndNameLbl: label 'Vendor Name :- ';
        OBULbl: label 'Obrien Business Unit Code :- ';
        AmountLbl: label 'Total Amount :- ';
        attachmentLbl: Label 'Your purchase invoice for the following items has been approved:';
        vendName: Label 'Vendor Name : ';
        POBNumb: Label 'PO Number : ';
        EnsureLbl: Label 'Please ensure any related invoice(s) quote the PO number above.';
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
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine2: Record "Purchase Line";
        ReqURL: Text;
        OrderedBy: Text;
        xOrderBy: Text;
        employeeRec: Record Employee;
        TotalAmountIncVAT: Decimal;
        TotalPurchaseLine: Record "Purchase Line";
    begin
        // Calculate total amount including VAT for the invoice
        TotalAmountIncVAT := 0;
        TotalPurchaseLine.Reset();
        TotalPurchaseLine.SetRange("Document Type", Rec."Document Type"::Invoice);
        TotalPurchaseLine.SetRange("Document No.", Rec."No.");
        TotalPurchaseLine.SetFilter(Type, '<>%1', TotalPurchaseLine.Type::" ");

        // if TotalPurchaseLine.Findfirst() then begin
        //     TotalAmountIncVAT := TotalPurchaseLine."Amount Including VAT";
        // end;
        if TotalPurchaseLine.FindSet() then
            repeat
                TotalAmountIncVAT += TotalPurchaseLine."Amount Including VAT";
            until TotalPurchaseLine.Next() = 0;
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Invoice);
        PurchaseHeader.SetRange("No.", Rec."No.");
        if PurchaseHeader.FindFirst() then begin
            if GLSetup.Get() then;
            EmailMessage.SendAsHTML(true);
            ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Invoice", PurchaseHeader, true);

            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", Rec."Document Type"::Invoice);
            PurchaseLine.SetRange("Document No.", Rec."No.");
            PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
            PurchaseLine.SetCurrentKey("Ordered By");
            if PurchaseLine.FindSet() then
                repeat
                    OrderedBy := '';
                    ItemList := '';
                    ToRecipients := '';
                    if xOrderBy <> PurchaseLine."Ordered By" then begin
                        xOrderBy := PurchaseLine."Ordered By";

                        PurchaseLine2.Reset();
                        PurchaseLine2.SetRange("Document Type", Rec."Document Type"::Invoice);
                        PurchaseLine2.SetRange("Document No.", Rec."No.");
                        PurchaseLine2.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");
                        PurchaseLine2.SetRange("Ordered By", PurchaseLine."Ordered By");
                        if PurchaseLine2.FindSet() then
                            repeat
                                if PurchaseLine2.Type = PurchaseLine2.Type::Item then begin
                                    ItemList += 'Item No- <a href="' + ReqURL + '">' + PurchaseLine2."No." + '</a>' + ' Description :- ' + PurchaseLine2.Description + '<br>';
                                    if OrderedBy = '' then
                                        OrderedBy := PurchaseLine2."Name Ordered By";
                                end;
                            until PurchaseLine2.Next() = 0;


                        Body := '<p>' + greeting + ' ' + OrderedBy + '<br><br>' +
                                attachmentLbl + '<br><br>' + ItemList + '<br>' +
                                // PINoLbl + PurchaseHeader."No." + '<br>' +
                                PINoLbl + '<a href="' + ReqURL + '">' + PurchaseHeader."No." + '</a><br>' +
                                VndNameLbl + PurchaseHeader."Buy-from Vendor Name" + '<br>' +
                                VndNoLbl + PurchaseHeader."Vendor Invoice No." + '<br>' +
                                OBULbl + PurchaseHeader."Shortcut Dimension 1 Code" + '<br>' +
                                AmountLbl + Format(TotalAmountIncVAT) + '<br><br>' +
                                EnsureLbl + '<br><br>' +
                                regard;

                        Subject := 'Purchase Invoice Approved - Invoice No. ' + Rec."No.";

                        if OrderedBy = '' then begin
                            if User.Get(Rec.SystemCreatedBy) then
                                if UserSetup.Get(User."User Name") then
                                    if UserSetup."E-Mail" <> '' then
                                        ToRecipients := UserSetup."E-Mail"
                        end else begin
                            if UserSetup.Get(OrderedBy) then begin
                                if UserSetup."E-Mail" <> '' then
                                    ToRecipients := UserSetup."E-Mail"
                            end else
                                if employeeRec.get(PurchaseLine2."Ordered By") then begin
                                    if employeeRec."Company E-Mail" <> '' then
                                        ToRecipients := employeeRec."Company E-Mail";
                                end else
                                    Message('No employee found for Ordered By = %1', PurchaseLine2."Ordered By");
                        end;

                        RecRef.GetTable(PurchaseHeader);
                        EmailMessage."Send to" := ToRecipients;
                        EmailMessage."Send CC" := CCRecepients;
                        EmailMessage.Subject := Subject;
                        EmailMessage.SetBodyText(Body);
                        EmailMessage.Send(true, Enum::"Email Scenario"::Default);
                    end;
                until PurchaseLine.Next() = 0;
        end;
    end;

    // DCS: HJ20250311--


}
