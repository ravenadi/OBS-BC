pageextension 50139 "Price List Line Ext" extends "Price List Lines"
{
    layout
    {
        // Jathin's code starts here
        modify("Product No.")
        {
            trigger OnAfterValidate()
            var
                Item_lRec: Record Item;
                PriceListHeader: Record "Price List Header";
                GetUnitPrice: Codeunit "Create Order helper";
            begin
                Item_lRec.Reset();
                Item_lRec.SetRange("No.", Rec."Product No.");
                if Item_lRec.FindFirst() then begin
                    PriceListHeader.Reset();
                    PriceListHeader.SetRange(Code, Rec."Price List Code");
                    if PriceListHeader.FindFirst() then begin
                        Rec.Validate("Unit Price", GetUnitPrice.GetPercentageValue(PriceListHeader, Item_lRec));
                        Rec.Modify();
                    end;
                end;
            end;
        }
        // Jathin's code ends here

        addafter(Cost)
        {
            field("Crm Id"; Rec."Crm Id")
            {
                ApplicationArea = all;
            }
        }
    }
}