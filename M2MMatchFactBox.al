page 70204 "M2M Match FactBox"
{
    PageType = ListPart;
    Caption = 'M2M Matched Entries';
    ApplicationArea = All;
    SourceTable = "M2M Match Log";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(MatchLog)
            {
                field("Match Group ID"; Rec."Match Group ID")
                {
                    ApplicationArea = All;
                    Caption = 'Match Group';
                    Width = 10;
                }
                field("Line Type"; Rec."Line Type")
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    Width = 15;
                }
                field("Source Line No."; Rec."Source Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Ref. No.';
                    Width = 10;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    Width = 15;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date';
                    Width = 15;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Width = 12;
                    Style = Favorable;
                    StyleExpr = Rec.Status = Rec.Status::Posted;
                }
                field("Matched By"; Rec."Matched By")
                {
                    ApplicationArea = All;
                    Caption = 'By';
                    Width = 10;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RefreshMatches)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh the matched entries list.';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
