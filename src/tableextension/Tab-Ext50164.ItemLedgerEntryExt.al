tableextension 50164 "Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        field(50200; Comment; Text[200])
        {
            Caption = 'Comment';
            DataClassification = ToBeClassified;
        }
        field(50201; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;
        }
        field(50100; "OBS Product Name"; Text[1024])
        {
            fieldclass = FlowField;
            calcformula = lookup("Item".Description where("No." = field("Item No.")));
        }
        field(50101; "Warehouse Name"; Text[1024])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Location.Name where(Code = field("Location Code")));
        }
        // field(50102; "Work Order No."; Code[20])
        // {
        //     dataclassification = CustomerContent;
        // }
    }


    trigger OnAfterInsert()

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        payload: JsonObject;
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseText: Text;
        InventoryJson: JsonObject;
        JsonText: Text;
        Item: Record Item;
        IsSuccessful: Boolean;
        UnitOfMeasure: Record "Unit of Measure";
        Location: Record Location;
        MaxRetries: Integer;
        RetryCount: Integer;
        TimeoutMs: Integer;
        ErrorMsg: Text;
        ItemNo: Code[20];
        adjResponse: JsonToken;
        ILEpreview: Codeunit "ILE Preview Posting Handler";
        URLsetup: Record "URL Setup";
        //GkbLabs_Tv_31/01/2026++ Destination warehouse CRM ID for transfers
        DestCrmId: Text[100];
        ILEPair: Record "Item Ledger Entry";
        DestLocation: Record Location;
    begin
        URLsetup.Get();
        // DCS::HP 16102025 ++ Added preview logic below
        if ILEpreview.GetIsPreview() then
            exit;

        // GkbLabs_Tv_23/01/2026 ++ Skip negative transfer entries to avoid double trigger
        // GkbLabs_Tv_31/01/2026 ++ Changed: Process negative transfer entry (source) instead of positive
        if (Rec."Entry Type" = Rec."Entry Type"::Transfer) and (Rec.Quantity > 0) then
            exit;

        // Quantity := Rec.Quantity;
        if Rec."Entry Type" = Rec."Entry Type"::Transfer then
            Quantity := Abs(Rec.Quantity)  // For transfers, send positive quantity (direction via source/dest)
        else
            Quantity := Rec.Quantity;  // For adjustments, preserve sign

        Clear(InventoryJson);

        ItemNo := Rec."Item No.";
        Item.Get(ItemNo);
        InventoryJson.Add('productcrmid', Item."CRM ID");
        InventoryJson.Add('quantity', Quantity);

        UOMCode := Item."Base Unit of Measure";
        if UOMCode <> '' then begin
            UnitOfMeasure.Get(UOMCode);
            InventoryJson.Add('unitcrmid', UnitOfMeasure."CRM ID");
        end else
            exit;

        LocationCode := Rec."Location Code";
        if LocationCode <> '' then begin
            Location.Get(LocationCode);
            InventoryJson.Add('warehousecrmid', Location."CRM ID");
            // include bin code when present - user requested field 5403
            if Rec."Bin Code" <> '' then
                InventoryJson.Add('bincode', Rec."Bin Code");
            // GkbLabs_Tv_31/01/2026++ Only add adjustmentcrmid for non-transfer entries
            if Rec."Entry Type" <> Rec."Entry Type"::Transfer then
                InventoryJson.Add('adjustmentcrmid', Location."Adjustment Crm Id");
            // GkbLabs_Tv_31/01/2026--
        end else
            exit;

        //GkbLabs_Tv_31/01/2026++ Destination warehouse CRMID for transfers
        DestCrmId := '';
        if Rec."Entry Type" = Rec."Entry Type"::Transfer then begin
            // GkbLabs_Tv_31/01/2026 ++ Processing negative entry (source warehouse)
            // Current location is the SOURCE, find destination from paired positive entry
            if Rec.Quantity < 0 then begin
                // Find matching positive ILE to get destination warehouse
                ILEPair.Reset();
                ILEPair.SetRange("Document No.", Rec."Document No.");
                ILEPair.SetRange("Item No.", Rec."Item No.");
                ILEPair.SetRange("Entry Type", Rec."Entry Type"::Transfer);
                ILEPair.SetFilter(Quantity, '>0');
                ILEPair.SetFilter("Entry No.", '<>%1', Rec."Entry No.");
                if ILEPair.FindFirst() then begin
                    if ILEPair."Location Code" <> '' then begin
                        DestLocation.Get(ILEPair."Location Code");
                        DestCrmId := DestLocation."Crm Id"; // Destination warehouse
                    end;
                end else begin
                    // Could not find paired positive entry, leave DestCrmId blank or log for debugging
                    // Message('Paired positive transfer entry not found for Document No. %1, Item No. %2', Rec."Document No.", Rec."Item No.");
                end;
            end;
            // warehousecrmid already contains source (current location) - no change needed
        end;
        InventoryJson.Add('destinationwarehousecrmid', DestCrmId);

        // GkbLabs_Tv_31/01/2026++ Validate required data before API call to prevent production errors
        if (Quantity = 0) then
            exit; // Skip zero quantity entries

        if (Item."CRM ID" = '') then
            exit; // Skip items without CRM ID - cannot sync to CRM

        if (Location."Crm Id" = '') then
            exit; // Skip locations without CRM ID

        if (UnitOfMeasure."CRM ID" = '') then
            exit; // Skip UOMs without CRM ID

        // GkbLabs_Tv_31/01/2026++ Validate destination warehouse for transfers
        if (Rec."Entry Type" = Rec."Entry Type"::Transfer) and (DestCrmId = '') then begin
            // GkbLabs_Tv_31/01/2026 ++ Silent skip for production
            // Uncomment below for debugging:
            // Message('Transfer skipped: Destination warehouse CRM ID not found\nItem: %1, Document: %2\nPosting continues without CRM sync.',
            //     Rec."Item No.", Rec."Document No.");
            // GkbLabs_Tv_31/01/2026 --
            exit; // Skip transfers without destination warehouse CRM ID
        end;

        // GkbLabs_Tv_31/01/2026++ Additional validation: Ensure destination CRM ID is valid GUID format for transfers
        if (Rec."Entry Type" = Rec."Entry Type"::Transfer) and (StrLen(DestCrmId) < 30) then begin
            // Silent skip for production - uncomment below for debugging:
            // Message('Transfer skipped: Destination warehouse CRM ID invalid (%1)\nItem: %2, Document: %3\nPosting continues without CRM sync.',
            //     DestCrmId, Rec."Item No.", Rec."Document No.");
            exit; // Skip transfers with invalid destination warehouse CRM ID
        end;
        if (Rec."Entry Type" <> Rec."Entry Type"::Transfer) and (URLsetup."Inventory Adjustment URL" = '') then
            exit; // Skip if Adjustment URL not configured
                  //GkbLabs_Tv_31/01/2026---

        if (Quantity <> 0) AND (Location."Crm Id" <> '') AND (UnitOfMeasure."CRM ID" <> '') then begin
            // Content.WriteFrom(JsonText);
            Content.GetHeaders(ContentHeaders);
            ContentHeaders.Clear();
            ContentHeaders.Add('Content-Type', 'application/json');
            ContentHeaders.Add('Content-Encoding', 'UTF8');

            InventoryJson.WriteTo(JsonText);
            Content.WriteFrom(JsonText);
            // DCS::HP 11082025 ++
            // Message(JsonText);
            // DCS::HP 11082025 --
            // DCS:: HP 19092025 URL changes ++ 
            // IsSuccessful := Client.Post('https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/4392f4646a9b459cbc69c2a3d1b03306/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=SswYZtuV0xBMcWTuDj7RR351guDeOH15uLv_xS2Gp0U', Content, Response);
            // URL FOR PROD
            //post('https://50d025741381eff5a32b0e86779aa4.c3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/8b9958a8d9f042c9b5da81ea2e65781c/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=OzcEToHXTUBefuOQdN5fOpb3ptm3wc159bsMYL-7KO8', Content, Response);
            // GkbLabs_Tv_31/01/2026 ++ Use separate URLs for Transfer and Adjustment
            case Rec."Entry Type" of
                Rec."Entry Type"::Transfer:
                    IsSuccessful := Client.Post(URLsetup."Inventory Transfer URL", Content, Response);
                else
                    // For all other entry types (Adjustments, Purchase, Sale, etc.), use Inventory Adjustment URL
                    IsSuccessful := Client.Post(URLsetup."Inventory Adjustment URL", Content, Response);
            end;
            // GkbLabs_Tv_23/01/2026---

            // GkbLabs_Tv_31/01/2026++ Better error handling for production - don't block posting on API errors
            if IsSuccessful then begin
                Response.Content().ReadAs(ResponseText);
                if ResponseText <> '' then begin
                    if InventoryJson.ReadFrom(ResponseText) then begin
                        //GkbLabs_Tv_31/01/2026++
                        if ParseErrorMessage(ResponseText, ErrorMsg) then begin
                            // DCS::HP 02022026 ++ For Transfers, suppress error messages if data is syncing
                            if Rec."Entry Type" = Rec."Entry Type"::Transfer then begin
                                // Data is syncing successfully despite error response - exit silently
                                exit;
                            end else begin
                                // For non-transfers, show the error message
                                Message('CRM API Error: %1\nEntry Type: %2\nItem: %3\nDocument: %4\nJSON Sent: %5\nPosting continues.',
                                    ErrorMsg, Format(Rec."Entry Type"), Rec."Item No.", Rec."Document No.", JsonText);
                                exit;
                            end;
                            // DCS::HP 02022026 --
                        end;
                        // Only update if adjustmentcrmid exists in response
                        if InventoryJson.Get('adjustmentcrmid', adjResponse) then begin
                            Location."Adjustment Crm Id" := adjResponse.AsValue().AsText();
                            Location.Modify(false);
                        end;
                    end;
                end;
            end else begin
                // DCS::HP 02022026 ++ API call failed - suppress for Transfers, log for others
                if Rec."Entry Type" <> Rec."Entry Type"::Transfer then begin
                    // For non-transfers, show the HTTP error message
                    Message('CRM sync failed (HTTP %1)\nEntry: %2, Item: %3, Doc: %4\nJSON Sent: %5\nPosting continues.',
                        Response.HttpStatusCode, Format(Rec."Entry Type"), Rec."Item No.", Rec."Document No.", JsonText);
                end;
                // DCS::HP 02022026 --
            end;
            // GkbLabs_Tv_31/01/2026--
        end;
    end;

    local procedure ParseErrorMessage(ResponseText: Text; var ErrorMessage: Text): Boolean
    var
        JsonObject: JsonObject;
        ErrorToken: JsonToken;
        ErrorObject: JsonObject;
        MessageToken: JsonToken;
    begin
        if JsonObject.ReadFrom(ResponseText) then begin
            if JsonObject.Get('error', ErrorToken) then begin
                if ErrorToken.IsObject then begin
                    ErrorObject := ErrorToken.AsObject();
                    if ErrorObject.Get('message', MessageToken) then begin
                        if MessageToken.IsValue then begin
                            ErrorMessage := MessageToken.AsValue().AsText();
                            exit(true);
                        end;
                    end;
                    ErrorObject.WriteTo(ErrorMessage);
                    exit(true);
                end;
            end;
        end;
        ErrorMessage := ResponseText;
        exit(false);
    end;

    var
        Quantity: Decimal;
        UOMCode: Code[10];
        LocationCode: Code[10];
}




