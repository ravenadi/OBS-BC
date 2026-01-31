codeunit 50127 "Email Attachment Custom"
{
    trigger OnRun()
    var

    begin
        GetReportAsBase64;
        EmailSent();
    end;

    procedure EmailSent()
    var
        CustomerLRec: Record Customer;
        EmailLCodeunit: Codeunit Email;
        subject: Text;
        Recepients: List of [Text];
        usersetup: Record "User Setup";
    begin
        Clear(CustomerLRec);
        Clear(Recepients);
        Clear(subject);
        if usersetup.Get(UserId) then
            Recepients.Add(usersetup."E-Mail");
        Subject := 'Item Ledger Entries report';
        EmailMesageGCodeunit.Create(Recepients, Subject, '', false);
        EmailAttachReportSelection();
        // EmailLCodeunit.OpenInEditor(EmailMesageGCodeunit, Enum::"Email Scenario"::Default);
        EmailLCodeunit.Send(EmailMesageGCodeunit, Enum::"Email Scenario"::Default);
    end;




    local procedure EmailAttachReportSelection()
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        OutStr: OutStream;
        InsStr: InStream;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReportID: Integer;
        FileName: Text;
        TempFile: File;
        txtB64: Text;
        cnv64: Codeunit "Base64 Convert";
    begin
        ReportID := 50120; // Your custom report ID

        // Filter today's records
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Posting Date", Today);

        if ItemLedgerEntry.FindFirst() then begin
            RecRef.GetTable(ItemLedgerEntry);
            RecRef.SetTable(ItemLedgerEntry);
            TempBlob.CreateOutStream(OutStr);

            // Generate the report into TempBlob
            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);

            // Create InStream from written TempBlob (important!)
            TempBlob.CreateInStream(InsStr);
            // Write stream to temporary physical file (debug step)
            txtB64 := cnv64.ToBase64(InsStr, true);
            FileName := 'ItemLedger_Today.pdf';

            // Pass the valid stream to email (ensure your helper codeunit is correctly implemented)
            EmailMesageGCodeunit.AddAttachment(FileName, 'application/pdf', txtB64);
        end;
    end;

    procedure GetReportAsBase64(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        RecRef: RecordRef;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ReportID: Integer;
        Base64: Codeunit "Base64 Convert";
        Base64Text: Text;
    begin
        ReportID := 50120; // Your custom report ID

        ItemLedgerEntry.SetRange("Posting Date", Today);
        if ItemLedgerEntry.FindFirst() then begin
            RecRef.GetTable(ItemLedgerEntry);

            // Save report into TempBlob
            TempBlob.CreateOutStream(OutStr);
            Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStr, RecRef);

            // Convert the blob directly to Base64 using InStream
            TempBlob.CreateInStream(InStr);
            Base64Text := Base64.ToBase64(InStr);

            exit(Base64Text);
        end;

        exit('');
    end;







    var
        EmailMesageGCodeunit: Codeunit "Email Message";
}