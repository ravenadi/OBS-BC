codeunit 50105 "Milestone Invoicing"
{
    Subtype = Normal;
    Access = Public;


    procedure CreateInvoiceFromBlanketOrder(var BlanketOrderRec: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Header";
        SalesInvoiceLine: Record "Sales Line";
        job: Record Job;
        LineNo: Integer;
        InvoiceDescription: Text;
        TotalAmount: Decimal;
        SalesLine: Record "Sales Line";
        CurrentInvoicePercentage: Decimal;
        BSOInvoiceRec: Record "BSO Invoice Records";
        OpenInvoiceQst: Label 'Sales Invoice %1 created successfully.\\Do you want to open the sales invoice?';
    begin
        if BlanketOrderRec."Percentage To Invoice" <> 0 then begin

            CurrentInvoicePercentage := BlanketOrderRec."Percentage To Invoice";

            SalesInvoiceHeader.Init();
            SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
            SalesInvoiceHeader.Insert(true);

            SalesInvoiceHeader.Validate("Sell-to Customer No.", BlanketOrderRec."Sell-to Customer No.");
            SalesInvoiceHeader."Order Date" := Today;
            //  DCS::HP 20242307 ++ 
            SalesInvoiceHeader."Percentage To Invoice" := BlanketOrderRec."Percentage To Invoice";
            SalesInvoiceHeader."Invoicing Amount" := BlanketOrderRec."Invoicing Amount";
            SalesInvoiceHeader."External Document No." := BlanketOrderRec."External Document No.";
            //  DCS::HP 20242307 --
            SalesInvoiceHeader."Your Reference" := BlanketOrderRec."No.";
            SalesInvoiceHeader."Customer PO Number" := BlanketOrderRec."Customer PO Number";
             BlanketOrderRec.CalcFields("Job No.");
            SalesInvoiceHeader."Blanket Sales Order No." := BlanketOrderRec."Job No.";
            SalesInvoiceHeader."Full Topic" := BlanketOrderRec."Full Topic"; // DCS :: HJ20251029
            // Assign the dimension code AFTER inserting the Sales Invoice Header
            SalesInvoiceHeader.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Shortcut Dimension 1 Code");
            SalesInvoiceHeader.Modify(true);

            // Store the invoice record in BSO Invoice Records table
            BSOInvoiceRec.Init();
            BSOInvoiceRec."Blanket Order No." := BlanketOrderRec."No.";
            BSOInvoiceRec."Invoice No." := SalesInvoiceHeader."No.";
            BSOInvoiceRec."Invoice Date" := SalesInvoiceHeader."Order Date";
            BSOInvoiceRec."Invoiced %" := CurrentInvoicePercentage;
            BSOInvoiceRec.Amount := (BlanketOrderRec.Amount * BlanketOrderRec."Percentage To Invoice") / 100;
            BSOInvoiceRec."Document Type" := BSOInvoiceRec."Document Type"::Invoice;
            BSOInvoiceRec.Insert(true);

            Clear(TotalAmount);
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", BlanketOrderRec."Document Type");
            SalesLine.SetRange("Document No.", BlanketOrderRec."No.");
            if SalesLine.Findfirst() then begin
                LineNo += 10000;
                SalesInvoiceLine.Init();
                SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
                SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
                SalesInvoiceLine."Line No." := LineNo;
                SalesInvoiceLine.Type := SalesInvoiceLine.Type::"G/L Account";
                //  DCS::HP 20242307 ++
                SalesInvoiceLine.validate("No.", '411000');
                SalesInvoiceLine."Shortcut Dimension 1 Code" := SalesInvoiceHeader."Shortcut Dimension 1 Code";
                SalesInvoiceLine."VAT %" := SalesLine."VAT %";
                SalesInvoiceLine."VAT Calculation Type" := SalesLine."VAT Calculation Type";
                SalesInvoiceLine."VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
                SalesInvoiceLine."VAT Identifier" := SalesLine."VAT Identifier";
                //  DCS::HP 20242307 --
                InvoiceDescription := StrSubstNo('Invoice generated with percent %1% ',
                                              BlanketOrderRec."Percentage To Invoice");
                SalesInvoiceLine.Description := InvoiceDescription;
                SalesInvoiceLine.Validate(Quantity, 1);
                BlanketOrderRec.CalcFields(Amount);
                SalesInvoiceLine.Validate("Unit Price", (BlanketOrderRec.Amount * BlanketOrderRec."Percentage To Invoice") / 100);
                TotalAmount += SalesLine.Amount;
                SalesInvoiceLine.Insert(true);
            end;

            BlanketOrderRec."Invoiced Percentage" := BlanketOrderRec."Invoiced Percentage" + CurrentInvoicePercentage;
            BlanketOrderRec."Remaining Percentage" := 100 - BlanketOrderRec."Invoiced Percentage";
            TotalAmount := 0;
            SalesLine.SetRange("Document Type", BlanketOrderRec."Document Type");
            SalesLine.SetRange("Document No.", BlanketOrderRec."No.");
            if SalesLine.FindSet() then begin
                repeat
                    TotalAmount += SalesLine."Amount Including VAT";
                until SalesLine.Next() = 0;
            end;

            BlanketOrderRec."Amount Invoiced" := BlanketOrderRec."Amount Invoiced" + BlanketOrderRec."Invoicing Amount";
            if BlanketOrderRec."Remaining Amount" = 0 then
                BlanketOrderRec."Remaining Amount" := TotalAmount - BlanketOrderRec."Invoicing Amount"
            else
                BlanketOrderRec."Remaining Amount" := BlanketOrderRec."Remaining Amount" - BlanketOrderRec."Invoicing Amount";
            BlanketOrderRec."Percentage To Invoice" := 0;
            BlanketOrderRec."Invoicing Amount" := 0;
            BlanketOrderRec.Modify(true);

            //Pankaj 17OCT2025 ++
            if BlanketOrderRec."Remaining Percentage" = 0 then begin
                job.Reset();
                job.SetRange("Sales Order", BlanketOrderRec."No.");
                if job.FindFirst() then begin
                    job."Invoice Created" := true;
                    job."System Status" := job."System Status"::Invoiced;
                    job.Modify();
                end;
            end;

            if Confirm(OpenInvoiceQst, true, SalesInvoiceHeader."No.") then
                PAGE.Run(PAGE::"Sales Invoice", SalesInvoiceHeader);
        end
        else
            error('Please enter the Percentage To Inovice!!')
    end;
}