//  trigger OnInsertRecord(BelowxRec: Boolean): Boolean
// var
//     ItemLedgEntry: Record "Item Ledger Entry";
//     payload: JsonObject;
//     Client: HttpClient;
//     Content: HttpContent;
//     ContentHeaders: HttpHeaders;
//     Response: HttpResponseMessage;
//     ResponseText: Text;
//     InventoryJson: JsonObject;
//     JsonText: Text;
//     Item: Record Item;
//     IsSuccessful: Boolean;
//     UnitOfMeasure: Record "Unit of Measure";
//     Location: Record Location;
//     MaxRetries: Integer;
//     RetryCount: Integer;
//     TimeoutMs: Integer;
//     ErrorMsg: Text;
//     ItemNo: Code[20];
//     UOMCode: Code[10];
//     LocationCode: Code[10];
//     Quantity: Decimal;
//     adjResponse: JsonToken;
// begin
//     Quantity := 0;
//     ItemLedgEntry.SetFilter("Item No.", Rec."Item No.");
//     ItemLedgEntry.SetFilter("Location Code", Rec."Location Code");

//     if ItemLedgEntry.FindSet() then
//         repeat
//             Quantity := Quantity + ItemLedgEntry.Quantity;
//         until ItemLedgEntry.Next() = 0;

