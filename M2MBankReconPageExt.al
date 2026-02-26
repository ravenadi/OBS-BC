pageextension 70200 "M2M Bank Recon Page Ext" extends "Bank Acc. Reconciliation"
{
    actions
    {
        addafter(MatchManually)
        {
            action(ManyToManyMatch)
            {
                ApplicationArea = All;
                Caption = 'M2M Match';
                ToolTip = 'Match multiple Bank Statement Lines against multiple Ledger Entries.';
                Image = Reconcile;
                Scope = Page;

                trigger OnAction()
                begin
                    OpenM2MMatchingPage(Rec."Bank Account No.", Rec."Statement No.");
                    CurrPage.Update(false);
                end;
            }

            action(RemoveM2MMatch)
            {
                ApplicationArea = All;
                Caption = 'Remove M2M Match';
                ToolTip = 'Remove a previously applied Many-to-Many match group (only before posting).';
                Image = Cancel;
                Scope = Page;

                trigger OnAction()
                var
                    M2MRemovePage: Page "M2M Remove Match Page";
                begin
                    M2MRemovePage.SetBankReconciliation(Rec."Bank Account No.", Rec."Statement No.");
                    M2MRemovePage.RunModal();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    local procedure OpenM2MMatchingPage(BankAccountNo: Code[20]; StatementNo: Code[20])
    var
        M2MMatchingPage: Page "M2M Matching Page";
    begin
        M2MMatchingPage.SetBankReconciliation(BankAccountNo, StatementNo);
        M2MMatchingPage.RunModal();
    end;
}
