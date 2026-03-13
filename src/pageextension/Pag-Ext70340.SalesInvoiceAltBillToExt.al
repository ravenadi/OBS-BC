pageextension 70340 "Sales Invoice Alt BillTo Ext" extends "Sales Invoice"
{
    layout
    {
        addafter("Bill-to Name")
        {
            field(AltBillToShipToCodeInv; Rec."Alt. Bill-to Ship-to Code")
            {
                ApplicationArea = All;
                Caption = 'Bill-to Code';
                ToolTip = 'Select a Ship-to Address to use as the Bill-to address for this invoice. The address fields will be updated automatically.';

                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
        }
    }
}