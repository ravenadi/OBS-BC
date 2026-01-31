report 50121 "Item QR New"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'Item QR New';
    RDLCLayout = './src/Layout/ItemQRCodeNew.rdl';
    WordLayout = './src/Layout/ItemQRCodeNew.docx';
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Items';
            column("No"; "No.") { }
            // column(Description; CopyStr(Description, 1, 65)) { }
            column(EncodeStr; EncodeStr) { }
            column(OBSItemName_Item; "OBS Item Name")
            {
            }
            column(cominfoPicture; cominfo.Picture)
            {
            }
            trigger OnAfterGetRecord()
            var
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                QRContent: Text;
            begin
                // QRContent := StrSubstNo('Item: %1, Item: %2', Item."No.", Item.Description);
                // QRContent := StrSubstNo('Item: %1, Item Name: %2', Item."No.", Item."OBS Item Name"); //DCS::HJ20250311
                    QRContent := Item."No.";
                BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                EncodeStr := BarcodeFontProvider2D.EncodeFont(QRContent, BarcodeSymbology2D);
            end;
        }
    }
    trigger OnPreReport()
    var
        myInt: Integer;
    begin
        cominfo.get();
        cominfo.CalcFields(Picture);
    end;

    var
        EncodeStr: Text;
        ItemNo: Code[20];
        ItemName: Text[100];
        cominfo: Record "Company Information";

    procedure AssignItemData(ItemNumber: Code[20]; ItemDescr: text[100])
    begin
        ItemNo := ItemNumber;
        ItemName := ItemDescr;
    end;

}