codeunit 50118 "Item FactBox Management"
{
    procedure GetItemAvailability(ItemNo: Code[20]; LocationCode: Code[10]): Decimal
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if not Item.Get(ItemNo) then
            exit(0);

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Location Code", LocationCode);
        ItemLedgerEntry.CalcSums("Remaining Quantity");

        exit(ItemLedgerEntry."Remaining Quantity");
    end;
}