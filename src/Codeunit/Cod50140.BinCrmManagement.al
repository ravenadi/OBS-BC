namespace GKBCustomization.GKBCustomization;

using Microsoft.Warehouse.Structure;
using Microsoft.Inventory.Location;

codeunit 50140 "Bin Crm Management"
{
    procedure UpdateToCrm(var Bin: Record Bin)
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseText: Text;
        JObject: JsonObject;
        JsonText: Text;
        ResponseJson: JsonObject;
        TokenValue: JsonToken;
        TokenString: Text;
        ErrorMsg: Text;
        RetryCount: Integer;
        MaxRetries: Integer;
        URLSetup: Record "URL Setup";
        Loc: Record Location;
        LocCrmMgmt: Codeunit "Location Crm Management";
        IsSuccessful: Boolean;
    begin
        if not URLSetup.Get() then
            Error('URL Setup record not found.');

        if URLSetup."Bin URL" = '' then
            Error('Bin URL is not configured.');

        MaxRetries := 3;
        RetryCount := 0;

        // Build JSON payload once
        Clear(JObject);
        JObject.Add('bincode', Bin.Code);
        // attempt to ensure location has a CRM id before calling
        if Bin."Location Code" <> '' then begin
            if Loc.Get(Bin."Location Code") then begin
                if Loc."Crm Id" = '' then
                    LocCrmMgmt.UpdateLocationToCRM(Loc);
                if Loc."Crm Id" <> '' then
                    JObject.Add('locationcrmid', Loc."Crm Id");
            end;
        end;

        JObject.Add('crmid', Bin."CRM ID");
        JObject.Add('operation', 'createupdate');

        JObject.WriteTo(JsonText);

        Client.DefaultRequestHeaders.Clear();
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');
        Client.Timeout := 60000; // 60 sec


        repeat
            RetryCount += 1;

            // Rebuild content every attempt
            Clear(Content);
            Content.WriteFrom(JsonText);
            Content.GetHeaders(ContentHeaders);
            ContentHeaders.Clear();
            ContentHeaders.Add('Content-Type', 'application/json');

            Clear(Response);

            IsSuccessful := Client.Post(URLSetup."Bin URL", Content, Response);

            if not IsSuccessful then begin
                if RetryCount >= MaxRetries then
                    Error('HTTP request failed after %1 attempts.', MaxRetries);

                Sleep(500 * RetryCount);
                continue;
            end;

            Response.Content().ReadAs(ResponseText);

            if not Response.IsSuccessStatusCode() then begin
                // ignore bad request errors caused by disabled workflows; those
                // indicate the CRM record already exists or cannot be updated via
                // the automated process.  Users typically paste the CRM ID and
                // don't expect the update to fire, so swallow that specific
                // failure rather than crashing the application.
                // HttpStatusCode enum is not in scope in this project, so just
                // test the numeric value (400 = Bad Request).
                if Response.HttpStatusCode = 400 then begin
                    if StrPos(ResponseText, 'WorkflowTriggerIsNotEnabled') > 0 then
                        exit; // treat as successful
                end;

                Error(
                    'CRM API returned %1 - %2\nDetails: %3',
                    Response.HttpStatusCode,
                    Response.ReasonPhrase,
                    ResponseText);
            end;

            if ResponseText = '' then
                exit;

            if not ResponseJson.ReadFrom(ResponseText) then
                Error('Invalid JSON response from CRM: %1', ResponseText);

            if ParseErrorMessage(ResponseText, ErrorMsg) then
                Error('CRM Error: %1', ErrorMsg);

            if ResponseJson.Get('crmid', TokenValue) then
                if TokenValue.IsValue then begin
                    TokenString := TokenValue.AsValue().AsText();
                    Bin."CRM ID" := CopyStr(TokenString, 1, MaxStrLen(Bin."CRM ID"));
                    Bin.Modify(false);
                end;

            exit;

        until RetryCount >= MaxRetries;
    end;

    procedure DeleteFromCrm(BinCode: Code[20]; CRMId: Text[100])
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        JObject: JsonObject;
        JsonText: Text;
        URLSetup: Record "URL Setup";
        ResponseText: Text;
        ErrorMsg: Text;
    begin
        if not URLSetup.Get() then
            exit;

        if URLSetup."Bin URL" = '' then
            exit;

        Clear(JObject);
        JObject.Add('operation', 'delete');
        JObject.Add('bincode', BinCode);
        JObject.Add('crmid', CRMId);

        JObject.WriteTo(JsonText);

        Content.WriteFrom(JsonText);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');

        Client.DefaultRequestHeaders.Clear();
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        if not Client.Post(URLSetup."Bin URL", Content, Response) then
            Error('Failed to call CRM delete endpoint.');

        Response.Content().ReadAs(ResponseText);

        if not Response.IsSuccessStatusCode() then
            Error(
                'Delete failed. Status: %1 - %2. Details: %3',
                Response.HttpStatusCode,
                Response.ReasonPhrase,
                ResponseText);

        if ParseErrorMessage(ResponseText, ErrorMsg) then
            Error('CRM Delete Error: %1', ErrorMsg);
    end;

    local procedure ParseErrorMessage(ResponseText: Text; var ErrorMessage: Text): Boolean
    var
        JsonObj: JsonObject;
        ErrorToken: JsonToken;
        ErrorObject: JsonObject;
        MessageToken: JsonToken;
    begin
        if not JsonObj.ReadFrom(ResponseText) then
            exit(false);

        if JsonObj.Get('error', ErrorToken) and ErrorToken.IsObject then begin
            ErrorObject := ErrorToken.AsObject();
            if ErrorObject.Get('message', MessageToken) and MessageToken.IsValue then begin
                ErrorMessage := MessageToken.AsValue().AsText();
                exit(true);
            end;
            ErrorObject.WriteTo(ErrorMessage);
            exit(true);
        end;

        exit(false);
    end;
}