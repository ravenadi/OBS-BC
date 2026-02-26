codeunit 70202 "M2M Test Scenarios"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure TestBalancedAmountsPassValidation()
    var
        MatchingEngine: Codeunit "M2M Matching Engine";
        TempBuffer: Record "M2M Match Buffer" temporary;
        ErrorMessage: Text;
        Result: Boolean;
    begin
        AddBufferLine(TempBuffer, 1, TempBuffer."Line Type"::"Bank Statement Line", 600, 'GBP', Today());
        AddBufferLine(TempBuffer, 2, TempBuffer."Line Type"::"Bank Statement Line", 400, 'GBP', Today());
        AddBufferLine(TempBuffer, 3, TempBuffer."Line Type"::"Ledger Entry", 300, 'GBP', Today());
        AddBufferLine(TempBuffer, 4, TempBuffer."Line Type"::"Ledger Entry", 450, 'GBP', Today());
        AddBufferLine(TempBuffer, 5, TempBuffer."Line Type"::"Ledger Entry", 250, 'GBP', Today());
        Result := MatchingEngine.ValidateMatchBuffer(TempBuffer, '', ErrorMessage);
        if not Result then
            Error('Test FAILED - balanced amounts should pass. Error: %1', ErrorMessage);
    end;

    [Test]
    procedure TestImbalancedAmountsBlockValidation()
    var
        MatchingEngine: Codeunit "M2M Matching Engine";
        TempBuffer: Record "M2M Match Buffer" temporary;
        ErrorMessage: Text;
        Result: Boolean;
    begin
        AddBufferLine(TempBuffer, 1, TempBuffer."Line Type"::"Bank Statement Line", 1000, 'GBP', Today());
        AddBufferLine(TempBuffer, 2, TempBuffer."Line Type"::"Ledger Entry", 900, 'GBP', Today());
        Result := MatchingEngine.ValidateMatchBuffer(TempBuffer, '', ErrorMessage);
        if Result then
            Error('Test FAILED - imbalanced amounts should block validation.');
    end;

    [Test]
    procedure TestMixedCurrenciesBlockValidation()
    var
        MatchingEngine: Codeunit "M2M Matching Engine";
        TempBuffer: Record "M2M Match Buffer" temporary;
        ErrorMessage: Text;
        Result: Boolean;
    begin
        AddBufferLine(TempBuffer, 1, TempBuffer."Line Type"::"Bank Statement Line", 1000, 'GBP', Today());
        AddBufferLine(TempBuffer, 2, TempBuffer."Line Type"::"Ledger Entry", 1000, 'USD', Today());
        Result := MatchingEngine.ValidateMatchBuffer(TempBuffer, '', ErrorMessage);
        if Result then
            Error('Test FAILED - mixed currencies should block validation.');
    end;

    [Test]
    procedure TestMissingStatementLinesBlockValidation()
    var
        MatchingEngine: Codeunit "M2M Matching Engine";
        TempBuffer: Record "M2M Match Buffer" temporary;
        ErrorMessage: Text;
        Result: Boolean;
    begin
        AddBufferLine(TempBuffer, 1, TempBuffer."Line Type"::"Ledger Entry", 1000, 'GBP', Today());
        Result := MatchingEngine.ValidateMatchBuffer(TempBuffer, '', ErrorMessage);
        if Result then
            Error('Test FAILED - missing statement lines should block validation.');
    end;

    local procedure AddBufferLine(
        var TempBuffer: Record "M2M Match Buffer" temporary;
        EntryNo: Integer;
        LineType: Option;
        Amount: Decimal;
        CurrencyCode: Code[10];
        PostingDate: Date
    )
    begin
        TempBuffer.Init();
        TempBuffer."Entry No." := EntryNo;
        TempBuffer."Line Type" := LineType;
        TempBuffer.Amount := Amount;
        TempBuffer."Currency Code" := CurrencyCode;
        TempBuffer."Posting Date" := PostingDate;
        TempBuffer.Insert();
    end;
}
