codeunit 50163 "Job Labour Summary Mgt"
{
    SingleInstance = true;
    //GKb-surender
    procedure RecalculateJobLabour(JobNo: Code[20])
    var
        JPL: Record "Job Planning Line";
        ItemRec: Record Item;
        JobRec: Record Job;
        Total: Decimal;
        jplGp: Text;
        itemGp: Text;
    begin
        if JobNo = '' then
            exit;

        Total := 0;
        JPL.Reset();
        JPL.SetRange("Job No.", JobNo);
        if JPL.FindSet() then
            repeat
                // Only consider Item lines
                if (JPL.Type = JPL.Type::Item) and (JPL."No." <> '') then begin
                    // Determine Gen. Prod. Posting Group: prefer the planning line value, fallback to Item master
                    if JPL."Gen. Prod. Posting Group" <> '' then
                        itemGp := JPL."Gen. Prod. Posting Group"
                    else begin
                        itemGp := '';
                        if ItemRec.Get(JPL."No.") then
                            itemGp := ItemRec."Gen. Prod. Posting Group";
                    end;

                    // Use case-insensitive comparison without Trim to avoid compiler differences
                    if UpperCase(itemGp) = 'LABOUR' then begin
                        if JPL."Line Type" = JPL."Line Type"::"Both Budget and Billable" then
                            Total += JPL.Quantity;
                    end;
                end;
            until JPL.Next() = 0;

        if JobRec.Get(JobNo) then begin
            JobRec."Total Labour Quantity" := Total;
            JobRec.Modify(true);
        end;
    end;

    /// Posts Job Labour summary to an external endpoint using an endpoint URL and auth token provided by caller.
    /// Caller responsibility: supply valid EndpointUrl (e.g., the JobLabourSummary URL) and AuthToken (Bearer token) if required.
    procedure PostJobLabourSummaryWithToken(JobNo: Code[20]; EndpointUrl: Text[500]; AuthToken: Text)
    var
        JobRec: Record Job;
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        requestJson: JsonObject;
        jsonText: Text;
        MaxRetries: Integer;
        RetryCount: Integer;
        TimeoutMs: Integer;
        ErrorMsg: Text;
    begin
        if JobNo = '' then
            exit;
        if EndpointUrl = '' then
            exit; // nothing to do

        if not JobRec.Get(JobNo) then
            Error('Job %1 not found', JobNo);

        // Ensure the labour sum is recalculated before posting
        RecalculateJobLabour(JobNo);

        // Build JSON payload (only the requested fields)
        requestJson.Add('jobNo', JobRec."No.");
        requestJson.Add('totalLabourQuantity', JobRec."Total Labour Quantity");
        requestJson.Add('crmId', JobRec."CRM ID");
        requestJson.WriteTo(jsonText);

        // Prepare content
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Content-Encoding', 'UTF8');
        if AuthToken <> '' then
            ContentHeaders.Add('Authorization', 'Bearer ' + AuthToken);
        Content.WriteFrom(jsonText);

        // Retry settings
        MaxRetries := 3;
        RetryCount := 0;
        TimeoutMs := 120000;
        Client.Timeout(TimeoutMs);

        repeat
            RetryCount += 1;
            Clear(Response);
            IsSuccessful := Client.Post(EndpointUrl, Content, Response);
            if IsSuccessful then begin
                Response.Content().ReadAs(ResponseText);
                if ResponseText <> '' then begin
                    // Try to detect error message inside response
                    if ParseErrorMessage(ResponseText, ErrorMsg) then
                        Error('API Error: %1', ErrorMsg);
                    // On success we simply exit
                    exit;
                end;
                // Empty response considered success -> exit
                exit;
            end else
                Error('HTTP request failed. Status code: %1', Response.HttpStatusCode);

            if RetryCount < MaxRetries then
                Sleep(100 * RetryCount);
        until (RetryCount >= MaxRetries);

        Error('Failed to post Job Labour Summary after %1 attempts. Last response: %2', MaxRetries, ResponseText);
    end;

    /// Returns a diagnostic JSON string for a Job showing each planning line and whether it contributed to the labour sum.
    procedure GetJobLabourDiagnostic(JobNo: Code[20]) JobDiagnostic: Text
    var
        JPL: Record "Job Planning Line";
        ItemRec: Record Item;
        Total: Decimal;
        Included: Boolean;
        jplGp: Text;
        itemGp: Text;
        sb: Text;
        firstLine: Boolean;
    begin
        JobDiagnostic := '';
        if JobNo = '' then
            exit;

        Total := 0;
        sb := '{"Job_No":"' + JobNo + '","Lines":[';
        firstLine := true;

        JPL.Reset();
        JPL.SetRange("Job No.", JobNo);
        if JPL.FindSet() then
            repeat
                Included := false;
                jplGp := JPL."Gen. Prod. Posting Group";
                itemGp := '';
                if jplGp <> '' then
                    itemGp := jplGp
                else begin
                    if ItemRec.Get(JPL."No.") then
                        itemGp := ItemRec."Gen. Prod. Posting Group";
                end;

                if (JPL.Type = JPL.Type::Item) and (JPL."No." <> '') then begin
                    if UpperCase(itemGp) = 'LABOUR' then
                        if JPL."Line Type" = JPL."Line Type"::"Both Budget and Billable" then begin
                            Included := true;
                            Total += JPL.Quantity;
                        end;
                end;

                // Build minimal JSON line entry
                if not firstLine then
                    sb += ',';
                firstLine := false;
                sb += '{"LineNo":' + Format(JPL."Line No.") + ',"JobTaskNo":' + Format(JPL."Job Task No.") + ',"No":"' + JPL."No." + '","Type":"' + Format(JPL.Type) + '","LineType":"' + Format(JPL."Line Type") + '","JPLGenProd":"' + JPL."Gen. Prod. Posting Group" + '","ItemGenProd":"' + itemGp + '","Quantity":' + Format(JPL.Quantity) + ',"Included":' + Format(Included) + '}';
            until JPL.Next() = 0;

        sb += '],"ComputedTotal":' + Format(Total) + '}';
        JobDiagnostic := sb;
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