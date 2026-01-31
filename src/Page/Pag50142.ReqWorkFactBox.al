

page 50142 "Req Work FactBox"
{
    ApplicationArea = All;
    Caption = 'Purchase Request Details';
    PageType = CardPart;
    SourceTable = "item";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    Caption = 'Qty On Purchase Order';
                    ToolTip = 'Specifies the number of the available purchase orders.';
                }
                field(Inventory; Rec.Inventory)
                {
                    Caption = 'Inventory';
                    ToolTip = 'Speccifies the number of the Inventory List';
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    Caption = 'Qty On Sales Order';
                    ToolTip = 'Specifies the number of the available purchase orders.';
                }
            }
        }
    }
}