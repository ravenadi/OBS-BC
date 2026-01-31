report 50112 "Purch Receipt Item QR Codes"
{
    Caption = 'Purch Receipt Item QR Codes';
    ApplicationArea = All;
    WordLayout = 'Purchase QR.docx';
    RDLCLayout = './src/Layout/Purch Receipt Item QR Codes.rdl';
    DefaultLayout = Word;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("PurchRcptLine"; "Purch. Rcpt. Line")
        {
            column("LineNo"; "Line No.") { }
            column("ItemNo"; "No.") { }
            column("Description"; "Description") { }
            column(QRCodeText; EncodeStr) { }

            trigger OnAfterGetRecord()
            var
                BarcodeSymbology2D: Enum "Barcode Symbology 2D";
                BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
                QRContent: Text;
                PurchRcptLine: Record "Purch. Rcpt. Line";
                PurchRcptHeader: Record "Purch. Rcpt. Header";
            begin
                PurchRcptLine.get("Document No.", PurchRcptHeader."No.");
                PurchRcptLine.SetCurrentKey("No.");
                if PurchRcptLine.FindSet() then begin
                    repeat
                        QRContent := StrSubstNo('Item: %1, Description: %2', "No.", Description);

                        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
                        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
                        EncodeStr := BarcodeFontProvider2D.EncodeFont(QRContent, BarcodeSymbology2D);
                    until PurchRcptLine.Next() = 0;
                end;
            end;
        }

    }
    var
        EncodeStr: Text;
}
