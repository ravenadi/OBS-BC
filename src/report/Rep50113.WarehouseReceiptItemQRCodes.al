report 50113 "Warehouse Receipt Item QRCodes"
{
    // UsageCategory = ReportsAndAnalysis;
    // ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/Layout/WarehouseQRCode.rdl';
    // WordLayout = './src/Layout/ItemQRCode.docx';
    dataset
    {
        dataitem("Posted Whse. Receipt Header"; "Posted Whse. Receipt Header")
        {
            RequestFilterFields = "No.";
            dataitem("Posted Whse. Receipt Line"; "Posted Whse. Receipt Line")
            {
                DataItemLink = "No." = field("No.");
                column(Item_No_; "Item No.") { }
                column(Description; description) { }
                column(EncodeStr; EncodeStr) { }
                column(cominfoPicture; cominfo.Picture)
                {
                }
                trigger OnAfterGetRecord()
                var
                    BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                    BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                    QRContent: Text;

                begin
                    // QRContent := StrSubstNo('Item: %1, Description: %2', "Posted Whse. Receipt Line"."Item No.", "Posted Whse. Receipt Line".Description);
                    QRContent := "Item No.";
                    BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                    BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                    EncodeStr := BarcodeFontProvider2D.EncodeFont(QRContent, BarcodeSymbology2D);
                end;
            }
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
        cominfo: Record "Company Information";



}

