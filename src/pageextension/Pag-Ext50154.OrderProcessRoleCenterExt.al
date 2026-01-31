pageextension 50154 "Order Process Role Center Ext" extends "Order Processor Role Center"
{
    layout
    {
        addafter("User Tasks Activities")
        {
            part(PurchaseCue; "Purchase order - Open")
            {
                ApplicationArea = all;
                Visible = true;
            }
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
        addafter("Posted Documents")
        {
            group("Vendor")
            {

                Caption = 'Vendor';
                ToolTip = 'Top 10 Vendor List';

                action("Top 10 Vendor")
                {
                    ApplicationArea = All;
                    Caption = 'Top 10 Vendor List';
                    ToolTip = 'View Top 10 Vendor List';
                    Image = Vendor;
                    RunObject = report "Vendor - Top 10 List";
                }
            }
        }
    }
}

