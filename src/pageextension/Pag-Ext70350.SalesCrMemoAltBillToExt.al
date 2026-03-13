pageextension 70350 "Sales CrMemo Alt BillTo Ext" extends "Sales Credit Memo"
{
    layout
    {
        addafter("Bill-to Name")
        {
            field(AltBillToShipToCodeCM; Rec."Alt. Bill-to Ship-to Code")
            {
                ApplicationArea = All;
                Caption = 'Bill-to Code';
                ToolTip = 'Select a Ship-to Address to use as the Bill-to address for this credit memo. The address fields will be updated automatically.';

                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
        }
    }
}