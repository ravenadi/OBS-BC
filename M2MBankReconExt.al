tableextension 70200 "M2M Bank Recon Ext" extends "Bank Acc. Reconciliation"
{
    trigger OnBeforeDelete()
    var
        MatchingEngine: Codeunit "M2M Matching Engine";
    begin
        // When reconciliation is being deleted (during posting in BC)
        // Apply the matched ledger entries
        MatchingEngine.PostReconciliationMatches(Rec."Bank Account No.", Rec."Statement No.");
    end;
}
