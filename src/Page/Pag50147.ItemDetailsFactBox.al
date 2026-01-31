page 50147 "Item Details Fact Box"
{
    Caption = 'Item Details';
    PageType = CardPart;
    SourceTable = "Purchase Line";
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(ItemDetails)
            {
                Caption = 'Item Details';

                field(ItemNo; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the item number for the purchase line.';
                }

                field(ItemDescription; ItemDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Item Description';
                    ToolTip = 'Specifies the description of the item.';
                }

                field(ItemAvailability; ItemAvailability)
                {
                    ApplicationArea = All;
                    Caption = 'Item Availability';
                    ToolTip = 'Specifies the available quantity of the item at the selected location.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
        ItemDetailsMgt: Codeunit "Item FactBox Management";
    begin
        Clear(ItemDescription);
        Clear(ItemAvailability);

        if Item.Get(Rec."No.") then begin
            ItemDescription := Item.Description;
            ItemAvailability := ItemDetailsMgt.GetItemAvailability(Rec."No.", Rec."Location Code");
        end;
    end;

    var
        ItemDescription: Text[100];
        ItemAvailability: Decimal;
}