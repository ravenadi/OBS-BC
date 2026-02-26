page 70202 "M2M Ledger Entries SubPage"
{
    PageType = ListPart;
    Caption = 'Bank Account Ledger Entries';
    ApplicationArea = All;
    SourceTable = "Bank Account Ledger Entry";
    SourceTableView = where("Statement Status" = const(Open));
    MultipleNewLines = false;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(Entries)
            {
                field(Selected; IsSelected)
                {
                    ApplicationArea = All;
                    Caption = 'Select';
                    Editable = true;
                    ToolTip = 'Select this ledger entry for many-to-many matching.';

                    trigger OnValidate()
                    begin
                        UpdateSelection(Rec."Entry No.", IsSelected);
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Amount';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code';
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = All;
                    Caption = 'Statement No.';
                }
                field(MatchGroupID; GetMatchGroupID(Rec."Entry No."))
                {
                    ApplicationArea = All;
                    Caption = 'M2M Match Group';
                    Editable = false;
                    ToolTip = 'Shows the Match Group ID if this entry is part of a many-to-many match.';
                }
            }
        }
    }

    var
        SelectedEntryNos: List of [Integer];
        SelectedAmount: Decimal;
        IsSelected: Boolean;

    procedure SetBankAccountFilter(BankAccountNo: Code[20])
    begin
        Clear(SelectedEntryNos);
        SelectedAmount := 0;
        Rec.SetRange("Bank Account No.", BankAccountNo);
        CurrPage.Update(false);
    end;

    procedure GetSelectedEntryNos(): List of [Integer]
    begin
        exit(SelectedEntryNos);
    end;

    procedure GetSelectedAmount(): Decimal
    begin
        exit(Abs(SelectedAmount));
    end;

    local procedure UpdateSelection(EntryNo: Integer; Selected: Boolean)
    begin
        if Selected then begin
            if not SelectedEntryNos.Contains(EntryNo) then begin
                SelectedEntryNos.Add(EntryNo);
                SelectedAmount += Rec."Remaining Amount";  // Use actual value
            end;
        end else begin
            if SelectedEntryNos.Contains(EntryNo) then begin
                SelectedEntryNos.Remove(EntryNo);
                SelectedAmount -= Rec."Remaining Amount";  // Use actual value
            end;
        end;
    end;

    local procedure GetMatchGroupID(EntryNo: Integer): Integer
    var
        MatchLog: Record "M2M Match Log";
    begin
        MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Ledger Entry");
        MatchLog.SetRange("Source Line No.", EntryNo);
        MatchLog.SetRange(Status, MatchLog.Status::Matched);
        if MatchLog.FindFirst() then
            exit(MatchLog."Match Group ID");
        exit(0);
    end;

    trigger OnAfterGetRecord()
    var
        MatchLog: Record "M2M Match Log";
    begin
        // Check if selected in current session OR already matched in M2M Match Log
        IsSelected := SelectedEntryNos.Contains(Rec."Entry No.");

        if not IsSelected then begin
            // Check if this entry is already matched
            MatchLog.SetRange("Line Type", MatchLog."Line Type"::"Ledger Entry");
            MatchLog.SetRange("Source Line No.", Rec."Entry No.");
            MatchLog.SetRange(Status, MatchLog.Status::Matched);
            IsSelected := not MatchLog.IsEmpty();
        end;
    end;
}
