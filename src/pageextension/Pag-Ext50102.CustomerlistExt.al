pageextension 50102 "Customer List Ext" extends "Customer List"
{

    layout
    {
        // DCS::HP 19092025 ++
        addafter("Phone No.")
        {
            field("E-mail"; Rec."E-mail")
            {
                ApplicationArea = All;
                Caption = 'E-mail';
                ToolTip = 'Specifies the e-mail address to which general communications are sent.';
            }
            field("Customer Statement Email"; Rec."Customer Statement Email")
            {
                ApplicationArea = All;
                Caption = 'Customer Statement Email';
                ToolTip = 'Specifies the e-mail address to which customer statements are sent. If this field is blank, the system uses the address in the E-mail field.';
            }
        }
        // DCS::HP 19092025 --
        addafter("Payments (LCY)")
        {
            field("Customer Profile"; Rec."Customer Profile")
            {
                ApplicationArea = All;
                Caption = 'Customer Profile';
            }
            field("Supplier account Group"; Rec."Supplier account Group")
            {
                ApplicationArea = All;
                Caption = 'Supplier account Group';
                ShowMandatory = true;
                //Editable = false;
                Enabled = false;
                Visible = true;
            }
            field("CRM ID"; Rec."CRM ID") { ApplicationArea = all; }
            field("D365 Account ID"; Rec."D365 Account ID")
            {
                ApplicationArea = All;
                Caption = 'D365 Account ID';
            }
            field("SAP Customer Number"; Rec."SAP Customer Number")
            {
                ApplicationArea = All;
                Caption = 'SAP Customer Number';
            }
            field("Service Agreement"; Rec."Service Agreement")
            {
                Caption = 'Service Agreement';
                ApplicationArea = All;
            }
            field("Account Contract Manager"; Rec."Account Contract Manager")
            {
                ApplicationArea = All;
                Caption = 'Account Contract Manager';
            }
            field("Capex From"; Rec."Capex From")
            {
                ApplicationArea = All;
            }
            field("Capex To"; Rec."Capex To")
            {
                ApplicationArea = All;
                Caption = 'Capex To';
            }
            field(ABN; Rec.ABN)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(SendStandardStatementsByEmail)
            {
                Caption = 'Send Standard Statements by Email';
                Image = Email;
                ApplicationArea = All;
                // ...existing code...//HJ20250918
                trigger OnAction()
                var
                    CustomerRec: Record Customer;
                    DialogPage: Record StandardStatementDialogBuffer temporary;
                    DateFilter: Record StandardStatementDialogBuffer;
                    Confirmed: Boolean;
                    StandardStatement: Report "Standard Statement";
                    StandardStatementDialog: Page StandardStatementDialog;
                begin
                    CurrPage.SetSelectionFilter(CustomerRec);

                    // Open dialog page for date input
                    // DialogPage.Init();
                    DialogPage.Insert();
                    // Commit();
                    // CurrPage.Update(true);
                    PAGE.RunModal(PAGE::StandardStatementDialog, DialogPage);
                    begin
                        // StandardStatementDialog.SetTableView(DialogPage);
                        // StandardStatementDialog.LookupMode(true);
                        // StandardStatementDialog.Editable(true);
                        // if StandardStatementDialog.RunModal() = ACTION::OK then begin
                        // Confirmed := Dialog.Confirm(
                        //     // StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DialogPage.StartDate), Format(DialogPage.EndDate)), false);
                        //     StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DialogPage.StartDate), Format(DialogPage.EndDate)), false);
                        DateFilter.Reset();
                        if DateFilter.FindFirst() then;
                        Confirmed := Dialog.Confirm(
                            // StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DialogPage.StartDate), Format(DialogPage.EndDate)), false);
                            StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DateFilter.StartDate), Format(DateFilter.EndDate)), false);
                        if not Confirmed then
                            exit;

                        DateFilter.Reset();
                        if DateFilter.FindFirst() then begin
                            //Message('%1 and %2', DateFilter.StartDate, DateFilter.EndDate);
                            SendStatementsByEmail(CustomerRec, DateFilter.StartDate, DateFilter.EndDate);
                        end;
                    end;
                end;
                // ...existing code...//HJ20250918



            }
            // action(PreviewStandardStatementsByEmail)
            // {
            //     Caption = 'Preview Standard Statements by Email';
            //     Image = Email;
            //     ApplicationArea = All;
            //     // ...existing code...//HJ20250918
            //     trigger OnAction()
            //     var
            //         CustomerRec: Record Customer;
            //         DialogPage: Record StandardStatementDialogBuffer temporary;
            //         DateFilter: Record StandardStatementDialogBuffer;
            //         Confirmed: Boolean;
            //         StandardStatement: Report "Standard Statement";
            //         StandardStatementDialog: Page StandardStatementDialog;
            //     begin
            //         CurrPage.SetSelectionFilter(CustomerRec);

            //         // Open dialog page for date input
            //         // DialogPage.Init();
            //         DialogPage.Insert();
            //         // Commit();
            //         // CurrPage.Update(true);
            //         PAGE.RunModal(PAGE::StandardStatementDialog, DialogPage);
            //         begin
            //             // StandardStatementDialog.SetTableView(DialogPage);
            //             // StandardStatementDialog.LookupMode(true);
            //             // StandardStatementDialog.Editable(true);
            //             // if StandardStatementDialog.RunModal() = ACTION::OK then begin
            //             // Confirmed := Dialog.Confirm(
            //             //     // StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DialogPage.StartDate), Format(DialogPage.EndDate)), false);
            //             //     StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DialogPage.StartDate), Format(DialogPage.EndDate)), false);
            //             DateFilter.Reset();
            //             if DateFilter.FindFirst() then;
            //             Confirmed := Dialog.Confirm(
            //                 // StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DialogPage.StartDate), Format(DialogPage.EndDate)), false);
            //                 StrSubstNo('Send statements by email for %1 customers between %2 and %3?', CustomerRec.Count, Format(DateFilter.StartDate), Format(DateFilter.EndDate)), false);
            //             if not Confirmed then
            //                 exit;

            //             DateFilter.Reset();
            //             if DateFilter.FindFirst() then begin
            //                 //Message('%1 and %2', DateFilter.StartDate, DateFilter.EndDate);
            //                 PreviewStatementsByEmail(CustomerRec, DateFilter.StartDate, DateFilter.EndDate);
            //             end;
            //         end;
            //     end;
            //     // ...existing code...//HJ20250918



            // }
        }
        addafter(Dimensions)
        {
            action(DeletingShiptoaddress)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ManINt: Record 5384;
                begin
                    ManINt.Reset();
                    ManINt.SetRange("Table Field No.", 102);
                    ManINt.SetRange("Integration Table Field No.", 49);
                    if ManINt.FindFirst() then
                        ManINt.Delete();
                end;
            }
        }
        addafter("Sent Emails")
        {
            action("Custom Emails")
            {
                ApplicationArea = All;
                Caption = 'Custom Emails';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                // RunObject = codeunit EmailAttachment;
                // trigger OnAction()
                // var
                //     customer: Record Customer;
                //     CustomreportSelection: Record "Custom Report Selection";
                // begin
                //     customer.ModifyAll("E-Mail", '');
                //     CustomreportSelection.Reset();
                //     CustomreportSelection.SetRange("Report ID", 50115);
                //     CustomreportSelection.SetRange("Source Type", 18);
                //     if CustomreportSelection.FindSet() then
                //         CustomreportSelection.ModifyAll("Send To Email", '');

                // end;
            }
        }
    }
    procedure SendStatementsByEmail(var CustomerRec: Record Customer; StartDate: Date; EndDate: Date)
    var
        TempCustomer: Record Customer temporary;
        EmailMsg: Codeunit "Email Message";
        Email: Codeunit Email;


        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        FileName: Text;
        ReportParametersXml: Text;
        CurrCustomer: Record Customer;
        InStream: Instream;
        XMLString: Text;
        Base64Conv: Codeunit "Base64 Convert";
        RecRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        ReportID: Integer;
        PdfText: Text;
        recepients: List of [Text];
        Sendmessageto: Text;
        BodyMessage: Text;
        LayoutEmail: text;
    begin
        XMLString := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Statement Cust" id="50115"><Options><Field name="StartDate">%1</Field><Field name="EndDate">%2</Field><Field name="StatementStyle">0</Field><Field name="PrintEntriesDue">false</Field><Field name="PrintAllHavingEntry">false</Field><Field name="PrintAllHavingBal">true</Field><Field name="PrintReversedEntries">false</Field><Field name="PrintUnappliedEntries">false</Field><Field name="IncludeAgingBand">True</Field><Field name="PeriodLength">30D</Field><Field name="DateChoice">0</Field><Field name="LogInteraction">true</Field><Field name="CustomerFilter">%3</Field><Field name="SupportedOutputMethod">4</Field><Field name="ChosenOutputMethod">3</Field><Field name="PrintIfEmailIsMissing">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Integer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CurrencyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntryHdr">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DtldCustLedgEntries">VERSION(1) SORTING(Field9,Field4,Field3,Field10)</DataItem><DataItem name="CustLedgEntryFooter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="OverdueVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntry2">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="OverdueEntryFooder">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingBandVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingCustLedgEntry">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="AgingBandLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LetterText">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';

        // Copy filtered customers to a temporary record
        if CustomerRec.FindSet() then
            repeat
                TempCustomer := CustomerRec;
                TempCustomer.Insert();
            until CustomerRec.Next() = 0;

        if TempCustomer.FindSet() then
            repeat
                Clear(BodyMessage);
                Clear(recepients);
                Clear(PdfText);
                Clear(ReportParametersXml);
                CurrCustomer := TempCustomer;
                CurrCustomer.CalcFields("Customer Statement Email");
                LayoutEmail := CurrCustomer."Customer Statement Email";
                // DCS::HP 19092025 ++
                if LayoutEmail <> '' then begin
                    Sendmessageto := LayoutEmail;
                    // DCS::HP 19092025 --
                    recepients := Sendmessageto.Split(';');

                    // BodyLbl: Label 'Thank you for your business. Your statement is attached to this message.';
                    // BodyMessage += ('Dear Sir,');
                    // BodyMessage += ('<br>');
                    // BodyMessage += ('<br>');
                    // BodyMessage += ('Find the attachments ' + Format(CurrentDateTime));
                    // BodyMessage += ('<br>');
                    // BodyMessage += ('<br>');
                    // BodyMessage += ('Thank You,');

                    //DCSPL:PK 14Aug2025 ++
                    BodyMessage :=
                           'Hi there,' + '<br><br>' +
                           'Please find attached your monthly statement.' + '<br><br>' +
                           'Should you have any queries or require any further information, please do not hesitate to contact the undersigned.' + '<br>' +
                           'Notify the undersigned immediately if you are unable to open the attachment.' + '<br><br>' +
                           'Regards,' + '<br>' +
                           'Roxana Cisternas / Accounts Receivable' + '<br>' +
                           'Phone / +61 3 8325 1016' + '<br>' +
                           'Email / <a href="mailto:roxana@obrien-energy.com">roxana@obrien-energy.com</a>' + '<br>' +
                           'Remittance / <a href="mailto:ar@obrien-energy.com">ar@obrien-energy.com</a>';
                    //DCSPL:PK 14Aug2025 --

                    // Prepare report parameters as XML
                    // ReportParametersXml := Report.RunRequestPage(Report::"Customer Statement Cust");
                    // // Message('ReportParametersXml:%1', ReportParametersXml);
                    // XMLString := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Standard Statement" id="1316"><Options><Field name="StartDate">%1</Field><Field name="EndDate">%2</Field><Field name="StatementStyle">0</Field><Field name="PrintEntriesDue">false</Field><Field name="PrintAllHavingEntry">false</Field><Field name="PrintAllHavingBal">true</Field><Field name="PrintReversedEntries">false</Field><Field name="PrintUnappliedEntries">false</Field><Field name="IncludeAgingBand">true</Field><Field name="PeriodLength">30D</Field><Field name="DateChoice">0</Field><Field name="LogInteraction">false</Field><Field name="SupportedOutputMethod">0</Field><Field name="ChosenOutputMethod">0</Field><Field name="PrintIfEmailIsMissing">false</Field><Field name="CustomerSelection" /></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1) WHERE(Field1=1(%3))</DataItem><DataItem name="Integer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CurrencyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntryHdr">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DtldCustLedgEntries">VERSION(1) SORTING(Field9,Field4,Field3,Field10)</DataItem><DataItem name="CustLedgEntryFooter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="OverdueVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntry2">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="OverdueEntryFooder">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingBandVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingCustLedgEntry">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="AgingBandLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LetterText">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
                    // XMLString := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Statement Cust" id="50115"><Options><Field name="StartDate">%1</Field><Field name="EndDate">%2</Field><Field name="StatementStyle">0</Field><Field name="PrintEntriesDue">false</Field><Field name="PrintAllHavingEntry">false</Field><Field name="PrintAllHavingBal">true</Field><Field name="PrintReversedEntries">false</Field><Field name="PrintUnappliedEntries">false</Field><Field name="IncludeAgingBand">true</Field><Field name="PeriodLength">30D</Field><Field name="DateChoice">0</Field><Field name="LogInteraction">false</Field><Field name="CustomerFilter"></Field><Field name="SupportedOutputMethod">0</Field><Field name="ChosenOutputMethod">0</Field><Field name="PrintIfEmailIsMissing">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1) WHERE(Field1=1(%3),Field42=1(1))</DataItem><DataItem name="Integer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CurrencyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntryHdr">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DtldCustLedgEntries">VERSION(1) SORTING(Field9,Field4,Field3,Field10)</DataItem><DataItem name="CustLedgEntryFooter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="OverdueVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntry2">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="OverdueEntryFooder">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingBandVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingCustLedgEntry">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="AgingBandLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LetterText">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
                    // MEssage('StartDate= %2 ,EndDate= %1', Format(StartDate, 0, 9), Format(EndDate, 0, 9));
                    // ReportParametersXml := StrSubstNo(XMLString, Format(StartDate, 0, 9), Format(EndDate, 0, 9), CurrCustomer."No.");


                    // // Export report as PDF
                    // Clear(OutStream);//PK
                    // TempBlob.CreateOutStream(OutStream);
                    // Message('%1', ReportParametersXml);
                    // Report.SaveAs(Report::"Customer Statement Cust", ReportParametersXml, ReportFormat::Pdf, OutStream);
                    // // Report.SaveAs(1316, ReportParametersXml, ReportFormat::Pdf, OutStream);
                    // // Message(ReportParametersXml);
                    // TempBlob.CreateInStream(InStream);
                    // FileName := StrSubstNo('Statement_%1.pdf', CurrCustomer."No.");//Format(CurrentDateTime(), 0, 9)
                    // DownloadFromStream(InStream, '', '', '', FileName);
                    // TempBlob.CreateInStream(InStream);
                    // PdfText := Base64Conv.ToBase64(InStream, true);
                    ReportParametersXml := StrSubstNo(XMLString, Format(StartDate, 0, 9), Format(EndDate, 0, 9), CurrCustomer."No.");
                    Clear(TempBlob);
                    tempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
                    tempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                    if not Report.SaveAs(Report::"Customer Statement Cust", ReportParametersXml, ReportFormat::Pdf, OutStream) then
                        Error('Failed to generate report.');
                    TempBlob.CreateInStream(InStream);
                    FileName := StrSubstNo('Statement_%1.pdf', CurrCustomer."No.");
                    // DownloadFromStream(InStream, '', '', '', FileName);
                    TempBlob.CreateInStream(InStream);
                    PdfText := Base64Conv.ToBase64(InStream, true);

                    // EmailMsg.AddAttachment('CustomerStatement_' + CurrCustomer."No." + '.pdf', 'application/pdf', PdfText);

                    // Email.Send(EmailMsg, Enum::"Email Scenario"::Default);

                    EmailMsg.Create(recepients, 'Monthly Statement', BodyMessage, true);
                    EmailMsg.AddAttachment(FileName, 'application/pdf', PdfText);
                    // EmailMsg.AddAttachment(FileName, 'application/pdf', InStream);
                    Email.Send(EmailMsg);
                end;
            until TempCustomer.Next() = 0;
    end;

    // procedure PreviewStatementsByEmail(var CustomerRec: Record Customer; StartDate: Date; EndDate: Date)
    // var
    //     TempCustomer: Record Customer temporary;
    //     EmailMsg: Codeunit "Email Message";
    //     Email: Codeunit Email;


    //     TempBlob: Codeunit "Temp Blob";
    //     OutStream: OutStream;
    //     FileName: Text;
    //     ReportParametersXml: Text;
    //     CurrCustomer: Record Customer;
    //     InStream: Instream;
    //     XMLString: Text;
    //     Base64Conv: Codeunit "Base64 Convert";
    //     RecRef: RecordRef;
    //     OutStr: OutStream;
    //     InStr: InStream;
    //     ReportID: Integer;
    //     PdfText: Text;
    //     recepients: List of [Text];
    //     Sendmessageto: Text;
    //     BodyMessage: Text;
    //     CustomerFilter: text;
    //     CustoemrCustomReport: report "Customer Statement Cust";
    //     NewDateChoice: Option "Due Date","Posting Date";
    // begin
    //     XMLString := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Customer Statement Cust" id="50115"><Options><Field name="StartDate">%1</Field><Field name="EndDate">%2</Field><Field name="StatementStyle">0</Field><Field name="PrintEntriesDue">false</Field><Field name="PrintAllHavingEntry">false</Field><Field name="PrintAllHavingBal">true</Field><Field name="PrintReversedEntries">false</Field><Field name="PrintUnappliedEntries">false</Field><Field name="IncludeAgingBand">false</Field><Field name="PeriodLength">30D</Field><Field name="DateChoice">0</Field><Field name="LogInteraction">true</Field><Field name="CustomerFilter">%3</Field><Field name="SupportedOutputMethod">4</Field><Field name="ChosenOutputMethod">3</Field><Field name="PrintIfEmailIsMissing">false</Field></Options><DataItems><DataItem name="Customer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Integer">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CurrencyLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntryHdr">VERSION(1) SORTING(Field1)</DataItem><DataItem name="DtldCustLedgEntries">VERSION(1) SORTING(Field9,Field4,Field3,Field10)</DataItem><DataItem name="CustLedgEntryFooter">VERSION(1) SORTING(Field1)</DataItem><DataItem name="OverdueVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="CustLedgEntry2">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="OverdueEntryFooder">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingBandVisible">VERSION(1) SORTING(Field1)</DataItem><DataItem name="AgingCustLedgEntry">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="AgingBandLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="LetterText">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';

    //     // Copy filtered customers to a temporary record
    //     if CustomerRec.FindSet() then
    //         repeat
    //             TempCustomer := CustomerRec;
    //             TempCustomer.Insert();
    //         until CustomerRec.Next() = 0;

    //     if TempCustomer.FindSet() then
    //         repeat
    //             if CustomerFilter <> '' then
    //                 CustomerFilter := CustomerFilter + '|' + CurrCustomer."No."
    //             else
    //                 CustomerFilter := CurrCustomer."No.";
    //         until TempCustomer.Next() = 0;
    //     Clear(ReportParametersXml);
    //     CurrCustomer := TempCustomer;
    //     ReportParametersXml := StrSubstNo(XMLString, Format(StartDate, 0, 9), Format(EndDate, 0, 9), CurrCustomer."No.");
    //     CustoemrCustomReport.InitializeRequest(false, false, false, false, false, false, '', NewDateChoice::"Posting Date", false, StartDate, EndDate, CustomerFilter);
    //     // CustoemrCustomReport.RunRequestPage(ReportParametersXml);
    //     CustoemrCustomReport.UseRequestPage := true;
    //     CustoemrCustomReport.RunModal();
    //     // Report.Run(Report::"Customer Statement Cust", false, false, CurrCustomer);
    //     // if not Report.SaveAs(Report::"Customer Statement Cust", ReportParametersXml, ReportFormat::Pdf, OutStream) then
    // end;
}
