// codeunit 50121 "Email Mngt PO Release"
// {
//     procedure PORelease(Rec: Record "Purchase Header")
//     var
//         greeting: Label 'Dear';
//         attachmentLbl: Label 'Your purchase request for Item No.';
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
//         PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
//         PurchaseHeader.SetRange("No.", Rec."No.");
//         if PurchaseHeader.FindFirst() then begin
//             PurchaseLine.Reset();
//             PurchaseLine.SetRange("Document Type", Rec."Document Type"::Order);
//             PurchaseLine.SetRange("Document No.", Rec."No.");
//             if PurchaseLine.FindSet() then
//                 repeat
//                     if GLSetup.Get() then;
//                     EmailMessage.SendAsHTML(true);
//                     ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, page::"Purchase Order", PurchaseHeader, true);
//                     Body := '<p>' + greeting + '' + PurchaseLine."Ordered By" + '<br>' + '<br>' + attachmentLbl + '' + '<a href="' + ReqURL + '">' + PurchaseLine."No." + '</a>' + ' ' + 'has been approved.' + '<br>' + '<br>' + 'You will be notified once the procurement process is completed or if any further information is required.' + '<br>' + '<br>' + regard; //SN 09-May-2023 Space Added
//                     Subject := 'Purchase Request Approved - ' + PurchaseLine."No.";

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


codeunit 50121 "Email Mngt PO Release"
{
    // procedure PORelease(Rec: Record "Purchase Header")
    // var
    //     greeting: Label 'Dear';
    //     attachmentLbl: Label 'Your purchase request for the following items has been approved:';
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
    //     employeeRec: Record Employee;
    // begin
    //     PurchaseHeader.Reset();
    //     PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
    //     PurchaseHeader.SetRange("No.", Rec."No.");
    //     if PurchaseHeader.FindFirst() then begin
    //         if GLSetup.Get() then;
    //         EmailMessage.SendAsHTML(true);
    //         ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Order", PurchaseHeader, true);

    //         PurchaseLine.Reset();
    //         PurchaseLine.SetRange("Document Type", Rec."Document Type"::Order);
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

    //         Subject := 'Purchase Request Approved - PO No. ' + Rec."No.";

    //         if OrderedBy = '' then begin
    //             if User.Get(Rec.SystemCreatedBy) then
    //                 if UserSetup.Get(User."User Name") then
    //                     if UserSetup."E-Mail" <> '' then
    //                         ToRecipients := UserSetup."E-Mail"
    //         end else begin
    //             if UserSetup.Get(OrderedBy) then begin
    //                 if UserSetup."E-Mail" <> '' then
    //                     ToRecipients := UserSetup."E-Mail"
    //             end else
    //                 // if employeeRec.Get(OrderedBy) then 
    //                 //     if employeeRec."Company E-Mail" <> '' then
    //                 //         ToRecipients := employeeRec."Company E-Mail";
    //                 if employeeRec.get(Rec."Ordered By") then begin
    //                     if employeeRec."Company E-Mail" <> '' then
    //                         ToRecipients := employeeRec."Company E-Mail";
    //                 end else
    //                     Message('No employee found for Ordered By = %1', Rec."Ordered By");
    //         end;

    //     end;
    //     RecRef.GetTable(PurchaseHeader);
    //     EmailMessage."Send to" := ToRecipients;
    //     EmailMessage."Send CC" := CCRecepients;
    //     EmailMessage.Subject := Subject;
    //     EmailMessage.SetBodyText(Body);
    //     EmailMessage.Send(true, Enum::"Email Scenario"::Default);
    // end;

    //DCS :: YK20250311++
    procedure PORelease(Rec: Record "Purchase Header")
    var
        greeting: Label 'Dear';
        attachmentLbl: Label 'Your purchase request for the following items has been approved:';
        vendName: Label 'Vendor Name : ';
        PONumb: Label 'PO Number : ';
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
        PurchaseLineRec: Record "Purchase Line";
        ReqURL: Text;
        OrderedBy: Text;
        employeeRec: Record Employee;
        xOrderBy: Text;
        VndNameLbl: label 'Vendor Name :- ';
        OBULbl: label 'Obrien Business Unit Code :- ';
        AmountLbl: label 'Total Amount :- ';
        TotalAmountIncVAT: Decimal;
        TotalPurchaseLine: Record "Purchase Line";
    begin
        // Calculate total amount including VAT for the order
        TotalAmountIncVAT := 0;
        TotalPurchaseLine.Reset();
        TotalPurchaseLine.SetRange("Document Type", Rec."Document Type"::Order);
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
        PurchaseHeader.SetRange("Document Type", Rec."Document Type"::Order);
        PurchaseHeader.SetRange("No.", Rec."No.");
        if PurchaseHeader.FindFirst() then begin
            if GLSetup.Get() then;
            EmailMessage.SendAsHTML(true);
            ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Purchase Order", PurchaseHeader, true);
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", Rec."Document Type"::Order);
            PurchaseLine.SetRange("Document No.", Rec."No.");
            PurchaseLine.SetCurrentKey("Ordered By");
            if PurchaseLine.FindSet() then
                repeat
                    OrderedBy := '';
                    ItemList := '';
                    ToRecipients := '';
                    if xOrderBy <> PurchaseLine."Ordered By" then begin
                        xOrderBy := PurchaseLine."Ordered By";


                        PurchaseLineRec.Reset();
                        PurchaseLineRec.SetRange("Document Type", Rec."Document Type"::Order);
                        PurchaseLineRec.SetRange("Document No.", Rec."No.");
                        PurchaseLineRec.SetRange("Ordered By", PurchaseLine."Ordered By");
                        if PurchaseLineRec.FindSet() then
                            repeat
                                if PurchaseLineRec.Type = PurchaseLineRec.Type::Item then begin
                                    ItemList += 'Item No- <a href="' + ReqURL + '">' + PurchaseLineRec."No." + '</a>' + ' Description :- ' + PurchaseLineRec.Description + '<br>';
                                    if OrderedBy = '' then
                                        OrderedBy := PurchaseLineRec."Name Ordered By";
                                end;
                            until PurchaseLineRec.Next() = 0;

                        Body := '<p>' + greeting + ' ' + OrderedBy + '<br><br>' +
                                attachmentLbl + '<br><br>' + ItemList + '<br>' +
                                // PONumb + PurchaseHeader."No." + '<br>' +
                                PONumb + '<a href="' + ReqURL + '">' + PurchaseHeader."No." + '</a><br>' +
                                VndNameLbl + PurchaseHeader."Buy-from Vendor Name" + '<br>' +
                                OBULbl + PurchaseHeader."Shortcut Dimension 1 Code" + '<br>' +
                                AmountLbl + Format(TotalAmountIncVAT) + '<br><br>' +
                                EnsureLbl + '<br><br>' +
                                regard;

                        Subject := 'Purchase Request Approved - PO No. ' + Rec."No.";

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
                                // if employeeRec.Get(OrderedBy) then 
                                //     if employeeRec."Company E-Mail" <> '' then
                                //         ToRecipients := employeeRec."Company E-Mail";
                                if employeeRec.get(PurchaseLine."Ordered By") then begin
                                    if employeeRec."Company E-Mail" <> '' then
                                        ToRecipients := employeeRec."Company E-Mail";
                                end else
                                    Message('No employee found for Ordered By = %1', PurchaseLine."Ordered By");
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

    //DCS :: YK20250311--

}
