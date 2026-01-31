tableextension 50128 "Price List Line Ext" extends "Price List Line"
{
    fields
    {
        field(50000; "Crm Id"; Text[100])
        {
            Caption = 'Crm Id';
            DataClassification = ToBeClassified;
        }
    }

    trigger OnAfterInsert()
    begin
        if not IsSalesPriceList() then
            exit;

        if ("Product No." = '') and ("Unit Price" = 0) then
            exit;
        // UpdateTheRecord();
    end;

    trigger OnAfterModify()
    begin
        if not IsSalesPriceList() then
            exit;

        if (xRec."Product No." <> Rec."Product No.") or (xRec."Unit Price" <> Rec."Unit Price") then begin
            // UpdateTheRecord();
        end;
    end;

    local procedure IsSalesPriceList(): Boolean
    var
        PriceListHeader: Record "Price List Header";
    begin
        if PriceListHeader.Get(Rec."Price List Code") then
            exit(PriceListHeader."Price Type" = PriceListHeader."Price Type"::Sale);
        exit(false);
    end;

    procedure UpdateTheRecord()
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        priceListJson: JsonObject;
        responseJson: JsonObject;
        jsonText: Text;
        tokenValue: JsonToken;
        tokenString: Text;
        productRec: Record Item;
        uomRec: Record "Unit of Measure";
        priceListRec: Record "Price List Header";
        MaxRetries: Integer;
        RetryCount: Integer;
        TimeoutMs: Integer;
        ErrorMsg: Text;
    begin
        MaxRetries := 3;
        RetryCount := 0;
        TimeoutMs := 120000;
        Client.Timeout(TimeoutMs);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Content-Encoding', 'UTF8');

        if not priceListRec.Get(Rec."Price List Code") then
            Error('Price List Header not found.');

        if not productRec.Get(Rec."Product No.") then
            Error('Product not found.');

        // if priceListRec."Crm Id" = '' then
        //     Error('Price List CRM ID is missing.');

        // if productRec."CRM ID" = '' then
        //     Error('Product CRM ID is missing.');

        Clear(priceListJson);
        priceListJson.Add('pricelistcrmid', priceListRec."Crm Id");
        priceListJson.Add('pricelistitembcid', Rec."Line No.");
        priceListJson.Add('pricelistitemcrmid', Rec."Crm Id");
        priceListJson.Add('productcrmid', productRec."CRM ID");
        priceListJson.Add('unitcrmid', uomRec."CRM ID");
        priceListJson.Add('amount', Rec."Unit Price");
        priceListJson.Add('unitgroupid', uomRec."Unitgroup CRM ID");
        priceListJson.Add('pricelistid', priceListRec."Crm Id");
        priceListJson.WriteTo(jsonText);
        Content.WriteFrom(jsonText);

        repeat
            RetryCount += 1;
            Clear(Response);
            // DCS:: HP 19092025 URL changes ++ 
            IsSuccessful := Client.Post('https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/423a3871dc6945ad9eec35a4ccc8beaf/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=nm6fKGe0dttOFVmAn42rW4JKE30TLS2IhyulVH5vm1g', Content, Response);

            if IsSuccessful then begin
                Response.Content().ReadAs(ResponseText);

                if ResponseText <> '' then begin
                    if responseJson.ReadFrom(ResponseText) then begin
                        if ParseErrorMessage(ResponseText, ErrorMsg) then
                            Error('API Error: %1', ErrorMsg);

                        if responseJson.Get('pricelistitemcrmid', tokenValue) then begin
                            if tokenValue.IsValue then begin
                                tokenString := tokenValue.AsValue().AsText();
                                Rec."Crm Id" := CopyStr(tokenString, 1, MaxStrLen(Rec."Crm Id"));
                                Rec.Modify(false);
                                exit;
                            end;
                        end;
                        Error('Response does not contain valid pricelistitemcrmid. Full response: %1', ResponseText);
                    end;
                    Error('Invalid JSON response: %1', ResponseText);
                end;
                Error('Empty response received from the server.');
            end else
                Error('HTTP request failed. Status code: %1', Response.HttpStatusCode);

            if RetryCount < MaxRetries then
                Sleep(100 * RetryCount);

        until (RetryCount >= MaxRetries);

        Error('Failed to update CRM ID after %1 attempts. Last response: %2', MaxRetries, ResponseText);
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
}