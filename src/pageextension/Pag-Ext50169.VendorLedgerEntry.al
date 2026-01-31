pageextension 50169 "Vendor Ledger Entry" extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Navigate")
        {
            action("Send Mail")
            {
                ApplicationArea = All;
                Caption = 'Send Mail';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                    EmailCodeunit: Codeunit "Email Attc Vendor Remittance";
                    VendorList: List of [Text];
                    ExtDocNoList: List of [Integer];
                    VendorNo: Text;
                    i: Integer;
                    ExtDocNo: Integer;
                begin
                    CurrPage.SetSelectionFilter(VendorLedgerEntry);
                    if VendorLedgerEntry.FindSet() then
                        repeat
                            VendorList.Add(VendorLedgerEntry."Vendor No.");
                            ExtDocNoList.Add(VendorLedgerEntry."Entry No.");
                        until VendorLedgerEntry.Next() = 0;

                    if not Confirm('Do you want to send remittance emails for %1 selected entries?', false, VendorList.Count()) then
                        exit;
                    // Use counter-based loop since AL doesn't support indexing Lists directly
                    begin
                        for i := 1 to VendorList.Count() do begin
                            VendorNo := VendorList.Get(i);
                            ExtDocNo := ExtDocNoList.Get(i);
                            EmailCodeunit.GetReportAsBase64(VendorNo, ExtDocNo, false);
                            // EmailCodeunit.GetReportAsBase64(VendorNo, ExtDocNo);
                            EmailCodeunit.EmailSent(VendorNo, ExtDocNo);
                        end;
                    end;
                    Message('Remittance emails successfully sent for %1 entries.', VendorList.Count());
                end;
            }
            action("Download Mail Reports")
            {
                ApplicationArea = All;
                Caption = 'Download Mail Reports';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    VendorLedgerEntry: Record "Vendor Ledger Entry";
                    EmailCodeunit: Codeunit "Email Attc Vendor Remittance";
                    VendorList: List of [Text];
                    ExtDocNoList: List of [Integer];
                    VendorNo: Text;
                    i: Integer;
                    ExtDocNo: Integer;
                begin
                    CurrPage.SetSelectionFilter(VendorLedgerEntry);
                    if VendorLedgerEntry.FindSet() then
                        repeat
                            VendorList.Add(VendorLedgerEntry."Vendor No.");
                            ExtDocNoList.Add(VendorLedgerEntry."Entry No.");
                        until VendorLedgerEntry.Next() = 0;

                    if not Confirm('Do you want to download remittance emails for %1 selected entries?', false, VendorList.Count()) then
                        exit;
                    begin
                        for i := 1 to VendorList.Count() do begin
                            VendorNo := VendorList.Get(i);
                            ExtDocNo := ExtDocNoList.Get(i);
                            EmailCodeunit.GetReportAsBase64(VendorNo, ExtDocNo, true);
                        end;
                    end;
                    Message('Remittance emails downloaded successfully for %1 entries.', VendorList.Count());
                end;
            }
        }
    }
    var
        VendorNo: Text[250];
}