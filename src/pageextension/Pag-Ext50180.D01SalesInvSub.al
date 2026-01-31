// DCS::HP 20252307 ++
pageextension 50180 "D01 SalesInvSub" extends "Sales Invoice subform"
{
    layout
    {
        modify("TotalSalesLine.""Line Amount""")
        {
            Visible = false;
        }
        addfirst(Control33)
        {
            field("SubTotalLineAmtExcVAT"; TotalLineAmt)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = Currency.Code;
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalSalesHeader."Prices Including VAT");
                Caption = 'Subtotal Excl. VAT';
                Editable = false;
                ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';
            }
        }

    }

    trigger OnAfterGetCurrRecord()
    var
        SH: Record "Sales Header";
        GlobalState: Codeunit "D01 Global State";
    begin
        if GlobalState.GetIsHandled() then begin
            if SH.Get(Rec."Document Type", Rec."Document No.") then begin
                if TotalSalesLine."Line Amount" <> 0 then
                    if SH."Percentage To Invoice" <> 0 then
                        TotalLineAmt := SH."Invoicing Amount"
                    else
                        TotalLineAmt := SH."Invoicing Amount";
            end;
            GlobalState.SetIsHandled(false);
        end
        else
            TotalLineAmt := TotalSalesLine."Line Amount";
    end;

    var
        TotalLineAmt: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        Currency: Record Currency;
}
// DCS::HP 20252307 --