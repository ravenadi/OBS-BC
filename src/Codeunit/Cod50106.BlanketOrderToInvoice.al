codeunit 50106 "Blanket Order To Invoice"
{
    Subtype = Normal;
    Access = Public;




    procedure CreateInvoiceFromBlanketOrder(BlanketOrderRec: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Header";
        SalesInvoiceLine: Record "Sales Line";
        BlanketOrderLine: Record "Sales Line";
        LineNo: Integer;
    begin
        if BlanketOrderRec."Sell-to Customer No." = '' then
            Error('Sell-to Customer No. is not specified in the Blanket Order.');

        SalesInvoiceHeader.Init();
        SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        SalesInvoiceHeader.Validate("Sell-to Customer No.", BlanketOrderRec."Sell-to Customer No.");
        SalesInvoiceHeader."Order Date" := Today;
        SalesInvoiceHeader.Insert(true);

        // Initialize LineNo
        LineNo := 10000;

        BlanketOrderLine.SetRange("Document Type", BlanketOrderRec."Document Type");
        BlanketOrderLine.SetRange("Document No.", BlanketOrderRec."No.");
        if BlanketOrderLine.FindSet() then begin
            repeat
                SalesInvoiceLine.Init();
                SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
                SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
                SalesInvoiceLine."Line No." := LineNo;

                SalesInvoiceLine.Validate("Sell-to Customer No.", SalesInvoiceHeader."Sell-to Customer No.");
                SalesInvoiceLine.Validate(Type, BlanketOrderLine.Type);
                SalesInvoiceLine.Validate("No.", BlanketOrderLine."No.");
                SalesInvoiceLine.Validate(Quantity, BlanketOrderLine.Quantity);
                SalesInvoiceLine.Validate("Unit Price", BlanketOrderLine."Unit Price");
                SalesInvoiceLine.Insert(true);

                // Increment LineNo for next line
                LineNo += 10000;
            until BlanketOrderLine.Next() = 0;
            Message('Sales Invoice created: %1', SalesInvoiceHeader."No.");
        end;
    end;
}