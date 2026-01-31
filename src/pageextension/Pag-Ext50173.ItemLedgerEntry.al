pageextension 50173 "Item Ledger Entry" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("OBS Product Name"; Rec."OBS Product Name")
            {
                ApplicationArea = All;
                Caption = 'OBS Product Name';
                ToolTip = 'Specifies the OBS product name.';
            }
            field("Warehouse Name"; Rec."Warehouse Name")
            {
                ApplicationArea = All;
                Caption = 'Warehouse Name';
                ToolTip = 'Specifies the name of the warehouse.';
            }
            // field("Work Order No."; Rec."Work Order No.")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Work Order No.';
            //     ToolTip = 'Specifies the work order number associated with the item ledger entry.';
            // }
        }
    }
}
