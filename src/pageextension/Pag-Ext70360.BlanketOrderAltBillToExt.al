pageextension 70360 "Blanket Order Alt BillTo Ext" extends "Blanket Sales Order"
{
    layout
    {
        addafter("Bill-to Name")
        {
            field(AltBillToShipToCode; Rec."Alt. Bill-to Ship-to Code")
            {
                ApplicationArea = All;
                Caption = 'Bill-to code';
                ToolTip = 'Select a Ship-to Address to use as the Bill-to address for this order. The address fields will be updated automatically.';

                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
        }
    }
}