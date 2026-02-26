pageextension 50300 "Warehouse Entries Ext" extends "Warehouse Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("Item Description"; Item.Description)
            {
                ApplicationArea = All;
                Caption = 'Item Description';
            }
        }
    }

    var
        Item: Record Item;

    trigger OnAfterGetRecord()
    begin
        if not Item.Get(Rec."Item No.") then
            Clear(Item);
    end;
}