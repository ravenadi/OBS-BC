page 50146 "Alternate Vendor Factbox"
{
    Caption = 'Alternate Vendor for Item';
    PageType = Listpart;
    ApplicationArea = All;
    Editable = false;
    SourceTable = "Item Vendor";

    layout
    {
        area(Content)
        {
            repeater("Alternate Vendors for Item")
            {
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name';
                }
                field(CurrentCostField; TempCurrentCost)
                {
                    ApplicationArea = All;
                    Caption = 'Current Cost';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchasePrice: Record "Price List Line";
    begin
        TempCurrentCost := 0;
        PurchasePrice.SetRange("Source No.", Rec."Vendor No.");
        PurchasePrice.SetRange("Product No.", Rec."Item No.");
        if PurchasePrice.FindLast() then
            TempCurrentCost := PurchasePrice."Direct Unit Cost";
    end;

    var
        TempCurrentCost: Decimal;
}