pageextension 50147 "Req. WO Factbox Ext" extends "Req WO FactBox"
{
    layout
    {
        addlast(General)
        {
            field("Inventory"; ItemInventory)
            {
                ApplicationArea = All;
                Caption = 'Inventory';
                Visible = false;
            }
        }
    }

    var
        ItemInventory: Decimal;

    trigger OnAfterGetRecord()
    var
        ItemRec: Record Item;
    begin

        if Rec."No." <> '' then begin

            if ItemRec.Get(Rec."No.") then begin
                ItemInventory := ItemRec.Inventory;
            end else begin
                ItemInventory := 0;
            end;
        end else begin
            ItemInventory := 0;
        end;
    end;
}