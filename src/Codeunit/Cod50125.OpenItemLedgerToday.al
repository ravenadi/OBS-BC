codeunit 50125 "Open Item Ledger Today"
{
    Subtype = Normal;

    trigger OnRun()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PageItemLedger: Page "Item Ledger Entries";
    begin
        ItemLedgerEntry.SetRange("Posting Date", Today); // Filter for today only
        PageItemLedger.SetTableView(ItemLedgerEntry);
        PageItemLedger.Run();
    end;
}