report 50114 "Warehouse Ship Item QRCodes"
{
    // UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    // Caption = 'Item QRCodes';
    RDLCLayout = './src/Layout/WarehouseShipQRCode.rdl';
    // WordLayout = './src/Layout/ItemQRCode.docx';
    dataset
    {
        dataitem("Posted Whse. Shipment Header"; "Posted Whse. Shipment Header")
        {
            RequestFilterFields = "No.";
            dataitem("Posted Whse. Shipment Line"; "Posted Whse. Shipment Line")
            {
                DataItemLink = "No." = field("No.");
                column(Item_No_; "Item No.") { }
                column(Description; Description) { }
                column(EncodeStr; EncodeStr) { }
                trigger OnAfterGetRecord()
                var
                    BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                    QRContent: Text;
                begin
                    QRContent := StrSubstNo('Item: %1, Description: %2', "Posted Whse. Shipment Line"."Item No.", "Posted Whse. Shipment Line".Description);

                    BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                    BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                    EncodeStr := BarcodeFontProvider2D.EncodeFont(QRContent, BarcodeSymbology2D);
                end;
            }
        }
    }
    var
        EncodeStr: Text;
    //     ItemNo: Code[20];
    //     ItemName: Text[100];

    // procedure AssignItemData(ItemNumber: Code[20]; ItemDescr: text[100])
    // begin
    //     ItemNo := ItemNumber;
    //     ItemName := ItemDescr;
    // end;
}