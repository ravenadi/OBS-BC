codeunit 50132 "Location Crm Management"
{
    procedure UpdateLocationToCRM(Location: Record Location)
    var
        Client: HttpClient;
        RequestContent: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        LocObject: JsonObject;
        ResponseObject: JsonObject;
        JsonText: Text;
        TokenValue: JsonToken;
        TokenString: Text;
        Dimension: Record "Dimension Value";
        defaultDimensiom: record "Default Dimension";
        empRec: record Employee;
        URLsetup: Record "URL Setup";
    begin
        URLsetup.Get();
        RequestContent.WriteFrom('');
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Content-Encoding', 'UTF8');
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');

        Clear(LocObject);
        LocObject.Add('name', Location."Name");
        LocObject.Add('locationcode', Location.Code);
        LocObject.Add('addressname', Location."Address Name");
        LocObject.Add('address', Location.Address);
        LocObject.Add('address2', Location."Address 2");
        LocObject.Add('address3', Location."Address 3");
        LocObject.Add('city', Location."D365 City");
        LocObject.Add('state', Location."D365 State");
        LocObject.Add('country', Location."D365 Country");
        LocObject.Add('postcode', Location."D365 Postal Code");
        LocObject.Add('description', Location.Description);
        // LocObject.Add('owner', Location.Owner);
        // DCS::HP 06102025 ++
        empRec.Reset();
        empRec.SetRange("No.", Location.Owner);
        if empRec.FindFirst() then
            LocObject.Add('owner', empRec."CRM ID");
        // DCS::HP 06102025 --
        // LocObject.Add('d365whname', Location."D365 Warehouse Name");
        LocObject.Add('crmid', Location."CRM ID");

        defaultDimensiom.Reset();
        defaultDimensiom.SetRange("Table ID", DATABASE::Location);
        defaultDimensiom.SetRange("No.", Location.Code);
        if defaultDimensiom.FindFirst() then begin
            Dimension.Reset();
            Dimension.SetRange("Dimension Code", defaultDimensiom."Dimension Code");
            Dimension.SetRange(code, defaultDimensiom."Dimension Value code");
            if Dimension.FindFirst() then
                LocObject.Add('dimensionid', Dimension."CRM ID");
        end;
        // else
        //     if Location.Dimension <> '' then begin
        //         Dimension.SetRange(Code, Location.Dimension);
        //         if Dimension.FindFirst() then
        //             LocObject.Add('dimensionid', Dimension."CRM ID");
        //     end;


        LocObject.WriteTo(JsonText);
        RequestContent.WriteFrom(JsonText);

        // IsSuccessful := Client.Post(
        //     'https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0ec0ba17edb348a8bd0997203c0ddc6b/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=H9J6H_t570f3MTQnmhne4MIkBa7UjslHzMY6BVzf7gU',
        //     RequestContent,
        //     Response
        // );
        // URL FOR PROD
        // IsSuccessful := Client.Post(
        //     'https://50d025741381eff5a32b0e86779aa4.c3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/3f6f56bac2c14247ad11c26cc780e68b/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=Y-vMq9fgHm-TGly2AQwK1HbW42SQS6dKPawua5Pl4_g',
        //     RequestContent,
        //     Response
        // );
        IsSuccessful := Client.Post(URLsetup."Location URL", RequestContent, Response);

        if IsSuccessful then begin
            Response.Content().ReadAs(ResponseText);
            if ResponseObject.ReadFrom(ResponseText) then begin
                if ResponseObject.Contains('crmid') then begin
                    ResponseObject.Get('crmid', TokenValue);
                    TokenString := TokenValue.AsValue().AsText();
                    Location."CRM ID" := CopyStr(TokenString, 1, 100);
                    Location.Modify(false);
                end;
                // if ResponseObject.Contains('d365whname') then begin
                //     ResponseObject.Get('d365whname', TokenValue);
                //     TokenString := TokenValue.AsValue().AsText();
                //     Location."D365 Warehouse Name" := CopyStr(TokenString, 1, 100);
                //     Location.Modify(false);
                // end;
            end;
        end;
    end;

}
