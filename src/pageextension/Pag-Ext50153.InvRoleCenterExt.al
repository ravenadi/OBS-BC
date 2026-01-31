

pageextension 50153 "Inv Role Center Ext" extends "Whse Ship & Receive Activities"
{
    layout
    {
        addafter("Open Phys. Invt. Orders")
        {
            // field(LowStockCount; CountLowStock())
            // {
            //     Caption = 'Items Below Reorder Point';
            //     ApplicationArea = All;
            //     StyleExpr = 'Attention';
            //     DrillDownPageId = "Item List";
            //     ToolTip = 'Number of items with inventory less than or equal to reorder point.';

            //     trigger OnDrillDown()
            //     var
            //         Item: Record Item;
            //         ItemList: Page "Item List";
            //     begin
            //         Item.Reset();
            //         Item.CalcFields(Inventory);
            //         Item.SetFilter(Inventory, '<=%1', Item."Reorder Point");
            //         Item.SetFilter("Reordering Policy", '<>%1', Item."Reordering Policy"::" ");


            //         if Item.FindSet() then begin
            //             ItemList.SetTableView(Item);
            //             ItemList.Run();
            //         end;
            //     end;
            // }
            field(OpenOrders; CountOpenOrders())
            {
                Caption = 'Open';
                DrillDownPageId = "Purchase Order List";
                ApplicationArea = All;
                ToolTip = 'Number of open purchase orders.';
                StyleExpr = 'Attention';

                trigger OnDrillDown()
                var
                    POList: Page "Purchase Order List";
                    PurchHeader: Record "Purchase Header";
                begin
                    PurchHeader.SetRange(Status, PurchHeader.Status::Open);
                    POList.SetTableView(PurchHeader);
                    POList.Run();
                end;
            }
        }
    }

    // local procedure CountLowStock(): Integer
    // var
    //     Item: Record "Item";
    // begin
    //     Item.SetRange("Low Stock", true);
    //     exit(Item.Count());
    // end;
    // local procedure CountLowStock(): Integer
    // var
    //     Item: Record "Item";
    // begin
    //     Item.Reset();
    //     Item.CalcFields(Inventory);
    //     Item.SetFilter(Inventory, '<=%1', Item."Reorder Point");
    //     Item.SetFilter("Reordering Policy", '<>%1', Item."Reordering Policy"::" ");


    //     if Item.FindSet() then
    //         exit(Item.Count());
    // end;

    local procedure CountOpenOrders(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        exit(PurchHeader.Count());
    end;
}