//     Clear(InventoryJson);

//     ItemNo := Rec."Item No.";
//     Item.Get(ItemNo);
//     InventoryJson.Add('productcrmid', Item."CRM ID");
//     InventoryJson.Add('quantity', Quantity);

//     UOMCode := Item."Base Unit of Measure";
//     if UOMCode <> '' then begin
//         UnitOfMeasure.Get(UOMCode);
//         InventoryJson.Add('unitcrmid', UnitOfMeasure."CRM ID");
//     end;

//     LocationCode := Rec."Location Code";
//     if LocationCode <> '' then begin
//         Location.Get(LocationCode);
//         InventoryJson.Add('warehousecrmid', Location."CRM ID");
//         InventoryJson.Add('adjustmentcrmid', Location."Adjustment Crm Id");
//     end;

//     // Content.WriteFrom(JsonText);
//     Content.GetHeaders(ContentHeaders);
//     ContentHeaders.Clear();
//     ContentHeaders.Add('Content-Type', 'application/json');
//     ContentHeaders.Add('Content-Encoding', 'UTF8');

//     InventoryJson.WriteTo(JsonText);
//     Content.WriteFrom(JsonText);
//     Message(JsonText);
// DCS:: HP 19092025 URL changes ++ 
//     IsSuccessful := Client.Post('https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/4392f4646a9b459cbc69c2a3d1b03306/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=SswYZtuV0xBMcWTuDj7RR351guDeOH15uLv_xS2Gp0U', Content, Response);

