page 70203 "M2M Remove Match Page"
{
    PageType = List;
    Caption = 'Remove Many-to-Many Match Group';
    ApplicationArea = All;
    SourceTable = "M2M Match Log";
    SourceTableView = where(Status = const(Matched));
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(MatchGroups)
            {
                field("Match Group ID"; Rec."Match Group ID")
                {
                    ApplicationArea = All;
                    Caption = 'Match Group ID';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    Caption = 'Line Type';
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Source Line No.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                }
                field("Matched By"; Rec."Matched By")
                {
                    ApplicationArea = All;
                    Caption = 'Matched By';
                }
                field("Matched Date-Time"; Rec."Matched Date-Time")
                {
                    ApplicationArea = All;
                    Caption = 'Matched Date-Time';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RemoveSelectedGroup)
            {
                ApplicationArea = All;
                Caption = 'Remove Selected Match Group';
                Image = Cancel;
                ToolTip = 'Remove the match group for the selected line.';

                trigger OnAction()
                var
                    MatchingEngine: Codeunit "M2M Matching Engine";
                begin
                    if Rec."Entry No." = 0 then
                        Error('Please select a match log line first.');
                    if Confirm('Remove match group %1? This action cannot be undone.', false, Rec."Match Group ID") then begin
                        MatchingEngine.RemoveMatch(Rec."Bank Account No.", Rec."Statement No.", Rec."Match Group ID");
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        BankAccountNo: Code[20];
        StatementNo: Code[20];

    procedure SetBankReconciliation(NewBankAccountNo: Code[20]; NewStatementNo: Code[20])
    begin
        BankAccountNo := NewBankAccountNo;
        StatementNo := NewStatementNo;
        Rec.SetRange("Bank Account No.", BankAccountNo);
        Rec.SetRange("Statement No.", StatementNo);
        CurrPage.Update(false);
    end;
}
