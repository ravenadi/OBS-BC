codeunit 50130 "Update Project to Crm"
{
    procedure UpdateCRMAccount(Job: Record Job)
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        jobJson: JsonObject;
        responseJson: JsonObject;
        jsonText: Text;
        tokenValue: JsonToken;
        tokenString: Text;
        MaxRetries: Integer;
        RetryCount: Integer;
        TimeoutMs: Integer;
        ErrorMsg: Text;
        workorder: Record "Work Order";
        workordersubstatusrec: Record "Work Order Substatus";
        URLsetup: Record "URL Setup";
    begin
        URLsetup.Get();
        Job.Find(); // Refresh from DB to get latest Substatus value
        MaxRetries := Job."System Status";
        RetryCount := 0;
        TimeoutMs := 120000;
        Client.Timeout(TimeoutMs);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Content-Encoding', 'UTF8');
        workorder.Reset();
        workorder.SetRange("Work Order No.", Job."No.");
        if workorder.FindFirst() then
            jobJson.Add('crmid', workorder."CRM ID");
        jobJson.Add('systemStatus', Job."System Status");
        // DCS::HP 18082025 ++
        if Job."Substatus" <> '' then begin
            workordersubstatusrec.Reset();
            workordersubstatusrec.SetFilter(Name, '@' + Job."Substatus");
            if workordersubstatusrec.FindFirst() then
                jobJson.Add('substatus', workordersubstatusrec."CRM ID");
        end;
        // DCS::HP 18082025 --
        jobJson.WriteTo(jsonText);
        Content.WriteFrom(jsonText);
        repeat
            RetryCount += 1;
            Clear(Response);
            // DCS:: HP 19092025 URL changes ++ 
            // IsSuccessful := Client.Post('https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/bf2e47b66028475c9813d98ae1f6db0f/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=RM6a_5vHgIQvnn1efVgNk-TFhGyOtSsn92cGN-rQ5Pk', Content, Response);
            // URL FOR PROD
            // IsSuccessful := Client.Post('https://50d025741381eff5a32b0e86779aa4.c3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/7836c99173bb44b9aaeca79aa3fcb5ca/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=231PIF6LGDHOKqstLUU6lIuc6dZyCtaLQfP64Aqi-LM', Content, Response);
            IsSuccessful := Client.Post(URLsetup."Projects URL", Content, Response);
            if IsSuccessful then begin
                Response.Content().ReadAs(ResponseText);
                // Message('Response Code: %1', Response.HttpStatusCode);
                Response.Content().ReadAs(ResponseText);
                // Message('Response Text: %1', ResponseText);
                if ResponseText <> '' then begin
                    if responseJson.ReadFrom(ResponseText) then begin
                        if ParseErrorMessage(ResponseText, ErrorMsg) then
                            Error('API Error: %1', ErrorMsg);
                        if responseJson.Get('crmid', tokenValue) then begin
                            if tokenValue.IsValue then begin
                                tokenString := tokenValue.AsValue().AsText();
                                exit;
                            end;
                        end;
                        Error('Response does not contain valid CRM ID. Full response: %1', ResponseText);
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