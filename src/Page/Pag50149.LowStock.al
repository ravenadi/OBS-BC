page 50149 "Low Stock"
{
    PageType = CardPart;
    SourceTable = Item;
    RefreshOnActivate = true;
    ApplicationArea = All;
 
    layout
    {
        area(content)
        {
            cuegroup(LowStockGroup)
            {
                Caption = 'Low Stock';
 
                field(LowStock; CountLowStock())
                {
                    Caption = 'Below Reorder Point';
                    DrillDown = true;
                    ToolTip = 'Number of items with inventory less than or equal to reorder point.';
                    Style = Attention;
                    StyleExpr = true;
 
                    // DCS::HP 08082025 ++
                    // trigger OnDrillDown()
                    // var
                    //     Item: Record Item;
                    //     ItemList: Page "Item List";
                    // begin
                    //     Item.Reset();
                    //     Item.CalcFields(Inventory);
                    //     Item.SetFilter(Inventory, '<=%1', Item."Reorder Point");
                    //     Item.SetFilter("Reordering Policy", '<>%1', Item."Reordering Policy"::" ");
 
                    //     if Item.FindSet() then begin
                    //         ItemList.SetTableView(Item);
                    //         ItemList.Run();
                    //     end;
                    // end;
                    trigger OnDrillDown()
                    var
                        TempItem: Record Item temporary;
                        Item: Record Item;
                        ItemList: page "Item List";
                    begin
                        // Item.Reset();
                        // if Item.FindSet() then
                        //     repeat
                        //         Item.CalcFields(Inventory);
                        //         if (Item."Reorder Point" > 0) and (Item.Inventory <= Item."Reorder Point") then begin
                        //             TempItem := Item;
                        //             TempItem.Insert();
                        //         end;
                        //     until Item.Next() = 0;
 
                        // LowStockList.LoadLowStockItems(TempItem);
                        // LowStockList.Run();
                        Item.SetFilter(Inventory, '>0');
                        Item.SetFilter("Reordering Policy", '%1', Item."Reordering Policy"::"Fixed Reorder Qty."); // Optional
                        Item.SetFilter("Reorder Point", '>0');
                        // Item.SetFilter(Inventory, '<=%1', Item."Reorder Point"); // Inventory <= Reorder Point
 
                        if Item.FindSet() then
                            repeat
                                Item.CalcFields(Inventory);
                                if (Item."Reorder Point" > 0) and (Item.Inventory <= Item."Reorder Point") then begin
                                    TempItem := Item;
                                    TempItem.Insert();
                                end;
                            until Item.Next() = 0;
                        Page.Run(Page::"Item List", TempItem);
                    end;
 
                    // DCS::HP 08082025 --
                }
            }
        }
    }
 
    // local procedure CountLowStock(): Integer
    // var
    //     Item: Record "Item";
    // begin
    //     Item.Reset();
    //     Item.SetRange("Low Stock", true);
    //     exit(Item.Count());
    // end;
 
    // DCS::HP 08082025 ++
    // local procedure CountLowStock(): Integer
    // var
    //     Item: Record "Item";
    // begin
    //     Item.Reset();
    //     Item.CalcFields(Inventory);
    //     Item.SetFilter(Inventory, '<=%1', Item."Reorder Point");
    //     Item.SetFilter("Reordering Policy", '<>%1', Item."Reordering Policy"::" ");
    //     // Item.SetFilter("Reorder Point", '<>%1', 0);
    //     if Item.FindSet() then
    //         exit(Item.Count());
    // end;
    local procedure CountLowStock(): Integer
    var
        Item: Record Item;
        Count: Integer;
    begin
        Count := 0;
        Item.Reset();
        Item.SetFilter(Inventory, '>0');
        Item.SetFilter("Reordering Policy", '%1', Item."Reordering Policy"::"Fixed Reorder Qty."); // Optional if needed
        if Item.FindSet() then
            repeat
                Item.CalcFields(Inventory);
                if (Item."Reorder Point" > 0) and (Item.Inventory <= Item."Reorder Point") then
                    Count += 1;
            until Item.Next() = 0;
 
        exit(Count);
    end;
    // DCS::HP 08082025 --
}