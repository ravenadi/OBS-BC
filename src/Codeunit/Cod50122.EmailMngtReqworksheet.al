// codeunit 50122 "Email Mngt Req worksheet"
// {
//     procedure RequisitionPendingStatus(Rec: Record "Requisition Line")
//     var
//         greeting: Label 'Dear Manager,';
//         attachmentLbl: Label 'Please find below the link to view all the pending approvals in the Requisition Worksheet that are currently awaiting action for Purchase Order (PO) creation:';
//         vendName: Label 'Kindly review and take the necessary actions to proceed with PO generation.';
//         POBNumb: Label 'Requisition Number : ';
//         EnsureLbl: Label '';
//         regard: Label 'Kind regards,';
//         Body: text;
//         Email: Codeunit Email;
//         EmailMessage: Record "Email Item";
//         Subject: Text;
//         ToRecipients: Text[250];
//         CCRecepients: Text[250];
//         UserSetup: Record "User Setup";
//         UserSetting: Record "User Personalization";
//         DimensionValues: Record "Dimension Value";
//         GLSetup: Record "General Ledger Setup";
//         Outstr: OutStream;
//         Instr: InStream;
//         RecRef: RecordRef;
//         User: Record User;
//         TempBlob: Codeunit "Temp Blob";
//         mailmngt: Codeunit "Mail Management";
//         RequisitionLine: Record "Requisition Line";
//         ReqURL: Text;
//     begin
//         // RequisitionLine.Reset();
//         RequisitionLine.SetRange(StatusReq, Rec.StatusReq::"Pending Approval");
//         if RequisitionLine.Findfirst() then Begin
//             if RequisitionLine."Requested By Name" <> '' then begin

//                 Clear(ReqURL);
//                 if GLSetup.Get() then;
//                 EmailMessage.SendAsHTML(true);
//                 ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, page::"Req. Worksheet", RequisitionLine, true);
//                 Body := '<p>' + greeting + '<br>' + '<br>' + attachmentLbl + '<br>' + '<a href="' + ReqURL + '">' + 'Click Here' + '</a>' + '<br>' + EnsureLbl + '<br>' + vendName + '<br>' + '<br>' + regard;
//                 Subject := 'Pending Requisition Worksheet for Approval';


//                 UserSetting.Reset();
//                 // UserSetting.SetRange(Role, 'Sales Order Processor');
//                 UserSetting.SetRange(Role, 'Procurement Manager');
//                 if UserSetting.FindSet() then
//                     repeat
//                         Clear(ToRecipients);
//                         if User.Get(UserSetting."User SID") then
//                             if UserSetup.get(User."User Name") then
//                                 if UserSetup."E-Mail" <> '' then
//                                     if ToRecipients = '' then
//                                         ToRecipients := UserSetup."E-Mail"
//                                     else
//                                         ToRecipients += ';' + UserSetup."E-Mail";



//                         RecRef.GetTable(RequisitionLine);
//                         // if ToRecipients.Count <> 0 then begin

//                         EmailMessage."Send to" := ToRecipients;
//                         EmailMessage."Send CC" := CCRecepients;
//                         EmailMessage.Subject := Subject;
//                         EmailMessage.SetBodyText(Body);
//                         // mailmngt.Send(EmailMessage, Enum::"Email Scenario"::Default);
//                         EmailMessage.Send(true, Enum::"Email Scenario"::Default);
//                     until UserSetting.Next() = 0;
//             end
//             else
//                 Error('Cannot proceed further as Requested By = '' ''.');
//         end;
//         //DCS::HP04112025 ++
//         Message('Request Submitted Successfully');
//         //DCS::HP04112025 --
//     end;
// }


codeunit 50122 "Email Mngt Req worksheet"
{
    procedure RequisitionPendingStatus(Rec: Record "Requisition Line")
    var
        greeting: Label 'Dear Manager,';
        attachmentLbl: Label 'Please find below the link to view all the pending approvals in the Requisition Worksheet that are currently awaiting action for Purchase Order (PO) creation:';
        vendName: Label 'Kindly review and take the necessary actions to proceed with PO generation.';
        POBNumb: Label 'Requisition Number : ';
        EnsureLbl: Label '';
        regard: Label 'Kind regards,';
        Body: Text;
        Email: Codeunit Email;
        EmailMessage: Record "Email Item";
        Subject: Text;
        ToRecipients: Text[250];
        CCRecepients: Text[250];
        UserSetup: Record "User Setup";
        UserSetting: Record "User Personalization";
        DimensionValues: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        Outstr: OutStream;
        Instr: InStream;
        RecRef: RecordRef;
        User: Record User;
        TempBlob: Codeunit "Temp Blob";
        mailmngt: Codeunit "Mail Management";
        RequisitionLine: Record "Requisition Line";
        ReqURL: Text;
        EmailsSent: Boolean;
    begin
        RequisitionLine.SetRange(StatusReq, Rec.StatusReq::"Pending Approval");
        if RequisitionLine.FindFirst() then begin
            if RequisitionLine."Requested By Name" = '' then
                Error('Cannot proceed further as "Requested By Name" is empty.');
            Clear(ReqURL);
            if GLSetup.Get() then;
            EmailMessage.SendAsHTML(true);
            ReqURL := GetUrl(ClientType::Web, CompanyName, ObjectType::Page, Page::"Req. Worksheet", RequisitionLine, true);
            Body :=
                '<p>' + greeting + '<br><br>' +
                attachmentLbl + '<br>' +
                '<a href="' + ReqURL + '">Click Here</a><br><br>' +
                vendName + '<br><br>' +
                regard + '</p>';
            Subject := 'Pending Requisition Worksheet for Approval';
            UserSetting.Reset();
            UserSetting.SetRange(Role, 'Procurement Manager');
            if UserSetting.FindSet() then begin
                repeat
                    Clear(ToRecipients);
                    if User.Get(UserSetting."User SID") then
                        if UserSetup.Get(User."User Name") then
                            if UserSetup."E-Mail" <> '' then
                                if ToRecipients = '' then
                                    ToRecipients := UserSetup."E-Mail"
                                else
                                    ToRecipients += ';' + UserSetup."E-Mail";
                    if ToRecipients <> '' then begin
                        EmailMessage."Send to" := ToRecipients;
                        EmailMessage."Send CC" := CCRecepients;
                        EmailMessage.Subject := Subject;
                        EmailMessage.SetBodyText(Body);
                        EmailMessage.Send(true, Enum::"Email Scenario"::Default);
                        EmailsSent := true;
                    end;
                until UserSetting.Next() = 0;
            end;
            if EmailsSent then
                Message('Request Submitted Successfully.')
            else
                Message('No valid recipients found for pending requisitions.');
        end else
            Message('No requisition lines found with status Pending Approval.');
    end;
}
