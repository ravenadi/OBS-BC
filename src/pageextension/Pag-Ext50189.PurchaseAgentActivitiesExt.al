namespace GKBCustomizationsept.GKBCustomizationsept;

using Microsoft.Purchases.RoleCenters;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Requisition;
//DCS::HK 03102025 ++

pageextension 50189 "Purchase Agent Activities Ext" extends "Purchase Agent Activities"
{
    layout
    {
        addafter("Purchase Orders - Authorize for Payment")
        {
            cuegroup("Requisition Status")
            {
                Caption = 'Requisition';

                field("Pending Approval"; Rec."Pending Approval")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Number of open requisitions';
                    DrillDownPageId = "Req. Worksheet";
                }
                field("Rejected"; Rec."Rejected")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Number of requisitions pending approval';
                    DrillDownPageId = "Req. Worksheet";
                }
                field(Released; Rec.Released)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Number of released requisitions';
                    DrillDownPageId = "Req. Worksheet";
                }
            }
            //DCS::HK 06102025 ++
            cuegroup("LowStock")
            {
                // field("Pending Approval2"; Rec."Pending Approval")
                field("Pending Approval2"; CountLowStock())
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Number of open requisitions';
                    Caption = 'Low Stock';
                    // DrillDownPageId = "Req. Worksheet";
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        TempItem: Record Item temporary;
                        Item: Record Item;
                        ItemList: page "Item List";
                    begin
                        Item.SetFilter(Inventory, '>0');
                        Item.SetFilter("Reordering Policy", '%1', Item."Reordering Policy"::"Fixed Reorder Qty."); // Optional
                        Item.SetFilter("Reorder Point", '>0');
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
                }
            }
        }

    }

    local procedure CountLowStock(): Integer
    var
        Item: Record Item;
    // Count: Integer;
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
    //DCS::HK 06102025 ++
    var
        // "Low stock": page "Low Stock";
        count, LSCount : Integer;
}
//DCS::HK 03102025 --