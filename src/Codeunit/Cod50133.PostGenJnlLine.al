namespace GKBCustomizationsept.GKBCustomizationsept;
using Microsoft.Finance.GeneralLedger.Posting;
using Microsoft.Finance.GeneralLedger.Journal;

codeunit 50133 "Post Gen. Jnl. Line"
{
    procedure PostGenJnlLine(JournalTemplateName: Code[10]; JournalBatchName: Code[10]; LineNo: Integer)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit  "Gen. Jnl.-Post Line";
    begin
        if GenJournalLine.Get(JournalTemplateName, JournalBatchName, LineNo) then begin
            GenJnlPostLine.RunWithCheck(GenJournalLine); // This posts the line to G/L Entry
        end else
            Error('General Journal Line not found.');
    end;
 
}
