page 70205 "M2M Applied Entries"
{
    PageType = List;
    Caption = 'Applied Ledger Entries';
    ApplicationArea = All;
    SourceTable = "M2M Match Log";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(AppliedEntries)
            {
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code';
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
            }
        }
    }

    var
        CurrentMatchGroupID: Integer;

    procedure SetMatchGroup(MatchGroupID: Integer)
    begin
        CurrentMatchGroupID := MatchGroupID;
        Rec.SetRange("Match Group ID", MatchGroupID);
        Rec.SetRange("Line Type", Rec."Line Type"::"Ledger Entry");
        Rec.SetRange(Status, Rec.Status::Matched);
        CurrPage.Update(false);
    end;
}
