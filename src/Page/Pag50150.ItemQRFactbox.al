page 50150 "Item QR Factbox"
{
    PageType = CardPart;
    SourceTable = Item;
    Caption = 'Item QR Code';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(QRCode; Rec.QRCode)
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Shows QR code for the item';
            }
        }
    }
}