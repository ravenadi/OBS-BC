page 70201 "M2M Statement Lines SubPage"
{
    PageType = ListPart;
    Caption = 'Bank Statement Lines';
    ApplicationArea = All;
    SourceTable = "Bank Acc. Reconciliation Line";
    SourceTableView = where("Statement Type" = const("Bank Reconciliation"),
                             "Applied Entries" = const(0));
    MultipleNewLines = false;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Lines)
            {
                field(Selected; IsSelected)
                {
                    ApplicationArea = All;
                    Caption = 'Select';
                    Editable = true;
                    ToolTip = 'Select this line for many-to-many matching.';

                    trigger OnValidate()
                    begin
                        UpdateSelection(Rec."Statement Line No.", IsSelected);
                    end;
                }
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ApplicationArea = All;
                    Caption = 'Transaction Date';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("Statement Amount"; Rec."Statement Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Statement Amount';
                }
                field("Applied Amount"; Rec."Applied Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Applied Amount';

                    trigger OnDrillDown()
                    begin
                        DrillDownAppliedEntries(Rec."Statement Line No.");
                    end;
                }
                field(MatchGroupID; GetMatchGroupID(Rec."Statement Line No."))
                {
                    ApplicationArea = All;
                    Caption = 'M2M Match Group';
                    Editable = false;
                    ToolTip = 'Shows the Match Group ID if this line is part of a many-to-many match.';
                }
            }
        }
    }

    var
        SelectedLineNos: List of [Integer];
        SelectedAmount: Decimal;
        IsSelected: Boolean;
        PageBankAccountNo: Code[20];
        PageStatementNo: Code[20];

    procedure SetBankReconFilter(BankAccountNo: Code[20]; StatementNo: Code[20])
    begin
        Clear(SelectedLineNos);
        SelectedAmount := 0;
        PageBankAccountNo := BankAccountNo;
        PageStatementNo := StatementNo;
        Rec.SetRange("Bank Account No.", BankAccountNo);
        Rec.SetRange("Statement No.", StatementNo);
        CurrPage.Update(false);
    end;

    procedure GetSelectedLineNos(): List of [Integer]
    begin
        exit(SelectedLineNos);
    end;

    procedure GetSelectedAmount(): Decimal
    begin
        exit(Abs(SelectedAmount));  // Return absolute value for comparison
    end;

    procedure GetCurrentMatchGroupID(): Integer
    begin
        // Return the match group ID for the currently selected/active record
        if Rec."Applied Amount" <> 0 then
            exit(GetMatchGroupID(Rec."Statement Line No."))
        else
            exit(0);
    end;

    local procedure UpdateSelection(LineNo: Integer; Selected: Boolean)
    begin
        if Selected then begin
            if not SelectedLineNos.Contains(LineNo) then begin
                SelectedLineNos.Add(LineNo);
                SelectedAmount += Rec."Statement Amount";
            end;
        end else begin
            if SelectedLineNos.Contains(LineNo) then begin
                SelectedLineNos.Remove(LineNo);
                SelectedAmount -= Rec."Statement Amount";
            end;
        end;
    end;

    local procedure GetMatchGroupID(LineNo: Integer): Integer
    var
        MatchLog: Record "M2M Match Log";
    begin
        MatchLog.SetRange("Bank Account No.", PageBankAccountNo);
        MatchLog.SetRange("Statement No.", PageStatementNo);
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Bank Statement Line");
        MatchLog.SetRange("Source Line No.", LineNo);
        MatchLog.SetRange(Status, MatchLog.Status::Matched);
        if MatchLog.FindFirst() then
            exit(MatchLog."Match Group ID");
        exit(0);
    end;

    local procedure DrillDownAppliedEntries(StatementLineNo: Integer)
    var
        MatchLog: Record "M2M Match Log";
        MatchGroupID: Integer;
        AppliedEntriesPage: Page "M2M Applied Entries";
        LedgerEntryCount: Integer;
    begin
        // Get the match group for this statement line, scoped to this reconciliation
        MatchLog.SetRange("Bank Account No.", PageBankAccountNo);
        MatchLog.SetRange("Statement No.", PageStatementNo);
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Bank Statement Line");
        MatchLog.SetRange("Source Line No.", StatementLineNo);
        MatchLog.SetRange(Status, MatchLog.Status::Matched);
        if MatchLog.FindFirst() then begin
            MatchGroupID := MatchLog."Match Group ID";

            // Count ledger entries in this group
            MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Ledger Entry");
            MatchLog.SetRange("Match Group ID", MatchGroupID);
            LedgerEntryCount := MatchLog.Count();

            if LedgerEntryCount = 0 then begin
                Message('Warning: This statement line is marked as applied, but no ledger entries are matched to it. Match Group ID: %1', MatchGroupID);
                exit;
            end;

            AppliedEntriesPage.SetMatchGroup(MatchGroupID);
            AppliedEntriesPage.RunModal();
        end else
            Message('No match record found for this statement line. Please apply a match first.');
    end;

    trigger OnAfterGetRecord()
    var
        MatchLog: Record "M2M Match Log";
    begin
        // Check if selected in current session OR already matched in M2M Match Log
        IsSelected := SelectedLineNos.Contains(Rec."Statement Line No.");

        if not IsSelected then begin
            // Check if this line is already matched (scoped to this reconciliation)
            MatchLog.SetRange("Bank Account No.", PageBankAccountNo);
            MatchLog.SetRange("Statement No.", PageStatementNo);
            MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Bank Statement Line");
            MatchLog.SetRange("Source Line No.", Rec."Statement Line No.");
            MatchLog.SetRange(Status, MatchLog.Status::Matched);
            IsSelected := not MatchLog.IsEmpty();
        end;
    end;
}
