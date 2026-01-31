report 50100 "Item_QRCode"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Item QRCodes';
    RDLCLayout = './src/Layout/ItemQRCode.rdl';
    WordLayout = './src/Layout/ItemQRCode.docx';
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Items';
            column("No"; "No.") { }
            column(Description; "OBS Item Name") { }
            column(EncodeStr; EncodeStr) { }
            trigger OnAfterGetRecord()
            var
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                QRContent: Text;
            begin
                // QRContent := StrSubstNo('Item: %1, Description: %2', Item."No.", Item."OBS Item Name"); //DCS::HJ20250311
                QRContent := Item."No.";
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                EncodeStr := BarcodeFontProvider2D.EncodeFont(QRContent, BarcodeSymbology2D);
            end;
        }
    }
    var
        EncodeStr: Text;
        ItemNo: Code[20];
        ItemName: Text[100];

    procedure AssignItemData(ItemNumber: Code[20]; ItemDescr: text[100])
    begin
        ItemNo := ItemNumber;
        ItemName := ItemDescr;
    end;
}