//     if IsSuccessful then begin
//         Response.Content().ReadAs(ResponseText);
//         if ResponseText <> '' then begin
//             if InventoryJson.ReadFrom(ResponseText) then begin
//                 if ParseErrorMessage(ResponseText, ErrorMsg) then
//                     Error('API Error: %1', ErrorMsg);
//                 InventoryJson.Get('adjustmentcrmid', adjResponse);
//                 Location."Adjustment Crm Id" := adjResponse.AsValue().AsText();
//                 Location.Modify(false);
//             end else
//                 Error('HTTP request failed. Status code: %1', Response.HttpStatusCode);
//         end;
//     end;
// end;

// local procedure ParseErrorMessage(ResponseText: Text; var ErrorMessage: Text): Boolean
// var
//     JsonObject: JsonObject;
//     ErrorToken: JsonToken;
//     ErrorObject: JsonObject;
//     MessageToken: JsonToken;
// begin
//     if JsonObject.ReadFrom(ResponseText) then begin
//         if JsonObject.Get('error', ErrorToken) then begin
//             if ErrorToken.IsObject then begin
//                 ErrorObject := ErrorToken.AsObject();
//                 if ErrorObject.Get('message', MessageToken) then begin
//                     if MessageToken.IsValue then begin
//                         ErrorMessage := MessageToken.AsValue().AsText();
//                         exit(true);
//                     end;
//                 end;
//                 ErrorObject.WriteTo(ErrorMessage);
//                 exit(true);
//             end;
//         end;
//     end;
//     ErrorMessage := ResponseText;
//     exit(false);
// end;
