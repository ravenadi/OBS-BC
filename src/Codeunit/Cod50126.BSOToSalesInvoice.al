codeunit 50126 "BSO To Sales Invoice"
{
    Subtype = Normal;
    Access = Public;
    trigger OnRun()
    var
    begin
        ProcessBlanketOrdersForInvoicing();
    end;

    procedure ProcessBlanketOrdersForInvoicing()
    var
        BlanketOrderRec: Record "Sales Header";
        TodayDate: Date;
        GenerateInvoice: Boolean;
        NextInvoiceDate: Date;
    begin
        TodayDate := Today;

        // Lock the table to prevent race conditions
        BlanketOrderRec.LockTable();

        BlanketOrderRec.SetRange("Document Type", BlanketOrderRec."Document Type"::"Blanket Order");

        if BlanketOrderRec.FindSet() then
            repeat
                // DCs::HP 20252307 ++ Added below logic
                // Gkblabs_Tv_19/01/26
                if (BlanketOrderRec."Last Invoice Created Date" = 0D) then begin
                    // If an Invoice Date is specified and it's within Start/End and Today is on/after the Invoice Date,
                    // create the initial invoice immediately instead of waiting for the first frequency interval.
                    if (BlanketOrderRec."Invoice Date" <> 0D) and
                       (BlanketOrderRec."Invoice Date" >= BlanketOrderRec."Start Date") and
                       (BlanketOrderRec."Invoice Date" <= BlanketOrderRec."End Date") and
                       (TodayDate >= BlanketOrderRec."Invoice Date") then begin
                        if not ISAnyErrorValidation(BlanketOrderRec) then begin
                            CreateInvoiceFromBlanketOrder(BlanketOrderRec);
                            BlanketOrderRec."Last Invoice Created Date" := TodayDate;
                            BlanketOrderRec.Modify(true);
                        end else
                            // If validation failed, fall back to initializing Last Invoice Created Date to Start Date
                            BlanketOrderRec."Last Invoice Created Date" := BlanketOrderRec."Start Date";
                    end else
                        // Default behaviour: initialize Last Invoice Created Date to Start Date
                        BlanketOrderRec."Last Invoice Created Date" := BlanketOrderRec."Start Date";
                end;
                //Gkblabs_Tv_19/01/26
                // DCs::HP 20252307 --

                if (BlanketOrderRec."Start Date" <> 0D) and
                   (BlanketOrderRec."End Date" <> 0D) and
                   (BlanketOrderRec."Last Invoice Created Date" <> 0D) and
                   (BlanketOrderRec."Last Invoice Created Date" >= BlanketOrderRec."Start Date") and
                   (BlanketOrderRec."Last Invoice Created Date" <= BlanketOrderRec."End Date") and
                   (TodayDate <= BlanketOrderRec."End Date") // Additional check: don't generate if past end date
                then begin
                    GenerateInvoice := false;
                    NextInvoiceDate := 0D;

                    // Check invoice frequency - calculate next invoice date and compare exactly
                    case BlanketOrderRec."Invoice Frequency" of
                        BlanketOrderRec."Invoice Frequency"::Monthly:
                            NextInvoiceDate := CalcDate('+1M', BlanketOrderRec."Last Invoice Created Date");
                        BlanketOrderRec."Invoice Frequency"::Weekly:
                            NextInvoiceDate := CalcDate('+1W', BlanketOrderRec."Last Invoice Created Date");
                        BlanketOrderRec."Invoice Frequency"::"Bi-weekly":
                            NextInvoiceDate := CalcDate('+2W', BlanketOrderRec."Last Invoice Created Date");
                        BlanketOrderRec."Invoice Frequency"::Quarterly:
                            NextInvoiceDate := CalcDate('+3M', BlanketOrderRec."Last Invoice Created Date");
                        BlanketOrderRec."Invoice Frequency"::"Semi-annually":
                            NextInvoiceDate := CalcDate('+6M', BlanketOrderRec."Last Invoice Created Date");
                    end;

                    // Generate invoice if today is on or after the next invoice date (tolerate missed runs)
                    if (NextInvoiceDate <> 0D) and (TodayDate >= NextInvoiceDate) then
                        GenerateInvoice := true;

                    if GenerateInvoice then begin
                        if not ISAnyErrorValidation(BlanketOrderRec) then begin
                            // Call your invoice creation
                            CreateInvoiceFromBlanketOrder(BlanketOrderRec);

                            // Update the Last Invoice Created Date only after successful creation
                            BlanketOrderRec."Last Invoice Created Date" := TodayDate;
                            BlanketOrderRec.Modify(true);


                        end;
                        // Optional: Send email
                    end;
                end;
            until BlanketOrderRec.Next() = 0;
    end;



    // procedure CreateInvoiceFromBlanketOrder(var BlanketOrderRec: Record "Sales Header")
    // var
    //     SalesInvoiceHeader: Record "Sales Header"; 
    //     SalesInvoiceLine: Record "Sales Line";
    //     job: Record Job;
    //     LineNo: Integer;
    //     InvoiceDescription: Text;
    //     TotalAmount: Decimal;
    //     SalesLine: Record "Sales Line";
    //     CurrentInvoicePercentage: Decimal;
    //     itemRec: record item;
    // begin

    //     SalesInvoiceHeader.Init();
    //     SalesInvoiceHeader."Check Boolean" := false;
    //     SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
    //     SalesInvoiceHeader.Insert(true);

    //     SalesInvoiceHeader.Validate("Sell-to Customer No.", BlanketOrderRec."Sell-to Customer No.");
    //     SalesInvoiceHeader."Order Date" := Today;
    //     SalesInvoiceHeader."Your Reference" := BlanketOrderRec."No.";
    //     SalesInvoiceHeader."External Document No." := BlanketOrderRec."External Document No.";
    //     SalesInvoiceHeader."Customer PO Number" := BlanketOrderRec."Customer PO Number";
    //     SalesInvoiceHeader."Blanket Sales Order No." := BlanketOrderRec."No.";

    //     // Assign the dimension code AFTER inserting the Sales Invoice Header
    //     SalesInvoiceHeader.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Shortcut Dimension 1 Code");
    //     SalesInvoiceHeader.Modify(true);
    //     Clear(TotalAmount);
    //     SalesLine.Reset();
    //     SalesLine.SetRange("Document Type", BlanketOrderRec."Document Type");
    //     SalesLine.SetRange("Document No.", BlanketOrderRec."No.");
    //     if SalesLine.FindSet() then
    //         repeat
    //             TotalAmount += (SalesLine.Quantity * SalesLine."Unit Price")
    //         until SalesLine.Next() = 0;
    //     LineNo += 10000;
    //     SalesInvoiceLine.Init();
    //     SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
    //     SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
    //     SalesInvoiceLine."Line No." := LineNo;
    //     SalesInvoiceLine.Type := SalesInvoiceLine.Type::Item;
    //     // DCS::HP 22082025 ++
    //     SalesInvoiceLine.validate("No.", 'NI10066');
    //     itemRec.SetRange("No.", SalesInvoiceLine."No.");
    //     if itemRec.FindFirst() then
    //         SalesInvoiceLine.validate("VAT Prod. Posting Group", itemRec."VAT Prod. Posting Group");
    //     SalesInvoiceLine.validate("VAT %", SalesLine."VAT %");
    //     SalesInvoiceLine.validate("VAT Calculation Type", SalesLine."VAT Calculation Type");
    //     SalesInvoiceLine.validate("VAT Identifier", SalesLine."VAT Identifier");
    //     // SalesInvoiceLine.Validate("No.", SalesLine."No.");
    //     SalesInvoiceLine.Validate(Quantity, 1);

    //     SalesInvoiceLine.Validate("Unit Price", TotalAmount);
    //     SalesInvoiceHeader."Check Boolean" := true;
    //     // DCS::HP 22082025 --
    //     SalesInvoiceLine.Insert(true);
    // end;

    // procedure CreateInvoiceFromBlanketOrder(var BlanketOrderRec: Record "Sales Header")
    // var
    //     SalesInvoiceHeader: Record "Sales Header";
    //     SalesInvoiceLine: Record "Sales Line";
    //     SalesLine: Record "Sales Line";
    //     ItemRec: Record Item;
    //     LineNo: Integer;
    //     i: Integer;
    //     AgreementPercents: array[3] of Decimal;
    // begin
    //     SalesInvoiceHeader.Init();
    //     SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
    //     SalesInvoiceHeader.Insert(true);
    //     SalesInvoiceHeader.Validate("Sell-to Customer No.", BlanketOrderRec."Sell-to Customer No.");
    //     SalesInvoiceHeader."Order Date" := Today;
    //     SalesInvoiceHeader."Your Reference" := BlanketOrderRec."No.";
    //     SalesInvoiceHeader."External Document No." := BlanketOrderRec."External Document No.";
    //     SalesInvoiceHeader."Customer PO Number" := BlanketOrderRec."Customer PO Number";
    //     SalesInvoiceHeader."Blanket Sales Order No." := BlanketOrderRec."No.";
    //     SalesInvoiceHeader."Check Boolean" := false;
    //     SalesInvoiceHeader.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Shortcut Dimension 1 Code");
    //     SalesInvoiceHeader.Modify(true);
    //     AgreementPercents[1] := BlanketOrderRec."Agreement % 1";
    //     AgreementPercents[2] := BlanketOrderRec."Agreement % 2";
    //     AgreementPercents[3] := BlanketOrderRec."Agreement % 3";
    //     LineNo := 0;
    //     SalesLine.Reset();
    //     SalesLine.SetRange("Document Type", BlanketOrderRec."Document Type");
    //     SalesLine.SetRange("Document No.", BlanketOrderRec."No.");
    //     if SalesLine.FindSet() then
    //         repeat
    //             for i := 1 to 3 do begin
    //                 if AgreementPercents[i] <> 0 then begin
    //                     LineNo += 10000;
    //                     SalesInvoiceLine.Init();
    //                     SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
    //                     SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
    //                     SalesInvoiceLine."Line No." := LineNo;
    //                     SalesInvoiceLine.Type := SalesInvoiceLine.Type::Item;
    //                     SalesInvoiceLine.Validate("No.", 'NI10066');
    //                     SalesInvoiceLine.Validate("VAT %", SalesLine."VAT %");
    //                     SalesInvoiceLine.Validate("VAT Calculation Type", SalesLine."VAT Calculation Type");
    //                     SalesInvoiceLine.Validate("VAT Identifier", SalesLine."VAT Identifier");
    //                     SalesInvoiceLine.Validate(Quantity, 1);
    //                     SalesInvoiceLine.Validate("Unit Price",
    //                         (SalesLine.Quantity * SalesLine."Unit Price") * AgreementPercents[i] / 100);
    //                     case i of
    //                         1:
    //                             SalesInvoiceLine.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Obrien Business Unit Code 1");
    //                         2:
    //                             SalesInvoiceLine.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Obrien Business Unit Code 2");
    //                         3:
    //                             SalesInvoiceLine.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Obrien Business Unit Code 3");
    //                     end;

    //                     SalesInvoiceLine.Insert(true);
    //                 end;
    //             end;
    //         until SalesLine.Next() = 0;
    //     SalesInvoiceHeader."Check Boolean" := true;
    //     SalesInvoiceHeader.Modify(true);
    // end;


    procedure CreateInvoiceFromBlanketOrder(var BlanketOrderRec: Record "Sales Header")
    var
        SalesInvoiceHeader: Record "Sales Header";
        SalesInvoiceLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        AgreementPercents: array[3] of Decimal;
        LineNo: Integer;
        i: Integer;
        TotalUnitPrice: Decimal;
    begin
        SalesInvoiceHeader.Init();
        SalesInvoiceHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        SalesInvoiceHeader.Insert(true);
        SalesInvoiceHeader.Validate("Sell-to Customer No.", BlanketOrderRec."Sell-to Customer No.");
        SalesInvoiceHeader."Order Date" := Today;
        SalesInvoiceHeader."Your Reference" := BlanketOrderRec."No.";
        SalesInvoiceHeader."External Document No." := BlanketOrderRec."External Document No.";
        SalesInvoiceHeader."Customer PO Number" := BlanketOrderRec."Customer PO Number";
        SalesInvoiceHeader."Blanket Sales Order No." := BlanketOrderRec."No.";
        SalesInvoiceHeader."Check Boolean" := false;
        SalesInvoiceHeader.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Shortcut Dimension 1 Code");
        SalesInvoiceHeader.Modify(true);

        AgreementPercents[1] := BlanketOrderRec."Agreement % 1";
        AgreementPercents[2] := BlanketOrderRec."Agreement % 2";
        AgreementPercents[3] := BlanketOrderRec."Agreement % 3";

        TotalUnitPrice := 0;
        SalesLine.SetRange("Document Type", BlanketOrderRec."Document Type");
        SalesLine.SetRange("Document No.", BlanketOrderRec."No.");
        if SalesLine.FindSet() then
            repeat
                TotalUnitPrice += SalesLine.Quantity * SalesLine."Unit Price";
            until SalesLine.Next() = 0;

        LineNo := 0;
        for i := 1 to 3 do begin
            if AgreementPercents[i] <> 0 then begin
                LineNo += 10000;
                SalesInvoiceLine.Init();
                SalesInvoiceLine."Document Type" := SalesInvoiceHeader."Document Type";
                SalesInvoiceLine."Document No." := SalesInvoiceHeader."No.";
                SalesInvoiceLine."Line No." := LineNo;
                SalesInvoiceLine.Type := SalesInvoiceLine.Type::Item;
                SalesInvoiceLine.Validate("No.", 'NI10066'); // Replace with proper item code
                SalesInvoiceLine.Validate(Quantity, 1);

                SalesInvoiceLine.Validate("Unit Price", TotalUnitPrice * AgreementPercents[i] / 100);
                // if SalesLine.FindFirst() then begin
                SalesInvoiceLine.Validate("VAT %", SalesLine."VAT %");
                SalesInvoiceLine.Validate("VAT Calculation Type", SalesLine."VAT Calculation Type");
                SalesInvoiceLine.Validate("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
                SalesInvoiceLine.Validate("VAT Identifier", SalesLine."VAT Identifier");
                // end;

                // Shortcut dimensions
                case i of
                    1:
                        SalesInvoiceLine.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Obrien Business Unit Code 1");
                    2:
                        SalesInvoiceLine.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Obrien Business Unit Code 2");
                    3:
                        SalesInvoiceLine.Validate("Shortcut Dimension 1 Code", BlanketOrderRec."Obrien Business Unit Code 3");
                end;

                SalesInvoiceLine.Insert(true);
            end;
        end;

        // Finalize
        SalesInvoiceHeader."Check Boolean" := true;
        SalesInvoiceHeader.Modify(true);
    end;



    procedure ISAnyErrorValidation(var BlanketOrderRec: Record "Sales Header"): Boolean
    var
        Des: Text;
    Begin
        if BlanketOrderRec."Sell-to Customer No." = '' then begin
            Des := 'Sell-to Customer No. is not specified in the Blanket Order.';
            CreateErrorLog(Des, BlanketOrderRec."No.");
        end;
        if BlanketOrderRec."Shortcut Dimension 1 Code" = '' then begin
            Des := StrSubstNo('Shortcut Dimension Code cannot be empty in Blanket Sales Order Header %1', BlanketOrderRec."No.");
            CreateErrorLog(Des, BlanketOrderRec."No.");
        end;
        if BlanketOrderRec."Invoice Frequency" = BlanketOrderRec."Invoice Frequency"::" " then begin
            Des := StrSubstNo('Invoice Frequency must be specified in Blanket Sales Order Header %1', BlanketOrderRec."No.");
            CreateErrorLog(Des, BlanketOrderRec."No.");
        end;

        // Only validate Last Invoice Created Date ranges when it has a value (non-zero)
        if (BlanketOrderRec."Last Invoice Created Date" <> 0D) then begin
            if BlanketOrderRec."Last Invoice Created Date" < BlanketOrderRec."Start Date" then begin
                Des := 'Last invoice date must be greater then or equal to start date';
                CreateErrorLog(Des, BlanketOrderRec."No.");
            end;
            if (BlanketOrderRec."Last Invoice Created Date" > BlanketOrderRec."End Date") then begin
                Des := 'Last invoice date must be Less then or equal to end date';
                CreateErrorLog(Des, BlanketOrderRec."No.");
            end;
        end;
        if Des = '' then
            exit(false)
        else
            exit(true);
    End;

    local procedure CreateErrorLog(Des: text; No: code[30])
    var
        ErrorLog: Record "Error Log";
        EntryNo: Integer;
    begin
        ErrorLog.Reset();
        if ErrorLog.FindLast() then
            EntryNo := ErrorLog."Entry No" + 1
        else
            EntryNo := 1;
        ErrorLog.Init();
        ErrorLog."Entry No" := EntryNo;
        ErrorLog.Description := des;
        ErrorLog."Document No" := No;
        ErrorLog.Insert();
    end;

}
