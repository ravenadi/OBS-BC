codeunit 50129 "Email Attachment Customer"
{
    procedure EmailCustomerStatement(CustomerNo: Code[20])
    var
        Cust: Record Customer;
        Email: Codeunit Email;
        EmailMsg: Codeunit "Email Message";
        Base64Conv: Codeunit "Base64 Convert";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        ReportID: Integer;
        PdfText: Text;
    begin
        if not Cust.Get(CustomerNo) then
            exit;

        EmailMsg.Create(Cust."E-Mail", 'Customer Statement', '', false);

        // Generate PDF for this customer
        ReportID := 1316; // or your custom report //YK
        // ReportID := 50115; // or your custom report //YK
        Cust.SetRange("No.", CustomerNo);

        RecRef.GetTable(Cust);
        RecRef.SetTable(Cust);
        TempBlob.CreateOutStream(OutStr);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);
        TempBlob.CreateInStream(InStr);
        PdfText := Base64Conv.ToBase64(InStr, true);

        EmailMsg.AddAttachment('CustomerStatement_' + CustomerNo + '.pdf', 'application/pdf', PdfText);

        Email.Send(EmailMsg, Enum::"Email Scenario"::Default);
    end;
}
