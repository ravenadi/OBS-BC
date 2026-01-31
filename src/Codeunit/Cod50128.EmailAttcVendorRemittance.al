codeunit 50128 "Email Attc Vendor Remittance"

{
    procedure EmailSent(VendorNo: Text; extDocNo: Integer)
    var
        Vendor: Record Vendor;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        EmailLCodeunit: Codeunit Email;
        subject: Text;
        BodyText: Text;
        Recepients: Text;
        usersetup: Record "User Setup";
    begin
        if Vendor.Get(VendorNo) then
            Recepients := Vendor."E-Mail";

        Subject := 'Remittance Advice for Vendor ' + VendorNo;
        BodyText := GetHTMLBody(VendorNo, extDocNo);
        EmailMesageGCodeunit.Create(Recepients, Subject, BodyText, true);
        EmailAttachReportSelection(VendorNo, extDocNo);

        EmailLCodeunit.Send(EmailMesageGCodeunit, Enum::"Email Scenario"::Default);
    end;

    local procedure EmailAttachReportSelection(VendorNo: Text; extDocNo: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        VLE: Record "Vendor Ledger Entry";
        ReportID: Integer;
        FileName: Text;
        txtB64: Text;
        cnv64: Codeunit "Base64 Convert";
    begin
        ReportID := 50126; // Custom Report ID

        VLE.Reset();
        VLE.SetRange("Vendor No.", VendorNo);
        VLE.SetRange("Entry No.", extDocNo);
        if VLE.FindFirst() then begin
            RecRef.GetTable(VLE);
            RecRef.SetTable(VLE);
            TempBlob.CreateOutStream(OutStr);

            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);

            TempBlob.CreateInStream(InStr);
            txtB64 := cnv64.ToBase64(InStr, true);
            FileName := 'ItemLedger_' + VendorNo + '_' + format(extDocNo) + '.pdf';

            EmailMesageGCodeunit.AddAttachment(FileName, 'application/pdf', txtB64);
        end;
    end;

    procedure GetReportAsBase64(VendorCode: Text; extDocNo: Integer; ForDownload: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        RecRef: RecordRef;
        Vendor: Record "Vendor Ledger Entry";
        ReportID: Integer;
        Base64: Codeunit "Base64 Convert";
        Base64Text: Text;
        FileName: Text;
    begin
        ReportID := 50126; // Your custom report ID
        Vendor.Reset();
        Vendor.SetFilter("Vendor No.", VendorCode);
        Vendor.SetRange("Entry No.", extDocNo);
        if Vendor.findset() then
            repeat
                RecRef.GetTable(Vendor);

                // Save report into TempBlob
                TempBlob.CreateOutStream(OutStr);
                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);

                // Convert the blob directly to Base64 using InStream
                TempBlob.CreateInStream(InStr);
                Base64Text := Base64.ToBase64(InStr);
                if ForDownload then begin
                    FileName := 'VendorReport.pdf';
                    //   if TempBlob.HasValue() then
                    TempBlob.CreateInStream(InStr);
                    DownloadFromStream(InStr, 'Vendor Report', '', '', Filename);
                end;


                exit(Base64Text);
            until Vendor.Next() = 0;

    end;



    local procedure GetHTMLBody(VendorNo: Text;
extDocNo: Integer): Text
    var
        VLE: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        HTMLBody: Text;
    begin
        Clear(HTMLBody);
        VLE.Reset();
        VLE.SetFilter("Vendor No.", VendorNo);
        VLE.SetRange("Entry No.", extDocNo);

        if VLE.FindFirst() then begin
            if Vendor.Get(VendorNo) then;

            // DCS::HP04122025 ++
            // HTMLBody :=
            //   '<html>' +
            //   '<body style="font-family:Segoe UI, sans-serif; font-size:14px;">' +
            //   '<p>Dear ' + Vendor.Name + ',</p>' +
            //   '<p>Please find attached the Remittance Advice.</p>' +
            //   '<p>Just a friendly reminder — all invoices and statements must be sent to our Accounts Payable inbox:<br>' +
            //   '<a>accounts@obrien-energy.com</a></p>' +
            //   '<p>Regards,<br><strong>Accounts Payable</strong></p>' +
            //   '</body>' +
            //   '</html>';
            HTMLBody :=
                '<html>' +
                '<body style="font-family:Segoe UI, sans-serif; font-size:14px;">' +
                'Hi there,<br><br>' +
                'Please find attached your remittance statement.<br><br>' +
                'Should you have any queries or require any further information, please do not hesitate to contact the undersigned.<br>' +
                'Notify the undersigned immediately if you are unable to open the attachment.<br><br>' +
                'Regards,<br>' +
                'Vineeta Gupta / Accounts Payable<br>' +
                'Phone / 1300 771 759<br>' +
                'Email /<br><a href="mailto:vineeta@obrien-energy.com">vineeta@obrien-energy.com</a><br><br>' +
                'Remittance /<br><a href="mailto:ap@obrien-energy.com">ap@obrien-energy.com</a>' +
                '</body>' +
                '</html>';
            // DCS::HP04122025 --

            exit(HTMLBody);
        end;
    end;

    var
        EmailMesageGCodeunit: Codeunit "Email Message";
}