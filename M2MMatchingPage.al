page 70200 "M2M Matching Page"
{
    PageType = Card;
    Caption = 'Many-to-Many Bank Reconciliation Matching';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Reconciliation Info';

                field(BankAccountNoField; BankAccountNo)
                {
                    ApplicationArea = All;
                    Caption = 'Bank Account No.';
                    Editable = true;
                    ToolTip = 'The bank account being reconciled.';
                }
                field(StatementNoField; StatementNo)
                {
                    ApplicationArea = All;
                    Caption = 'Statement No.';
                    Editable = true;
                    ToolTip = 'The bank statement being reconciled.';
                }
            }

            group(Totals)
            {
                Caption = 'Matching Totals';

                field(StatementLinesTotal; StatementLinesSum)
                {
                    ApplicationArea = All;
                    Caption = 'Statement Lines Total';
                    Editable = true;
                    DecimalPlaces = 2 : 5;
                    Style = Ambiguous;
                    StyleExpr = AmountsDoNotMatch;
                    ToolTip = 'Sum of the selected bank statement lines.';
                }
                field(LedgerEntriesTotal; LedgerEntriesSum)
                {
                    ApplicationArea = All;
                    Caption = 'Ledger Entries Total';
                    Editable = true;
                    DecimalPlaces = 2 : 5;
                    Style = Ambiguous;
                    StyleExpr = AmountsDoNotMatch;
                    ToolTip = 'Sum of the selected ledger entries.';
                }
                field(MatchDifference; StatementLinesSum - LedgerEntriesSum)
                {
                    ApplicationArea = All;
                    Caption = 'Difference';
                    Editable = false;
                    DecimalPlaces = 2 : 5;
                    Style = Unfavorable;
                    StyleExpr = AmountsDoNotMatch;
                    ToolTip = 'Must be zero to apply match.';
                }
            }

            // FIX: SubPageLink removed - filtering done via OnOpenPage using SetFilter
            part(StatementLinesSubPage; "M2M Statement Lines SubPage")
            {
                ApplicationArea = All;
                Caption = 'Bank Statement Lines';
                UpdatePropagation = SubPart;
            }

            part(LedgerEntriesSubPage; "M2M Ledger Entries SubPage")
            {
                ApplicationArea = All;
                Caption = 'Bank Account Ledger Entries';
                UpdatePropagation = SubPart;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ApplyMatch)
            {
                ApplicationArea = All;
                Caption = 'Apply Match';
                Image = ApplyEntries;
                ToolTip = 'Validate and apply the many-to-many match.';

                trigger OnAction()
                var
                    MatchingEngine: Codeunit "M2M Matching Engine";
                    TempBuffer: Record "M2M Match Buffer" temporary;
                begin
                    BuildMatchBuffer(TempBuffer);
                    if MatchingEngine.ApplyManyToManyMatch(TempBuffer, BankAccountNo, StatementNo) then
                        CurrPage.Close();
                end;
            }

            action(RefreshTotals)
            {
                ApplicationArea = All;
                Caption = 'Refresh Totals';
                Image = Refresh;
                ToolTip = 'Recalculate totals from selected lines.';

                trigger OnAction()
                begin
                    RecalculateTotals();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        BankAccountNo: Code[20];
        StatementNo: Code[20];
        StatementLinesSum: Decimal;
        LedgerEntriesSum: Decimal;
        AmountsDoNotMatch: Boolean;

    procedure SetBankReconciliation(NewBankAccountNo: Code[20]; NewStatementNo: Code[20])
    begin
        BankAccountNo := NewBankAccountNo;
        StatementNo := NewStatementNo;
    end;

    local procedure RecalculateTotals()
    begin
        StatementLinesSum := CurrPage.StatementLinesSubPage.Page.GetSelectedAmount();
        LedgerEntriesSum := CurrPage.LedgerEntriesSubPage.Page.GetSelectedAmount();
        AmountsDoNotMatch := (StatementLinesSum <> LedgerEntriesSum) or (StatementLinesSum = 0);
    end;

    local procedure ViewAppliedEntriesForSelection()
    var
        MatchLog: Record "M2M Match Log";
        AppliedEntriesPage: Page "M2M Applied Entries";
        MatchGroupID: Integer;
    begin
        // Get the currently selected statement line from the subpage
        MatchGroupID := CurrPage.StatementLinesSubPage.Page.GetCurrentMatchGroupID();

        if MatchGroupID = 0 then begin
            Message('Please select a statement line with applied entries to view the matched ledger entries.');
            exit;
        end;

        // Open the page showing all applied entries for this match group
        AppliedEntriesPage.SetMatchGroup(MatchGroupID);
        AppliedEntriesPage.RunModal();
    end;

    local procedure BuildMatchBuffer(var TempBuffer: Record "M2M Match Buffer" temporary)
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        SelectedStatementLines: List of [Integer];
        SelectedLedgerEntries: List of [Integer];
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        LineNo: Integer;
        EntryNo: Integer;
        BufferSeq: Integer;
    begin
        Clear(TempBuffer);
        BufferSeq := 0;

        SelectedStatementLines := CurrPage.StatementLinesSubPage.Page.GetSelectedLineNos();
        SelectedLedgerEntries := CurrPage.LedgerEntriesSubPage.Page.GetSelectedEntryNos();

        foreach LineNo in SelectedStatementLines do begin
            if BankAccReconLine.Get(
                BankAccReconLine."Statement Type"::"Bank Reconciliation",
                BankAccountNo, StatementNo, LineNo
            ) then begin
                BufferSeq += 1;
                TempBuffer.Init();
                TempBuffer."Entry No." := BufferSeq;
                TempBuffer."Line Type" := TempBuffer."Line Type"::"Bank Statement Line";
                TempBuffer."Recon Line No." := LineNo;
                TempBuffer.Amount := BankAccReconLine."Statement Amount";
                // FIX: Bank Acc. Reconciliation Line has no Currency Code field
                //      Use Bank Account currency instead
                TempBuffer."Currency Code" := GetBankAccountCurrency(BankAccountNo);
                TempBuffer."Posting Date" := BankAccReconLine."Transaction Date";
                TempBuffer."Bank Account No." := BankAccountNo;
                TempBuffer."Statement No." := StatementNo;
                TempBuffer.Description := BankAccReconLine.Description;
                TempBuffer.Insert();
            end;
        end;

        foreach EntryNo in SelectedLedgerEntries do begin
            if BankAccLedgerEntry.Get(EntryNo) then begin
                BufferSeq += 1;
                TempBuffer.Init();
                TempBuffer."Entry No." := BufferSeq;
                TempBuffer."Line Type" := TempBuffer."Line Type"::"Ledger Entry";
                TempBuffer."Ledger Entry No." := EntryNo;
                TempBuffer.Amount := BankAccLedgerEntry."Remaining Amount";  // Use actual value, not Abs()
                TempBuffer."Currency Code" := BankAccLedgerEntry."Currency Code";
                TempBuffer."Posting Date" := BankAccLedgerEntry."Posting Date";
                TempBuffer."Bank Account No." := BankAccountNo;
                TempBuffer."Statement No." := StatementNo;
                TempBuffer.Insert();
            end;
        end;
    end;

    local procedure GetBankAccountCurrency(BankAccountNo: Code[20]): Code[10]
    var
        BankAccount: Record "Bank Account";
    begin
        if BankAccount.Get(BankAccountNo) then
            exit(BankAccount."Currency Code");
        exit('');
    end;

    trigger OnOpenPage()
    begin
        // Filter sub-pages to current reconciliation
        CurrPage.StatementLinesSubPage.Page.SetBankReconFilter(BankAccountNo, StatementNo);
        CurrPage.LedgerEntriesSubPage.Page.SetBankAccountFilter(BankAccountNo);
        RecalculateTotals();
    end;
}
