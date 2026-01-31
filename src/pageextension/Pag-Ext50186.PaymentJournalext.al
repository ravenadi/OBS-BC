namespace GKBCustomization.GKBCustomization;

using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Purchases.Vendor;
using System.Security.User;
using System.EMail;
using System.Text;
using System.Utilities;
using Microsoft.Foundation.Reporting;
using Microsoft.Bank.ElectronicFundsTransfer;

pageextension 50186 "Payment Journal ext" extends "Payment Journal"
{
    layout
    {
        addafter("Account No.")
        {
            field("Vendor Remittance Email"; rec."Remmitance Email")
            {
                ApplicationArea = All;
                Caption = 'Vendor Remittance Email';
                ToolTip = 'Shows the remittance email from Custom Report Selection for the vendor.';
            }
            // Gkblabs_Tv_03/12/25 
            field(Test; Rec.Test)
            {
                ApplicationArea = All;
                Caption = 'Select to move the batch';
                ToolTip = 'Mark this line to include it in batch consolidation and movement.';
            }
            // 08-JAN-2026 ++
            field("EFT BSB No."; Rec."EFT BSB No.")
            {
                ApplicationArea = All;
                Caption = 'EFT BSB No.';
                ToolTip = 'Displays the EFT BSB (Bank State Branch) number from the vendor bank account.';
            }
            // 08-JAN-2026 --
            // Gkblabs_Tv_03/12/25
        }
    }

    actions
    {
        modify(CreateFile)
        {
            Visible = false;
            // trigger OnBeforeAction()
            // var
            //     GenJournalLine: record "Gen. Journal Line";
            // begin
            //     CurrPage.SetSelectionFilter(GenJournalLine);
            //     if GenJournalLine.IsEmpty() then
            //         Error('Please select at least one line to create the EFT file.');

            //     // Loop through selected lines only
            //     if GenJournalLine.FindSet() then
            //         repeat
            //             // Your EFT logic here
            //             if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then
            //                 CreateEFTLine(GenJournalLine); // Replace with your actual logic
            //         until GenJournalLine.Next() = 0;
            // end;
        }
        addlast(processing)
        {
            action("Create EFT File (Selected)")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create EFT Payments File (Selected)';
                Ellipsis = true;
                Image = CreateDocument;
                ToolTip = 'Generate EFT Payment file for selected journal lines only.';

                trigger OnAction()
                var
                    GenJournalLine: Record "Gen. Journal Line";
                    // GenJournalLine2: Record "Gen. Journal Line";
                    RepCreateEFTFile: Report "Create EFT File Custom";
                    PaymentJournal: page "Payment Journal";
                begin

                    CurrPage.SetSelectionFilter(GenJournalLine);
                    // if genJournalLine.FindSet() then
                    //     GenJournalLine.ModifyAll("Remmitance Report", true);

                    // GenJournalLine2.Reset();
                    // GenJournalLine2.SetRange("Remmitance Report", true);
                    RepCreateEFTFile.SetTableView(GenJournalLine);
                    RepCreateEFTFile.RunModal();

                    // GenJournalLine2.Reset();
                    // GenJournalLine2.SetRange("Remmitance Report", true);
                    // if genJournalLine2.FindSet() then
                    //     GenJournalLine2.ModifyAll("Remmitance Report", false);
                    Clear(RepCreateEFTFile);

                end;
            }

        }
        addlast(Processing)
        {
            //     action("Print Remittance Advice Test")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Remittance Advice Test';
            //         Image = Print;
            //         Promoted = true;
            //         PromotedCategory = Process;
            //         PromotedOnly = true;
            //         trigger OnAction()
            //         var
            //             GenJournalLine: Record "Gen. Journal Line";
            //             GenJournalLine2: Record "Gen. Journal Line";
            //             StandardStatement: Report "Remittance Advice test";
            //             GenJournalLine_VendorWise: Record "Gen. Journal Line";
            //             xVendorNo: Code[20];
            //         // begin
            //         //     CurrPage.SetSelectionFilter(GenJournalLine);
            //         //     if genJournalLine.FindSet() then
            //         //         GenJournalLine.ModifyAll("Remmitance Report", true);

            //         //     Commit();
            //         //     GenJournalLine2.Reset();
            //         //     GenJournalLine2.SetRange("Remmitance Report", true);
            //         //     StandardStatement.SetTableView(GenJournalLine2);
            //         //     StandardStatement.RunModal();

            //         //     GenJournalLine2.Reset();
            //         //     GenJournalLine2.SetRange("Remmitance Report", true);
            //         //     if genJournalLine2.FindSet() then
            //         //         GenJournalLine2.ModifyAll("Remmitance Report", false);
            //         //     Clear(StandardStatement);
            //         begin
            //             xVendorNo := '';
            //             CurrPage.SetSelectionFilter(GenJournalLine);
            //             if GenJournalLine.FindSet() then
            //                 GenJournalLine.ModifyAll("Remmitance Report", true);
            //             Commit();
            //             GenJournalLine2.Reset();
            //             GenJournalLine2.SetRange("Remmitance Report", true);
            //             GenJournalLine2.SetCurrentKey("Account No.");
            //             if genJournalLine2.FindSet() then
            //                 repeat
            //                     if xVendorNo <> GenJournalLine2."Account No." then begin
            //                         xVendorNo := GenJournalLine2."Account No.";
            //                         GenJournalLine_VendorWise.Reset();
            //                         GenJournalLine_VendorWise.SetRange("Remmitance Report", true);
            //                         GenJournalLine_VendorWise.SetRange("Account Type", GenJournalLine2."Account Type"::Vendor);
            //                         GenJournalLine_VendorWise.SetRange("Account No.", GenJournalLine2."Account No.");
            //                         // if GenJournalLine_VendorWise.FindSet() then
            //                         StandardStatement.RunModal();
            //                     end;
            //                 until GenJournalLine2.Next() = 0;

            //         end;
            //     }

            // DCS::HP Today ++
            action("Remittance report")
            {
                Caption = 'Remittance Advice';
                Image = Email;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                // trigger OnAction()
                // var
                //     payJnlRec: Record "Gen. Journal Line";
                //     StandardStatement: Report "Remittance Advice test";
                // begin
                //     CurrPage.SetSelectionFilter(payJnlRec);
                //     SendStatementsByEmail(payJnlRec);
                // end;
                trigger OnAction()
                var
                    StandardStatement: Report "Remittance Advice test";
                    GenJournalLine: Record "Gen. Journal Line";
                    GenJournalLine2: Record "Gen. Journal Line";
                    GenJournalLine_VendorWise: Record "Gen. Journal Line";
                    xVendorNo: Code[20];
                begin
                    xVendorNo := '';
                    CurrPage.SetSelectionFilter(GenJournalLine);
                    if GenJournalLine.FindSet() then
                        GenJournalLine.ModifyAll("Remmitance Report", true);
                    Commit();
                    GenJournalLine2.Reset();
                    GenJournalLine2.SetRange("Remmitance Report", true);
                    // GenJournalLine2.SetRange("Account Type", GenJournalLine2."Account Type"::Vendor);
                    GenJournalLine2.SetCurrentKey("Account No.");
                    if genJournalLine2.FindSet() then
                        repeat
                            if xVendorNo <> GenJournalLine2."Account No." then begin
                                xVendorNo := GenJournalLine2."Account No.";
                                GenJournalLine_VendorWise.Reset();
                                GenJournalLine_VendorWise.SetRange("Remmitance Report", true);
                                GenJournalLine_VendorWise.SetRange("Account Type", GenJournalLine2."Account Type"::Vendor);
                                GenJournalLine_VendorWise.SetRange("Account No.", GenJournalLine2."Account No.");
                                // if GenJournalLine_VendorWise.FindSet() then
                                SendStatementsByEmail(GenJournalLine_VendorWise);
                                // StandardStatement.SetTableView(GenJournalLine_VendorWise);
                                // StandardStatement.Run();
                            end;
                        until GenJournalLine2.Next() = 0;

                    GenJournalLine2.Reset();
                    GenJournalLine2.SetRange("Remmitance Report", true);
                    if GenJournalLine2.FindSet() then
                        GenJournalLine2.ModifyAll("Remmitance Report", false);
                end;
            }

            // action("Send Vendor Summary Mail")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Send Vendor Summary Mail';
            //     Image = Email;
            //     ToolTip = 'Send one email per vendor with total amount from selected lines.';

            //     trigger OnAction()
            //     var
            //         GenJournalLine: Record "Gen. Journal Line";
            //         TempGenJournalLine: Record "Gen. Journal Line" temporary;
            //         VendorMap: Dictionary of [Code[20], Decimal];
            //         VendorRec: Record Vendor;
            //         EmailMessage: Record "Email Item";
            //         VendorNo: Code[20];
            //         Amount: Decimal;
            //         Body, Subject, ToRecipients, UserName : Text;
            //         UserSetup: Record "User Setup";
            //         greetingLbl: Label 'Dear';
            //         paymentLbl: Label 'We have processed the following payment:';
            //         vendorLbl: Label 'Vendor Name : ';
            //         amountLbl: Label 'Total Amount : ';
            //         regardLbl: Label 'Kind regards,';
            //         LayoutEmail: text;
            //     begin
            //         CurrPage.SetSelectionFilter(GenJournalLine);
            //         if GenJournalLine.IsEmpty() then
            //             Error('Please select at least one journal line.');
            //         if GenJournalLine.FindSet() then
            //             repeat
            //                 if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
            //                     VendorNo := GenJournalLine."Account No.";
            //                     Amount := GenJournalLine.Amount;
            //                     if VendorMap.ContainsKey(VendorNo) then
            //                         VendorMap.Set(VendorNo, VendorMap.Get(VendorNo) + Amount)
            //                     else
            //                         VendorMap.Add(VendorNo, Amount);
            //                 end;
            //             until GenJournalLine.Next() = 0;
            //         if UserSetup.Get(UserId()) then
            //             UserName := UserSetup."User Id"
            //         else
            //             UserName := Format(UserId());
            //         foreach VendorNo in VendorMap.Keys do begin
            //             Amount := VendorMap.Get(VendorNo);
            //             if (VendorRec.Get(VendorNo)) then begin
            //                 VendorRec.CalcFields("Vendor Remittance Email");
            //                 LayoutEmail := VendorRec."Vendor Remittance Email";
            //                 if (LayoutEmail <> '') then begin
            //                     ToRecipients := LayoutEmail;
            //                     Subject := 'Payment Notification for ' + VendorRec.Name;

            //                     Body := '<p>' + greetingLbl + ' ' + VendorRec.Name + ',<br><br>' +
            //                             paymentLbl + '<br><br>' +
            //                             vendorLbl + VendorRec.Name + '<br>' +
            //                             amountLbl + Format(Amount) + '<br><br>' +
            //                             regardLbl + '<br>' + UserName + '</p>';

            //                     Clear(EmailMessage);
            //                     EmailMessage.Init();
            //                     EmailMessage."Send to" := ToRecipients;
            //                     EmailMessage.Subject := Subject;
            //                     EmailMessage.SetBodyText(Body);
            //                     EmailMessage.Send(true, Enum::"Email Scenario"::Default);
            //                 end;
            //             end;
            //         end;
            //         Message('Emails sent to %1 vendors.', VendorMap.Count());
            //     end;
            // }

            // Gkblabs_Tv_03/12/25
            action(MoveToSelectedBatch)
            {
                ApplicationArea = All;
                Caption = 'Move to Selected Batch';
                Promoted = true;
                PromotedCategory = Process;
                Image = MoveToNextPeriod;
                ToolTip = 'Move marked lines to a selected batch with consolidation based on Account No., Document No., and Vendor.';

                trigger OnAction()
                var
                    JournalBatchManagement: Codeunit "Journal Batch Management";
                begin
                    JournalBatchManagement.ShowBatchSelectionAndMove(Rec."Journal Template Name");
                    CurrPage.Update(false);
                end;
            }

            action(ApplyToInvoices)
            {
                ApplicationArea = All;
                Caption = 'Apply to Invoices';
                Promoted = true;
                PromotedCategory = Process;
                Image = ApplyEntries;
                ToolTip = 'Manually apply consolidated lines to vendor invoices. Use this if auto-apply did not work.';

                trigger OnAction()
                var
                    AutoApplyCodeunit: Codeunit "Auto Apply After Consolidation";
                begin
                    AutoApplyCodeunit.ManualApplyCurrentBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
            // Gkblabs_Tv_03/12/25
        }
    }

    procedure SendStatementsByEmail(var GJLRec: Record "Gen. Journal Line")
    var
        TempGJL: Record "Gen. Journal Line" temporary;
        EmailMsg: Codeunit "Email Message";
        Email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        FileName: Text;
        ReportParametersXml: Text;
        CurrGJL: Record "Gen. Journal Line";
        Vendorrec: Record Vendor;
        InStream: Instream;
        XMLString: Text;
        Base64Conv: codeunit "Base64 Convert";
        RecRef: RecordRef;
        OutStr: OutStream;
        InStr: InStream;
        ReportID: Integer;
        PdfText: Text;
        recepients: List of [Text];
        Sendmessageto: Text;
        BodyMessage: Text;
        LayoutEmail: text;
        Lineno: Integer;
    begin

        Lineno := 0;
        XMLString := '<?xml version="1.0" standalone="yes"?><ReportParameters name="Remittance Advice Test" id="60105"><DataItems><DataItem name="FindVendors">VERSION(1) SORTING(Field1,Field51,Field2) WHERE(Field1=1(%1),Field51=1(%2),Field5=1(%3),Field7=1(%4))</DataItem><DataItem name="Vendor">VERSION(1) SORTING(Field1) WHERE(Field1=1(%5))</DataItem><DataItem name="VendLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Gen. Journal Line">VERSION(1) SORTING(Field1,Field51,Field5,Field7)</DataItem><DataItem name="Vendor Ledger Entry">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="Detailed Vendor Ledg. Entry">VERSION(1) SORTING(Field2,Field3,Field4)</DataItem><DataItem name="VendLedgEntry2">VERSION(1) SORTING(Field3,Field36,Field43,Field37,Field11)</DataItem><DataItem name="DetailVendLedgEntry2">VERSION(1) SORTING(Field2,Field3,Field4)</DataItem><DataItem name="PrintLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="PrintTotal">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';
        if GJLRec.FindSet() then
            repeat
                TempGJL.Reset();
                TempGJL.SetRange("Document No.", GJLRec."Document No.");
                TempGJL.SetRange("Account No.", GJLRec."Account No.");
                if not TempGJL.FindFirst() then begin
                    Lineno += 1;
                    TempGJL.Init();
                    TempGJL."Journal Template Name" := GJLRec."Journal Template Name";
                    TempGJL."Journal Batch Name" := GJLRec."Journal Batch Name";
                    TempGJL."Line No." := Lineno;
                    TempGJL."Account Type" := GJLRec."Account Type";
                    TempGJL."Account No." := GJLRec."Account No.";
                    TempGJL."Posting Date" := GJLRec."Posting Date";
                    TempGJL."Document No." := GJLRec."Document No.";
                    TempGJL."Account No." := GJLRec."Account No.";
                    TempGJL.Insert();
                end;
            until GJLRec.Next() = 0;
        TempGJL.Reset();
        if TempGJL.FindSet() then
            // Message('TempGL:%1', TempGJL.Count);
        repeat
            Clear(BodyMessage);
            Clear(recepients);
            Clear(PdfText);
            Clear(ReportParametersXml);
            CurrGJL := TempGJL;
            if CurrGJL."Account Type" = CurrGJL."Account Type"::Vendor then begin
                if Vendorrec.get(CurrGJL."Account No.") then begin
                    Vendorrec.CalcFields("Vendor Remittance Email");
                    Vendorrec.TestField("Vendor Remittance Email");
                end;
            end
            else
                Error('The selected journal line is not a vendor payment.');
            // CurrGJL.CalcFields("Vendor Statement Email");

            LayoutEmail := Vendorrec."Vendor Remittance Email";
            if LayoutEmail <> '' then begin
                Sendmessageto := LayoutEmail;
                recepients := Sendmessageto.Split(';');
                // DCS::HP19112025 ++ Changed body content
                BodyMessage :=
                       'Hi there,' + '<br><br>' +
                       'Please find attached your remittance statement.' + '<br><br>' +
                       'Should you have any queries or require any further information, please do not hesitate to contact the undersigned.' + '<br>' +
                       'Notify the undersigned immediately if you are unable to open the attachment.' + '<br><br>' +
                       'Regards,' + '<br>' +
                       'Vineeta Gupta / Accounts Payable' + '<br>' +
                       'Phone / 1300 771 759' + '<br>' +
                       //    DCS::HP04122025 ++ Changed the body content 
                       'Email /' + '<br>' + '<a href="mailto:vineeta@obrien-energy.com">vineeta@obrien-energy.com</a>' + '<br><br>' +
                       'Remittance /' + '<br>' + '<a href="mailto:ap@obrien-energy.com">ap@obrien-energy.com</a>';
                        //    DCS::HP04122025 --
                // DCS::HP19112025 --
                // ReportParametersXml := Report.RunRequestPage(Report::"Remittance Advice Test");
                //Message('ReportParametersXml:%1', ReportParametersXml);
                ReportParametersXml := StrSubstNo(XMLString, CurrGJL."Journal Template Name", CurrGJL."Journal Batch Name", FORMAT(CurrGJL."Posting Date", 0, '<Month,2>/<Day,2>/<Year4>'), CurrGJL."Document No.", CurrGJL."Account No.");
                // Message('ReportParametersXml:%1', ReportParametersXml);
                // ,Format(StartDate, 0, 9), Format(EndDate, 0, 9), CurrGJL."No.");
                Clear(TempBlob);
                tempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
                tempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                if not Report.SaveAs(Report::"Remittance Advice Test", ReportParametersXml, ReportFormat::Pdf, OutStream) then
                    Error('Failed to generate report.');
                TempBlob.CreateInStream(InStream);
                FileName := StrSubstNo('Remittance_%1.pdf', CurrGJL."Account No.");
                TempBlob.CreateInStream(InStream);
                PdfText := Base64Conv.ToBase64(InStream, true);
                EmailMsg.Create(recepients, 'Remittance Statement', BodyMessage, true);
                EmailMsg.AddAttachment(FileName, 'application/pdf', PdfText);
                Email.Send(EmailMsg);
            end;
            until TempGJL.Next() = 0;
    end;

    procedure GetVendorRemittanceEmail(): Text
    begin
        if Rec."Account Type" <> Rec."Account Type"::Vendor then
            exit('');

        if CustomReportSel.Get(CustomReportSel."Usage"::"V.Remittance", Rec."Account No.") then
            exit(CustomReportSel."Send To Email");

        exit('');
    end;

    var
        CustomReportSel: Record "Custom Report Selection";
}


