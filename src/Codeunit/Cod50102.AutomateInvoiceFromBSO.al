codeunit 50102 "Automate Invoice From BSO"
{
    Subtype = Normal;
    Access = Public;
    // Job queue related Code Start
    trigger OnRun()
    var
        SalesLineBOS: Record "Sales Line";
        Shipmentdate: Date;
    begin
        Shipmentdate := CalcDate('3D', Today);
        SalesLineBOS.Reset();
        SalesLineBOS.SetRange("Document Type", SalesLineBOS."Document Type"::"Blanket Order");
        SalesLineBOS.SetRange("Shipment Date", Shipmentdate);
        SalesLineBOS.SetFilter(Quantity, '>%1', 0);
        if SalesLineBOS.FindSet() then
            CreateSalesInvFromBOSLines(SalesLineBOS, false);
    end;

    procedure CreateSalesInvFromBOSLines(var SalesLineBOS: Record "Sales Line"; SingalRecord: Boolean)
    var
        Shipmentdate: Date;
        TempSalesLineBOS: Record "Sales Line" temporary;
        SalesHeader: Record "Sales Header";
    begin
        Shipmentdate := CalcDate('3D', Today);

        repeat
            if not ISAnyLineErrorValidation(SalesLineBOS) then begin
                if not TempSalesLineBOS.Get(SalesLineBOS."Document Type", SalesLineBOS."Document No.", SalesLineBOS."Line No.") then begin
                    TempSalesLineBOS := SalesLineBOS;
                    TempSalesLineBOS.Insert();
                end;
            end;
        until SalesLineBOS.Next() = 0;

        // Process grouped lines by document
        TempSalesLineBOS.Reset();
        if TempSalesLineBOS.FindSet() then begin
            // Group by blanket order document
            repeat
                SalesHeader.Reset();
                SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Blanket Order");
                SalesHeader.SetRange("No.", TempSalesLineBOS."Document No.");
                if SalesHeader.FindFirst() then begin
                    if not ISHeaderErrorValidation(SalesHeader, SingalRecord) then
                        CreateInvoiceByCustomer(SalesHeader, Shipmentdate, SingalRecord);
                end;
            until TempSalesLineBOS.Next() = 0;
        end;
    end;

    local procedure CreateInvoiceByCustomer(var SalesHeaderBSO: Record "Sales Header"; Shipmentdate: Date; SingalRecord: Boolean)
    var
        SalesLineBSO: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CreatedInvoice: Boolean;
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader.Validate("Sell-to Customer No.", SalesHeaderBSO."Sell-to Customer No.");
        SalesHeader."Order Date" := Today;
        SalesHeader."Shipment Date" := Today;
        SalesHeader."Document Date" := Today;
        SalesHeader."Sales Order No." := SalesHeaderBSO."No.";
        SalesHeader.Insert(true);
        Commit();

        // Process only lines with matching posting date
        SalesLineBSO.Reset();
        SalesLineBSO.SetRange("Document Type", SalesLineBSO."Document Type"::"Blanket Order");
        SalesLineBSO.SetRange("Document No.", SalesHeaderBSO."No.");
        SalesLineBSO.SetRange("Shipment Date", Shipmentdate);
        SalesLineBSO.SetFilter(Quantity, '>%1', 0);

        CreatedInvoice := false;
        if SalesLineBSO.FindSet() then begin
            repeat
                if not ISAnyLineErrorValidation(SalesLineBSO) then begin
                    SalesLine.Init();
                    SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine.Validate("Sell-to Customer No.", SalesHeaderBSO."Sell-to Customer No.");
                    SalesLine.Validate("Line No.", SalesLineBSO."Line No.");
                    SalesLine.Validate(Type, SalesLineBSO.Type);
                    SalesLine.Validate("No.", SalesLineBSO."No.");
                    SalesLine.Validate(Quantity, SalesLineBSO.Quantity);
                    SalesLine.Validate("Unit Price", SalesLineBSO."Unit Price");
                    SalesLine."Blanket Order No." := SalesLineBSO."Document No.";
                    SalesLine."Blanket Order Line No." := SalesLineBSO."Line No.";
                    SalesLine."Shipment Date" := SalesLineBSO."Shipment Date";
                    SalesLine.Insert(true);

                    // Mark line as processed
                    SalesLineBSO."Invoice Created" := true;
                    SalesLineBSO.Modify(true);
                    CreatedInvoice := true;
                end;
            until SalesLineBSO.Next() = 0;
        end;

        // If no valid lines were found, delete the header to avoid empty invoices
        if not CreatedInvoice then begin
            SalesHeader.Delete(true);
        end else if SingalRecord then
                Message('Sales Invoice %1 created from Blanket Order %2', SalesHeader."No.", SalesHeaderBSO."No.");
    end;

    // Error Log validation Code Start
    local procedure ISHeaderErrorValidation(var SalesHeaderBSO: Record "Sales Header"; SingalRecord: Boolean): Boolean
    var
        Customer: Record Customer;
        Des: Text;
    begin
        Des := '';
        if not Customer.Get(SalesHeaderBSO."Sell-to Customer No.") then begin
            Des := 'Customer not available in customer master';
            CreateErrorLog(Des, SalesHeaderBSO."No.", 0);
        end;

        if Des = '' then
            exit(false)
        else
            exit(true);
    end;

    local procedure ISAnyLineErrorValidation(var SalesLineBSO: Record "Sales Line"): Boolean
    var
        Item: Record Item;
        Shipmentdate: Date;
        Des: Text;
    begin
        Des := '';

        if SalesLineBSO."Shipment Date" = 0D then begin
            Des := 'Line posting date must have a value';
            CreateErrorLog(Des, SalesLineBSO."Document No.", SalesLineBSO."Line No.");
        end;

        Shipmentdate := CalcDate('3D', Today);
        if SalesLineBSO."Shipment Date" <> Shipmentdate then begin
            Des := 'Line posting date must be 3 days ahead';
            CreateErrorLog(Des, SalesLineBSO."Document No.", SalesLineBSO."Line No.");
        end;

        if not Item.Get(SalesLineBSO."No.") then begin
            Des := 'Item not available in item master';
            CreateErrorLog(Des, SalesLineBSO."Document No.", SalesLineBSO."Line No.");
        end;

        if SalesLineBSO.Quantity <= 0 then begin
            Des := 'Quantity must be greater than zero';
            CreateErrorLog(Des, SalesLineBSO."Document No.", SalesLineBSO."Line No.");
        end;

        if Des = '' then
            exit(false)
        else
            exit(true);
    end;

    local procedure CreateErrorLog(Des: text; No: code[30]; Lineno: Integer)
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
        ErrorLog."Line No" := Lineno;
        ErrorLog.Insert();
    end;
}