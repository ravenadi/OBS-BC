codeunit 50158 "PO CRM Sync Mgmt"
{
    SingleInstance = false;
    //gkblabs_tv_29/06/14 ++
    procedure SendPurchaseOrderToCRM(PurchaseOrderNo: Code[20])
    var
        PurchHdr: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        URLSetupRec: Record "URL Setup";
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Response: HttpResponseMessage;
        ResponseText: Text;

        Payload: JsonObject;
        ResponseJson: JsonObject;
        BodyObj: JsonObject;
        TokenValue: JsonToken;
        TokenString: Text;

        TotalAmount: Decimal;
        EarliestDueDate: Date;
        HasDueDate: Boolean;

        JobRec: Record Job;
        JobNo: Code[20];
        JobCrmId: Text;

        GLSetup: Record "General Ledger Setup";
        DimVal: Record "Dimension Value";
        BusinessUnitCrmId: Text;

        VendorRec: Record Vendor;
        LocationRec: Record Location;
        CurrencyRec: Record Currency;
        LCYCode: Code[10];
        CurrCodeToSend: Code[10];

        IsSuccessful: Boolean;
        JsonText: Text;

    begin
        // Load endpoint configuration
        if not URLSetupRec.Get() then
            exit;
        if URLSetupRec."Purchase Order URL" = '' then
            exit;

        // Load Purchase Header
        PurchHdr.Reset();
        PurchHdr.SetRange("Document Type", PurchHdr."Document Type"::Order);
        PurchHdr.SetRange("No.", PurchaseOrderNo);
        if not PurchHdr.FindFirst() then
            exit;

        // Aggregate line data
        TotalAmount := 0;
        HasDueDate := false;
        EarliestDueDate := 0D;
        JobNo := '';

        PurchLine.Reset();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchHdr."No.");
        if PurchLine.FindSet() then
            repeat
                // Use Line Amount (safer for POs)
                TotalAmount += PurchLine."Line Amount";

                if PurchLine."Expected Receipt Date" <> 0D then begin
                    if (not HasDueDate) or (PurchLine."Expected Receipt Date" < EarliestDueDate) then begin
                        EarliestDueDate := PurchLine."Expected Receipt Date";
                        HasDueDate := true;
                    end;
                end;

                if (JobNo = '') and (PurchLine."Job No." <> '') then
                    JobNo := PurchLine."Job No.";
            until PurchLine.Next() = 0;

        // Resolve related records (safe Get)
        Clear(VendorRec);
        if PurchHdr."Buy-from Vendor No." <> '' then
            if not VendorRec.Get(PurchHdr."Buy-from Vendor No.") then
                Clear(VendorRec);

        Clear(LocationRec);
        if PurchHdr."Location Code" <> '' then
            if not LocationRec.Get(PurchHdr."Location Code") then
                Clear(LocationRec);

        // Resolve currency: use document currency, else fallback to LCY
        LCYCode := '';
        if GLSetup.Get() then
            LCYCode := GLSetup."LCY Code";

        Clear(CurrencyRec);
        CurrCodeToSend := PurchHdr."Currency Code";
        if CurrCodeToSend = '' then
            CurrCodeToSend := LCYCode;

        if CurrCodeToSend <> '' then
            if not CurrencyRec.Get(CurrCodeToSend) then
                Clear(CurrencyRec);

        JobCrmId := '';
        if (JobNo <> '') and JobRec.Get(JobNo) then
            JobCrmId := JobRec."CRM ID";

        // Business Unit CRM ID
        BusinessUnitCrmId := '';
        if GLSetup.Get() then
            if PurchHdr."Shortcut Dimension 1 Code" <> '' then begin
                DimVal.Reset();
                DimVal.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
                DimVal.SetRange("Code", PurchHdr."Shortcut Dimension 1 Code");
                if DimVal.FindFirst() then
                    BusinessUnitCrmId := DimVal."CRM ID";
            end;

        // Build JSON Payload
        Clear(Payload);
        Payload.Add('operation', 'CREATE');
        Payload.Add('bcpurchaseorderno', PurchHdr."No.");
        Payload.Add('crmid', PurchHdr."CRM ID");

        Payload.Add('vendorno', PurchHdr."Buy-from Vendor No.");
        Payload.Add('vendorcrmid', VendorRec."CRM ID");
        Payload.Add('vendorname', VendorRec.Name);

        Payload.Add('orderdate', Format(PurchHdr."Document Date", 0, '<Standard Format,9>'));
        if HasDueDate then
            Payload.Add('duedate', Format(EarliestDueDate, 0, '<Standard Format,9>'));

        Payload.Add('amount', Round(TotalAmount, 0.01));
        Payload.Add('currencycode', CurrCodeToSend);
        Payload.Add('currencycrmid', CurrencyRec."CRM ID");

        // Status as text (Power Apps expects string)
        Payload.Add('status', Format(PurchHdr.Status).Replace('_x0020_', ' '));

        Payload.Add('locationcode', PurchHdr."Location Code");
        Payload.Add('locationcrmid', LocationRec."CRM ID");

        Payload.Add('jobno', JobNo);
        Payload.Add('jobcrmid', JobCrmId);

        Payload.Add('orderedby', PurchHdr."Ordered By");
        Payload.Add('nameorderedby', PurchHdr."Name Ordered By");
        Payload.Add('specialinstruction', PurchHdr."Special Instruction");
        Payload.Add('deliverydocketno', PurchHdr."Delivery Docket No.");

        Payload.Add('address1', PurchHdr."Buy-from Address");
        Payload.Add('address2', PurchHdr."Buy-from Address 2");
        Payload.Add('address3', PurchHdr."Address 3");
        Payload.Add('city', PurchHdr."Buy-from City");
        Payload.Add('postcode', PurchHdr."Buy-from Post Code");
        Payload.Add('country', PurchHdr."Buy-from Country/Region Code");

        Payload.Add('shortcutdimension1code', PurchHdr."Shortcut Dimension 1 Code");
        Payload.Add('businessunitcrmid', BusinessUnitCrmId);
        Payload.Add('genbuspostinggroup', PurchHdr."Gen. Bus. Posting Group");

        Payload.WriteTo(JsonText);

        // HTTP request with headers so Flow exposes $content wrapper automatically
        Content.WriteFrom(JsonText);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'text/plain; charset=utf-8');

        Client.Timeout(60000);

        IsSuccessful := Client.Post(URLSetupRec."Purchase Order URL", Content, Response);

        Response.Content().ReadAs(ResponseText);

        if not IsSuccessful then
            Error('HTTP request failed for PO %1. Response: %2', PurchHdr."No.", ResponseText);

        if not Response.IsSuccessStatusCode() then
            Error(
                'CRM error for PO %1. Status: %2 Response: %3',
                PurchHdr."No.",
                Response.HttpStatusCode(),
                ResponseText
            );

        // Read CRM response & update CRM ID
        if ResponseText <> '' then begin
            if ResponseJson.ReadFrom(ResponseText) then begin
                TokenString := '';

                // Try multiple key casings at root level
                if ResponseJson.Get('crmid', TokenValue) or
                   ResponseJson.Get('crmId', TokenValue) or
                   ResponseJson.Get('CRMID', TokenValue)
                then
                    TokenString := TokenValue.AsValue().AsText();

                // Check for body wrapper (common in Power Automate responses)
                if (TokenString = '') and ResponseJson.Get('body', TokenValue) then begin
                    if TokenValue.IsObject then begin
                        BodyObj := TokenValue.AsObject();

                        // Try multiple key casings inside body
                        if BodyObj.Get('crmid', TokenValue) or
                           BodyObj.Get('crmId', TokenValue) or
                           BodyObj.Get('CRMID', TokenValue)
                        then
                            TokenString := TokenValue.AsValue().AsText();

                        // Handle nested body.body structure
                        if (TokenString = '') and BodyObj.Get('body', TokenValue) and TokenValue.IsObject then begin
                            BodyObj := TokenValue.AsObject();
                            if BodyObj.Get('crmid', TokenValue) or
                               BodyObj.Get('crmId', TokenValue) or
                               BodyObj.Get('CRMID', TokenValue)
                            then
                                TokenString := TokenValue.AsValue().AsText();
                        end;
                    end;
                end;
            end else begin
                // Fallback: treat response as plain text containing the CRM ID
                TokenString := DelChr(ResponseText, '=', ' ');
            end;

            if TokenString <> '' then begin
                PurchHdr.LockTable();
                PurchHdr."CRM ID" := CopyStr(DelChr(TokenString, '=', '"'), 1, MaxStrLen(PurchHdr."CRM ID"));
                PurchHdr.Modify(false);
                Commit();
            end;
        end;
    end;
}