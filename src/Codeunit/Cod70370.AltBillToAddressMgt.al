codeunit 70370 "Alt. Bill-to Address Mgt."
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterSellToCustomerNoValidate(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    begin
        if Rec."Sell-to Customer No." <> xRec."Sell-to Customer No." then
            Rec."Alt. Bill-to Ship-to Code" := '';
    end;
}