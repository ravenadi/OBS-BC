codeunit 50104 "Sales Order No. Management"
{
    Subtype = Normal;
    Access = Public;
    procedure UpdateSalesOrderNoFromSO(var SalesInvoiceHeader: Record "Sales Header"; SalesOrderNo: Code[20])
    begin
        if SalesInvoiceHeader."Document Type" = SalesInvoiceHeader."Document Type"::Invoice then begin
            SalesInvoiceHeader."Sales Order No." := SalesOrderNo;
            SalesInvoiceHeader.Modify(true);
        end;
    end;

    procedure UpdateProjectTaskNo(var SalesInvoiceHeader: Record "Sales Header"; ProjectTaskNo: Code[20])
    begin
        if SalesInvoiceHeader."Document Type" = SalesInvoiceHeader."Document Type"::Invoice then begin
            SalesInvoiceHeader."Job Task No" := ProjectTaskNo;
            SalesInvoiceHeader.Modify(true);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Header";
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) and (SalesInvHdrNo <> '') then begin
            if SalesInvoiceHeader.Get(SalesInvoiceHeader."Document Type"::Invoice, SalesInvHdrNo) then begin
                UpdateSalesOrderNoFromSO(SalesInvoiceHeader, SalesHeader."No.");
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Create-Invoice", 'OnAfterOpenSalesInvoice', '', false, false)]
    local procedure OnAfterOpenSalesInvoice(var JobPlanningLineInvoice: Record "Job Planning Line Invoice")
    var
        SalesHeader: Record "Sales Header";
    begin
        // Find the related Sales Header record
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("No.", JobPlanningLineInvoice."Document No.");

        if SalesHeader.FindFirst() then begin
            SalesHeader."Job Task No" := JobPlanningLineInvoice."Job Task No.";
            SalesHeader.Modify();
        end;
    end;
}
