pageextension 50172 "Whse. Basic Role Center Ext" extends "Whse. Basic Role Center"
{
    layout
    {
        addafter("User Tasks Activities")
        {
            part(StockCue; "Low Stock")
            {
                ApplicationArea = All;
                Caption = 'Low Stock';
                Visible = true;
            }
        }
    }
    actions
    {
        addlast(sections)
        {
            group("Inventory")
            {

                Caption = 'Inventory';
                ToolTip = 'Inventory related actions.';

                action("Item Used")
                {
                    ApplicationArea = All;
                    Caption = 'Item Used';
                    ToolTip = 'View items with Item Used levels.';
                    Image = Inventory;
                    RunObject = codeunit "Open Item Ledger Today";
                }
                action("Item Purchased")
                {
                    ApplicationArea = All;
                    Caption = 'Item Purchased';
                    ToolTip = 'View items with Item Purchased levels.';
                    Image = Inventory;
                    RunObject = page "Item Ledger Entries";
                    RunPageLink = "Entry Type" = filter('Purchase');
                }
                action("Item adjustments")
                {
                    ApplicationArea = All;
                    Caption = 'Item adjustments';
                    ToolTip = 'View items with Item adjustments levels.';
                    Image = Inventory;
                    RunObject = page "Item Ledger Entries";
                    RunPageLink = "Entry Type" = filter('Positive Adjmt.|Negative Adjmt.');
                }
                // action("ILE In stock")
                // {
                //     ApplicationArea = All;
                //     Caption = 'ILE In stock';
                //     ToolTip = 'View items with Item In stock item  levels.';
                //     Image = Inventory;
                //     RunObject = page "Item Ledger Entries";
                //     RunPageLink = Quantity = filter(> 0);
                // }
                action("Item Report")
                {
                    ApplicationArea = All;
                    Caption = 'Item report';
                    ToolTip = 'View items with Item report levels.';
                    Image = Inventory;
                    RunObject = codeunit "Email Attachment Custom";
                }
                action("Item In stock ")
                {
                    ApplicationArea = All;
                    Caption = 'Item In stock';
                    ToolTip = 'View items with Item In stock item  levels.';
                    Image = Inventory;
                    RunObject = page "Item List";
                    RunPageLink = Inventory = filter(> 0);
                }
                action("Inventory Valuation")
                {
                    ApplicationArea = All;
                    Caption = 'Inventory Turnover';
                    ToolTip = 'View items with Item Purchased levels.';
                    Image = Inventory;
                    RunObject = report "Inventory Valuation";
                    // RunPageLink = "Entry Type" = filter('Purchase');
                }
                action("Latest Item Purchased")
                {
                    ApplicationArea = All;
                    Caption = 'Last Receipt Items';
                    ToolTip = 'View items with Item Purchased levels.';
                    Image = Inventory;
                    RunObject = page "Item Ledger Entries";
                    RunPageLink = "Entry Type" = filter('Purchase');
                }

            }
        }
    }
}

