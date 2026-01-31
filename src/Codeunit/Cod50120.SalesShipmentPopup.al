codeunit 50120 "Sales Shipment Popup"
{
    Subtype = Normal;
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        //SalesShipmentLine: Record "Sales Shipment Line";
        Navigate: Boolean;
    begin
        SalesShipmentHeader.Reset();
        SalesShipmentHeader.SetRange("Order No.", SalesHeader."No.");
        SalesShipmentHeader.SetCurrentKey("No.");

        if SalesShipmentHeader.FindLast() then begin
            if SalesShipmentHeader.Get(SalesShipmentHeader."No.") then begin

                Navigate := Confirm(
                    'Shipment completed successfully. Shipment No.: %1\Do you want to open the posted shipment?', false, SalesShipmentHeader."No.");

                if Navigate then
                    PAGE.Run(PAGE::"Posted Sales Shipment", SalesShipmentHeader);
            end;
        end;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnInsertShipmentHeaderOnBeforeTransferfieldsToSalesShptHeader', '', false, false)]
    // local procedure OnInsertShipmentHeaderOnBeforeTransferfieldsToSalesShptHeader(
    // var SalesHeader: Record "Sales Header");
    // var
    //     SalesShipmentHeader: Record "Sales Shipment Header";
    // begin
    //     SalesShipmentHeader."Delivery Docket No." := SalesHeader."Delivery Docket No.";
    // end;
}

