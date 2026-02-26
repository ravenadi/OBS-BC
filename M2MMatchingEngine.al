codeunit 70200 "M2M Matching Engine"
{
    Permissions = tabledata "Bank Account Ledger Entry" = rm;

    procedure ApplyManyToManyMatch(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        BankAccountNo: Code[20];
        StatementNo: Code[20]
    ): Boolean
    var
        ValidationResult: Boolean;
        ErrorMessage: Text;
    begin
        ValidationResult := ValidateMatchBuffer(TempMatchBuffer, BankAccountNo, ErrorMessage);
        if not ValidationResult then begin
            Error(ErrorMessage);
            exit(false);
        end;
        ApplyMatchToReconciliationLines(TempMatchBuffer, BankAccountNo, StatementNo);
        exit(true);
    end;

    procedure ValidateMatchBuffer(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        BankAccountNo: Code[20];
        var ErrorMessage: Text
    ): Boolean
    begin
        if not ValidateMinimumLines(TempMatchBuffer, ErrorMessage) then
            exit(false);
        if not ValidateCurrency(TempMatchBuffer, BankAccountNo, ErrorMessage) then
            exit(false);
        if not ValidateAmounts(TempMatchBuffer, ErrorMessage) then
            exit(false);
        if not ValidatePostingDates(TempMatchBuffer, ErrorMessage) then
            exit(false);
        exit(true);
    end;

    local procedure ValidateMinimumLines(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        var ErrorMessage: Text
    ): Boolean
    var
        StatementLineCount: Integer;
        LedgerEntryCount: Integer;
    begin
        TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Bank Statement Line");
        StatementLineCount := TempMatchBuffer.Count();
        TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Ledger Entry");
        LedgerEntryCount := TempMatchBuffer.Count();
        TempMatchBuffer.SetRange("Line Type");

        if StatementLineCount = 0 then begin
            ErrorMessage := 'You must select at least one Bank Statement Line for matching.';
            exit(false);
        end;
        if LedgerEntryCount = 0 then begin
            ErrorMessage := 'You must select at least one Bank Account Ledger Entry for matching.';
            exit(false);
        end;
        exit(true);
    end;

    local procedure ValidateCurrency(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        BankAccountNo: Code[20];
        var ErrorMessage: Text
    ): Boolean
    var
        BankAccount: Record "Bank Account";
        FirstCurrency: Code[10];
        IsFirst: Boolean;
    begin
        IsFirst := true;
        if TempMatchBuffer.FindSet() then
            repeat
                if IsFirst then begin
                    FirstCurrency := TempMatchBuffer."Currency Code";
                    IsFirst := false;
                end else begin
                    if TempMatchBuffer."Currency Code" <> FirstCurrency then begin
                        ErrorMessage := StrSubstNo(
                            'Currency mismatch: all selected lines must use the same currency. Found "%1" and "%2".',
                            FirstCurrency,
                            TempMatchBuffer."Currency Code"
                        );
                        exit(false);
                    end;
                end;
            until TempMatchBuffer.Next() = 0;

        if BankAccountNo <> '' then
            if BankAccount.Get(BankAccountNo) then
                if BankAccount."Currency Code" <> FirstCurrency then begin
                    ErrorMessage := StrSubstNo(
                        'Currency mismatch: selected lines use currency "%1" but bank account "%2" uses "%3".',
                        FirstCurrency,
                        BankAccountNo,
                        BankAccount."Currency Code"
                    );
                    exit(false);
                end;
        exit(true);
    end;

    local procedure ValidateAmounts(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        var ErrorMessage: Text
    ): Boolean
    var
        StatementSum: Decimal;
        LedgerSum: Decimal;
    begin
        TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Bank Statement Line");
        if TempMatchBuffer.FindSet() then
            repeat
                StatementSum += TempMatchBuffer.Amount;
            until TempMatchBuffer.Next() = 0;

        TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Ledger Entry");
        if TempMatchBuffer.FindSet() then
            repeat
                LedgerSum += TempMatchBuffer.Amount;
            until TempMatchBuffer.Next() = 0;

        TempMatchBuffer.SetRange("Line Type");

        if StatementSum <> LedgerSum then begin
            ErrorMessage := StrSubstNo(
                'Amount mismatch: Bank Statement Lines total %1 but Ledger Entries total %2. The difference is %3. Posting is blocked.',
                Format(StatementSum),
                Format(LedgerSum),
                Format(StatementSum - LedgerSum)
            );
            exit(false);
        end;
        exit(true);
    end;

    local procedure ValidatePostingDates(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        var ErrorMessage: Text
    ): Boolean
    var
        AccountingPeriod: Record "Accounting Period";
        PostingDate: Date;
        EarliestAllowedDate: Date;
        LatestAllowedDate: Date;
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        EarliestAllowedDate := GeneralLedgerSetup."Allow Posting From";
        LatestAllowedDate := GeneralLedgerSetup."Allow Posting To";

        TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Ledger Entry");
        if TempMatchBuffer.FindSet() then
            repeat
                PostingDate := TempMatchBuffer."Posting Date";
                if PostingDate = 0D then
                    PostingDate := Today();

                if EarliestAllowedDate <> 0D then
                    if PostingDate < EarliestAllowedDate then begin
                        ErrorMessage := StrSubstNo(
                            'Posting date %1 is before the earliest allowed posting date %2. Please review General Ledger Setup.',
                            Format(PostingDate), Format(EarliestAllowedDate)
                        );
                        TempMatchBuffer.SetRange("Line Type");
                        exit(false);
                    end;

                if LatestAllowedDate <> 0D then
                    if PostingDate > LatestAllowedDate then begin
                        ErrorMessage := StrSubstNo(
                            'Posting date %1 is after the latest allowed posting date %2. Please review General Ledger Setup.',
                            Format(PostingDate), Format(LatestAllowedDate)
                        );
                        TempMatchBuffer.SetRange("Line Type");
                        exit(false);
                    end;

                AccountingPeriod.SetRange("Starting Date", 0D, PostingDate);
                AccountingPeriod.SetRange(Closed, false);
                if not AccountingPeriod.FindLast() then begin
                    ErrorMessage := StrSubstNo(
                        'Posting date %1 falls in a closed accounting period. Posting is blocked.',
                        Format(PostingDate)
                    );
                    TempMatchBuffer.SetRange("Line Type");
                    exit(false);
                end;
            until TempMatchBuffer.Next() = 0;

        TempMatchBuffer.SetRange("Line Type");
        exit(true);
    end;

    local procedure ApplyMatchToReconciliationLines(
        var TempMatchBuffer: Record "M2M Match Buffer" temporary;
        BankAccountNo: Code[20];
        StatementNo: Code[20]
    )
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        MatchLog: Record "M2M Match Log";
        MatchGroupID: Integer;
        StatementLineCount: Integer;
        LedgerEntryCount: Integer;
        ProcessedReconLines: Dictionary of [Integer, Boolean];
        StatementLineToLedgerSum: Dictionary of [Integer, Decimal];  // Maps Statement Line No. → sum of assigned ledger amounts
        StatementLineToEntriesCount: Dictionary of [Integer, Integer];  // Maps Statement Line No. → count of assigned ledger entries
        StatementLineNo: Integer;
        AssignedStatementLineNo: Integer;
        AppliedEntryCount: Integer;
        AppliedSum: Decimal;
        StatementLineKeys: List of [Integer];
        StatementLineAmounts: Dictionary of [Integer, Decimal];  // Maps Statement Line No. → Statement Amount
        LedgerEntryAmount: Decimal;
        BestMatchLineNo: Integer;
        BestMatchDiff: Decimal;
        CandidateDiff: Decimal;
        CandidateLineNo: Integer;
        CandidateAmount: Decimal;
        KeyIndex: Integer;
    begin
        MatchLog.SetRange("Bank Account No.", BankAccountNo);
        MatchLog.SetRange("Statement No.", StatementNo);
        if MatchLog.FindLast() then
            MatchGroupID := MatchLog."Match Group ID" + 1
        else
            MatchGroupID := 1;

        StatementLineCount := 0;
        LedgerEntryCount := 0;

        // First pass: Build list of statement lines and their amounts
        if TempMatchBuffer.FindSet() then
            repeat
                if TempMatchBuffer."Line Type" = TempMatchBuffer."Line Type"::"Bank Statement Line" then begin
                    StatementLineCount += 1;
                    StatementLineNo := TempMatchBuffer."Recon Line No.";
                    StatementLineKeys.Add(StatementLineNo);
                    if not StatementLineToEntriesCount.ContainsKey(StatementLineNo) then begin
                        StatementLineToEntriesCount.Add(StatementLineNo, 0);
                        StatementLineToLedgerSum.Add(StatementLineNo, 0);
                    end;
                    // Cache each statement line's Statement Amount for matching
                    if BankAccReconLine.Get(
                        BankAccReconLine."Statement Type"::"Bank Reconciliation",
                        BankAccountNo, StatementNo, StatementLineNo
                    ) then
                        StatementLineAmounts.Add(StatementLineNo, BankAccReconLine."Statement Amount");
                end else begin
                    LedgerEntryCount += 1;
                end;
            until TempMatchBuffer.Next() = 0;

        // Third pass: Log all entries in match log
        if TempMatchBuffer.FindSet() then
            repeat
                MatchLog.Init();
                MatchLog."Entry No." := 0;
                MatchLog."Bank Account No." := BankAccountNo;
                MatchLog."Statement No." := StatementNo;
                MatchLog."Match Group ID" := MatchGroupID;
                MatchLog."Currency Code" := TempMatchBuffer."Currency Code";
                MatchLog."Posting Date" := TempMatchBuffer."Posting Date";
                MatchLog."Matched By" := UserId();
                MatchLog."Matched Date-Time" := CurrentDateTime();
                MatchLog.Status := MatchLog.Status::Matched;

                if TempMatchBuffer."Line Type" = TempMatchBuffer."Line Type"::"Bank Statement Line" then begin
                    MatchLog."Line Type" := MatchLog."Line Type"::"Bank Statement Line";
                    MatchLog."Source Line No." := TempMatchBuffer."Recon Line No.";
                end else begin
                    MatchLog."Line Type" := MatchLog."Line Type"::"Ledger Entry";
                    MatchLog."Source Line No." := TempMatchBuffer."Ledger Entry No.";
                end;
                MatchLog.Amount := TempMatchBuffer.Amount;
                MatchLog.Insert(true);
            until TempMatchBuffer.Next() = 0;

        TempMatchBuffer.SetRange("Line Type");

        // Fourth pass: Assign each ledger entry to the best-matching statement line (by amount proximity)
        // and accumulate the applied sum + entry count per statement line.
        // This ensures BC validation: Applied Amount(line) = SUM(Remaining Amount of ledger entries
        // whose Statement Line No. = that line).
        if StatementLineCount = 1 then begin
            // Single statement line: all ledger entries go to it, Applied Amount = ledger total
            AssignedStatementLineNo := StatementLineKeys.Get(1);
            TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Ledger Entry");
            if TempMatchBuffer.FindSet() then
                repeat
                    AppliedEntryCount := StatementLineToEntriesCount.Get(AssignedStatementLineNo);
                    StatementLineToEntriesCount.Set(AssignedStatementLineNo, AppliedEntryCount + 1);
                    AppliedSum := StatementLineToLedgerSum.Get(AssignedStatementLineNo);
                    StatementLineToLedgerSum.Set(AssignedStatementLineNo, AppliedSum + TempMatchBuffer.Amount);
                    ApplyLedgerEntryToStatement(
                        TempMatchBuffer."Ledger Entry No.",
                        BankAccountNo,
                        StatementNo,
                        AssignedStatementLineNo
                    );
                until TempMatchBuffer.Next() = 0;
            TempMatchBuffer.SetRange("Line Type");
        end else begin
            // Multiple statement lines: assign each ledger entry to the statement line
            // whose REMAINING CAPACITY is closest to the ledger entry amount.
            // Remaining capacity = Statement Amount - already-accumulated ledger sum.
            // This prevents duplicate-amount lines from all attracting the same entries:
            // once a line is filled its remaining capacity drops toward 0 (or negative),
            // making it a worse candidate than an unfilled line with the same amount.
            TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Ledger Entry");
            if TempMatchBuffer.FindSet() then
                repeat
                    LedgerEntryAmount := TempMatchBuffer.Amount;
                    BestMatchLineNo := 0;
                    BestMatchDiff := 999999999;

                    // Find the statement line whose remaining capacity best matches this ledger entry
                    for KeyIndex := 1 to StatementLineKeys.Count do begin
                        CandidateLineNo := StatementLineKeys.Get(KeyIndex);
                        if StatementLineAmounts.ContainsKey(CandidateLineNo) then begin
                            CandidateAmount := StatementLineAmounts.Get(CandidateLineNo);
                            // Remaining capacity = Statement Amount - sum already assigned to this line
                            AppliedSum := StatementLineToLedgerSum.Get(CandidateLineNo);
                            CandidateDiff := Abs((CandidateAmount - AppliedSum) - LedgerEntryAmount);
                            if CandidateDiff < BestMatchDiff then begin
                                BestMatchDiff := CandidateDiff;
                                BestMatchLineNo := CandidateLineNo;
                            end;
                        end;
                    end;

                    // Fallback: if no match found, use first statement line
                    if BestMatchLineNo = 0 then
                        BestMatchLineNo := StatementLineKeys.Get(1);

                    // Accumulate ledger amount and count for the chosen statement line
                    AppliedEntryCount := StatementLineToEntriesCount.Get(BestMatchLineNo);
                    StatementLineToEntriesCount.Set(BestMatchLineNo, AppliedEntryCount + 1);
                    AppliedSum := StatementLineToLedgerSum.Get(BestMatchLineNo);
                    StatementLineToLedgerSum.Set(BestMatchLineNo, AppliedSum + LedgerEntryAmount);

                    // Stamp the ledger entry with the chosen statement line
                    ApplyLedgerEntryToStatement(
                        TempMatchBuffer."Ledger Entry No.",
                        BankAccountNo,
                        StatementNo,
                        BestMatchLineNo
                    );
                until TempMatchBuffer.Next() = 0;
            TempMatchBuffer.SetRange("Line Type");
        end;


        // Fifth pass: Update each statement line's Applied Amount = sum of its assigned ledger entries
        // and Applied Entries = count of its assigned ledger entries.
        // This makes BC's posting validation succeed: Applied Amount == sum of entries for that line.
        TempMatchBuffer.SetRange("Line Type", TempMatchBuffer."Line Type"::"Bank Statement Line");
        if TempMatchBuffer.FindSet() then
            repeat
                StatementLineNo := TempMatchBuffer."Recon Line No.";
                if not ProcessedReconLines.ContainsKey(StatementLineNo) then begin
                    if BankAccReconLine.Get(
                        BankAccReconLine."Statement Type"::"Bank Reconciliation",
                        BankAccountNo,
                        StatementNo,
                        StatementLineNo
                    ) then begin
                        if StatementLineToLedgerSum.ContainsKey(StatementLineNo) then
                            BankAccReconLine."Applied Amount" := StatementLineToLedgerSum.Get(StatementLineNo)
                        else
                            BankAccReconLine."Applied Amount" := 0;

                        if StatementLineToEntriesCount.ContainsKey(StatementLineNo) then
                            BankAccReconLine."Applied Entries" := StatementLineToEntriesCount.Get(StatementLineNo)
                        else
                            BankAccReconLine."Applied Entries" := 0;

                        // Difference = Statement Amount - Applied Amount
                        // Must be set explicitly; BC does not auto-calculate this field.
                        BankAccReconLine.Difference :=
                            BankAccReconLine."Statement Amount" - BankAccReconLine."Applied Amount";

                        BankAccReconLine.Modify(true);
                        ProcessedReconLines.Add(StatementLineNo, true);
                    end;
                end;
            until TempMatchBuffer.Next() = 0;

        TempMatchBuffer.SetRange("Line Type");
        Message('Many-to-Many match applied successfully.\Match Group ID: %1\%2 Statement line(s) matched with %3 ledger entry(ies).', MatchGroupID, StatementLineCount, LedgerEntryCount);
    end;

    local procedure ApplyLedgerEntryToStatement(
        LedgerEntryNo: Integer;
        BankAccountNo: Code[20];
        StatementNo: Code[20];
        StatementLineNo: Integer
    )
    var
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        if not BankAccLedgerEntry.Get(LedgerEntryNo) then
            exit;

        BankAccLedgerEntry."Statement No." := StatementNo;
        BankAccLedgerEntry."Statement Line No." := StatementLineNo;
        BankAccLedgerEntry."Statement Status" := BankAccLedgerEntry."Statement Status"::"Bank Acc. Entry Applied";
        BankAccLedgerEntry.Modify(false);
    end;

    local procedure CountMatchedLedgerEntries(MatchGroupID: Integer): Integer
    var
        MatchLog: Record "M2M Match Log";
        Count: Integer;
    begin
        MatchLog.SetRange("Match Group ID", MatchGroupID);
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Ledger Entry");
        Count := MatchLog.Count();
        MatchLog.SetRange("Line Type");
        exit(Count);
    end;

    procedure RemoveMatch(BankAccountNo: Code[20]; StatementNo: Code[20]; MatchGroupID: Integer)
    var
        MatchLog: Record "M2M Match Log";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        MatchLog.SetRange("Bank Account No.", BankAccountNo);
        MatchLog.SetRange("Statement No.", StatementNo);
        MatchLog.SetRange("Match Group ID", MatchGroupID);
        if not MatchLog.FindSet() then
            Error('No match found for Group ID %1.', MatchGroupID);

        MatchLog.SetRange(Status, MatchLog.Status::Posted);
        if not MatchLog.IsEmpty() then
            Error('Cannot remove match group %1: entries have already been posted.', MatchGroupID);
        MatchLog.SetRange(Status);

        // Reset Bank Statement Lines
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Bank Statement Line");
        if MatchLog.FindSet() then
            repeat
                if BankAccReconLine.Get(
                    BankAccReconLine."Statement Type"::"Bank Reconciliation",
                    BankAccountNo, StatementNo, MatchLog."Source Line No."
                ) then begin
                    BankAccReconLine."Applied Amount" := 0;
                    BankAccReconLine."Applied Entries" := 0;
                    // Restore Difference to Statement Amount (fully unmatched state)
                    BankAccReconLine.Difference := BankAccReconLine."Statement Amount";
                    BankAccReconLine.Modify(true);
                end;
            until MatchLog.Next() = 0;

        // Reset Bank Account Ledger Entries back to Open
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Ledger Entry");
        if MatchLog.FindSet() then
            repeat
                if BankAccLedgerEntry.Get(MatchLog."Source Line No.") then begin
                    BankAccLedgerEntry."Statement No." := '';
                    BankAccLedgerEntry."Statement Line No." := 0;
                    BankAccLedgerEntry."Statement Status" := BankAccLedgerEntry."Statement Status"::Open;
                    BankAccLedgerEntry.Modify(false);
                end;
            until MatchLog.Next() = 0;

        MatchLog.SetRange("Line Type");
        MatchLog.DeleteAll(true);
        Message('Match Group %1 has been removed successfully.', MatchGroupID);
    end;

    procedure PostReconciliationMatches(BankAccountNo: Code[20]; StatementNo: Code[20])
    var
        MatchLog: Record "M2M Match Log";
        MatchLogStmt: Record "M2M Match Log";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        MatchedEntryCount: Integer;
        StatementLineNo: Integer;
    begin
        // Update all matched ledger entries with statement info and mark them as applied
        MatchLog.SetRange("Bank Account No.", BankAccountNo);
        MatchLog.SetRange("Statement No.", StatementNo);
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Ledger Entry");
        MatchLog.SetRange(Status, MatchLog.Status::Matched);

        MatchedEntryCount := 0;
        if MatchLog.FindSet() then
            repeat
                if BankAccountLedgerEntry.Get(MatchLog."Source Line No.") then begin
                    // Find the statement line linked to the same match group
                    StatementLineNo := 0;
                    MatchLogStmt.SetRange("Bank Account No.", BankAccountNo);
                    MatchLogStmt.SetRange("Statement No.", StatementNo);
                    MatchLogStmt.SetRange("Match Group ID", MatchLog."Match Group ID");
                    MatchLogStmt.SetRange("Line Type", MatchLogStmt."Line Type"::"Bank Statement Line");
                    if MatchLogStmt.FindFirst() then
                        StatementLineNo := MatchLogStmt."Source Line No.";

                    // Set all three fields required by BC standard reconciliation
                    BankAccountLedgerEntry."Statement No." := StatementNo;
                    BankAccountLedgerEntry."Statement Line No." := StatementLineNo;
                    BankAccountLedgerEntry."Statement Status" := BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied";
                    BankAccountLedgerEntry.Modify(false);

                    // Update match log status to Posted
                    MatchLog.Status := MatchLog.Status::Posted;
                    MatchLog.Modify(false);
                    MatchedEntryCount += 1;
                end;
            until MatchLog.Next() = 0;

        Commit();
        Message('Reconciliation posted successfully. %1 ledger entries have been applied to statement %2.', MatchedEntryCount, StatementNo);
    end;
}
