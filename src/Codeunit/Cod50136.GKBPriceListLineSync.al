codeunit 50136 "GKB Price List Line Sync"
{
    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertPriceListLine(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        if RunTrigger and ShouldSyncRecord(Rec) then
            SyncPriceListLineToCRM(Rec, 'CREATE');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyPriceListLine(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        if RunTrigger and ShouldSyncRecord(Rec) then
            SyncPriceListLineToCRM(Rec, 'UPDATE');
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyItem(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        PriceListLine: Record "Price List Line";
    begin
        if RunTrigger and (Rec."Unit Price" <> xRec."Unit Price") then begin
            // Sync all price list lines associated with the modified item
            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
            PriceListLine.SetRange("Asset No.", Rec."No.");
            if PriceListLine.FindSet() then
                repeat
                    if ShouldSyncRecord(PriceListLine) then
                        SyncPriceListLineToCRM(PriceListLine, 'UPDATE_FROM_ITEM');
                until PriceListLine.Next() = 0;
        end;
    end;

    // Determines if the Price List Line should be synced based on specific criteria
    local procedure ShouldSyncRecord(var PriceListLine: Record "Price List Line"): Boolean
    begin
        exit(PriceListLine."Price List Code" in ['GOLD', 'PLATINUM', 'SILVER', 'BRONZE', 'PROJECT'] or
             PriceListLine.Description.Contains('CRM'));
    end;

    // Syncs the Price List Line to CRM using an API call
    local procedure SyncPriceListLineToCRM(var PriceListLine: Record "Price List Line"; Action: Text)
    var
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponse: HttpResponseMessage;
        JsonObject: JsonObject;
        JsonText: Text;
        ApiUrl: Text;
        Headers: HttpHeaders;
        PriceListHeader: Record "Price List Header";
        Item: Record Item;
        UOM: Record "Unit of Measure";
        URLSetupRec: Record "URL Setup";
    begin
        // DCS::HP02122025 ++
        URLSetupRec.Get();
        // ApiUrl := 'https://prod-15.australiasoutheast.logic.azure.com:443/workflows/944e845ef9734ccb9f6ec5ebea42c13a/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=3I1DE1yIV8Ne40G8c4bdygvnQOAKPPnDehCUpwX1XC0';
        ApiUrl := URLSetupRec."Sales Price List URL";
        // DCS::HP02122025 --

        // Get Price List Header info
        if PriceListHeader.Get(PriceListLine."Price List Code") then;

        // Get related Item data
        if (PriceListLine."Asset Type" = PriceListLine."Asset Type"::Item) and Item.Get(PriceListLine."Asset No.") then;

        // Build JSON payload with Price List Line data
        JsonObject.Add('Action', Action);
        JsonObject.Add('PriceListCode', PriceListLine."Price List Code");
        JsonObject.Add('PriceListDescription', PriceListHeader.Description);
        JsonObject.Add('PriceListSourceType', Format(PriceListHeader."Source Type"));

        if Item."No." <> '' then begin
            JsonObject.Add('ItemNo', Item."No.");
            JsonObject.Add('ItemDescription', Item.Description);
            JsonObject.Add('ItemUnitPrice', Item."Unit Price");
            JsonObject.Add('ItemUnitCost', Item."Unit Cost");
            JsonObject.Add('ItemType', Format(Item.Type));
            JsonObject.Add('ItemCRMID', Format(Item."CRM ID"));
        end;

        JsonObject.Add('ProductNo', PriceListLine."Product No.");
        JsonObject.Add('AssignToNo', PriceListLine."Assign-to No.");
        JsonObject.Add('AssignToParentNo', PriceListLine."Assign-to Parent No.");
        JsonObject.Add('CostPlusPercent', PriceListLine."Cost-plus %");
        JsonObject.Add('DiscountAmount', PriceListLine."Discount Amount");
        JsonObject.Add('AssetType', Format(PriceListLine."Asset Type"));
        JsonObject.Add('AssetNo', PriceListLine."Asset No.");
        JsonObject.Add('CurrencyCode', PriceListLine."Currency Code");
        JsonObject.Add('UnitPrice', PriceListLine."Unit Price");
        JsonObject.Add('CostFactor', PriceListLine."Cost Factor");
        JsonObject.Add('UnitCost', PriceListLine."Unit Cost");

        if PriceListLine."Unit of Measure Code" <> '' then
            UOM.Get(PriceListLine."Unit of Measure Code");
        JsonObject.Add('uomCRMID', UOM."CRM ID");

        JsonObject.Add('AssetID', Format(PriceListLine."Asset ID"));
        JsonObject.Add('LineAmount', PriceListLine."Line Amount");
        JsonObject.Add('PriceType', Format(PriceListLine."Price Type"));
        JsonObject.Add('Description', PriceListLine.Description);
        JsonObject.Add('Status', Format(PriceListLine.Status));

        JsonObject.WriteTo(JsonText);
        HttpContent.WriteFrom(JsonText);
        HttpContent.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        // Make API call
        if not HttpClient.Post(ApiUrl, HttpContent, HttpResponse) then
            Error('Failed to sync Price List Line to CRM: %1', GetLastErrorText());
    end;
}