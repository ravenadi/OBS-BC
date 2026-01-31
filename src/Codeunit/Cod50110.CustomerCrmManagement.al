codeunit 50110 "Customer Crm Management"
{
    procedure UpdateCRMAccount(Customer: Record Customer)
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        customerJson: JsonObject;
        responseJson: JsonObject;
        jsonText: Text;
        tokenValue: JsonToken;
        tokenString: Text;
        MaxRetries: Integer;
        RetryCount: Integer;
        TimeoutMs: Integer;
        ErrorMsg: Text;
        Currency: Record Currency;
        Contact: Record Contact;
        PriceListLine: Record "Price List line";
        Territory: Record Territory;
        Dimension: Record "Dimension Value";
        CustPrcGrp: Record "Customer Price Group";
        empRec: record Employee;
        URLsetup: Record "URL Setup";
    begin
        URLsetup.Get();
        MaxRetries := 3;
        RetryCount := 0;
        TimeoutMs := 120000;
        Client.Timeout(TimeoutMs);

        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Content-Encoding', 'UTF8');

        Contact.SetFilter("No.", Customer."Primary Contact No.");
        if Contact.FindFirst then begin
            customerJson.Add('primarycontactid', Contact."CRM ID");
        end;
        // DCS::HP 05082025 ++
        Dimension.Setrange(Code, Customer.Dimension);
        // DCS::HP 05082025 --
        if Dimension.FindFirst then begin
            customerJson.Add('dimensionid', Dimension."CRM ID");
        end;

        Currency.SetFilter(Code, Customer."Currency Code");
        if Currency.FindFirst then begin
            customerJson.Add('currencyid', Currency."CRM ID");
        end;

        Territory.SetFilter(Code, Customer."Territory Code");
        if Territory.FindFirst then begin
            customerJson.Add('territoryid', Territory."CRM ID");
        end;

        CustPrcGrp.SetFilter(Code, Customer."Customer Price Group");
        if CustPrcGrp.FindFirst then begin
            customerJson.Add('customerpricegroupid', CustPrcGrp."CRM ID");
        end;
        // DCS::HP 071025 ++
        customerJson.Add('bcid', Customer."Company Contact");
        customerJson.Add('crmid', Customer."CRM ID");
        customerJson.Add('d365accountid', Customer."D365 Account ID");
        customerJson.Add('sapcustomernumber', Customer."SAP Customer Number");
        customerJson.Add('name', Customer.Name);
        customerJson.Add('primarycontact', Customer."Primary Contact No.");
        customerJson.Add('phoneno', Customer."Phone No.");
        customerJson.Add('emailaddress', Customer."E-Mail");
        customerJson.Add('web', Customer.WEB);
        customerJson.Add('address', Customer.Address);
        customerJson.Add('address2', Customer."Address 2");
        customerJson.Add('address3', Customer."Address 3");
        customerJson.Add('addressname', Customer."Address Name");
        customerJson.Add('city', Customer."D365 City");
        customerJson.Add('state', Customer."D365 State");
        customerJson.Add('country', Customer."D365 Country");
        customerJson.Add('postcode', Customer."D365 Post Code");
        customerJson.Add('customerprofile', Format(Customer."Customer Profile"));
        // Error 09 oct
        customerJson.Add('customergroup', Format(Customer."Customer Price Group"));
        customerJson.Add('contactgroup', Format(Customer."Contact Group"));
        customerJson.Add('credithold', Customer."Credit Hold");
        customerJson.Add('creditlimit', Customer."Credit Limit (LCY)");
        customerJson.Add('paymentterms', Customer."Payment Terms Code");
        customerJson.Add('paymentmethod', Customer."Payment Method Code");
        customerJson.Add('abn', Customer."ABN");
        customerJson.Add('faxno', Customer."Fax No.");
        customerJson.Add('capexto', Customer."Capex To");
        customerJson.Add('capexfrom', Customer."Capex From");
        customerJson.Add('serviceagreement', Format(Customer."Service Agreement"));
        customerJson.Add('description', Customer.Description);
        customerJson.Add('supplieraccountgroup', Format(Customer."Supplier account Group"));
        customerJson.Add('customcontactid', Customer."Custom Contact Id");
        customerJson.Add('companycontact', Customer."Company Contact");
        // DCS::HP 20253107 ++
        // customerJson.Add('owner', Customer.Owner);
        // DCS::HP 06102025 ++
        empRec.Reset();
        empRec.SetRange("No.", Customer.Owner);
        if empRec.FindFirst() then
            customerJson.Add('owner', empRec."CRM ID");
        // DCS::HP 06102025 --
        customerJson.Add('ownership', Customer."Owner Ship");
        customerJson.Add('blockpaymenttolerance', Customer."Block Payment Tolerance");
        customerJson.Add('statusreason', Format(Customer."Reason Code"));
        // DCS::HP 20253107 --
        customerJson.Add('Add2Name', Customer."Address 2: Name");
        customerJson.Add('Add2Street1', Customer."Address 2: Street 1");
        customerJson.Add('Add2Street2', Customer."Address 2: Street 2");
        customerJson.Add('Add2Street3', Customer."Address 2: Street 3");
        customerJson.Add('Add2City', Customer."Address 2: City");
        customerJson.Add('Add2State', Customer."Address 2: State/Province");
        customerJson.Add('Add2ZIP', Customer."Address 2: ZIP/Postal Code");
        customerJson.Add('Add2Country', Customer."Address 2: Country/Region");
        customerJson.Add('BillingAccount', Customer."Billing Account");

        customerJson.WriteTo(jsonText);
        Content.WriteFrom(jsonText);

        repeat
            RetryCount += 1;
            Clear(Response);
            // DCS:: HP 19092025 URL changes ++ 
            // IsSuccessful := Client.Post('https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/8419dbcb99664b739f1ab25cb78b83c1/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=ekjd3OP61UorEZzKd3fAkPfLOS7525dvgxA58kvy5nQ', Content, Response);
            // URL FOR PROD
            // IsSuccessful := Client.Post('https://50d025741381eff5a32b0e86779aa4.c3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0997117ad0a94914b33a7239cb2a817f/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=fkOXPAGUHcLWLpViCEir4ibZGB4usW-b383QhsRmuCo', Content, Response);
            IsSuccessful := Client.Post(URLsetup."Customer URL", Content, Response);
            if IsSuccessful then begin
                Response.Content().ReadAs(ResponseText);

                if ResponseText <> '' then begin
                    if responseJson.ReadFrom(ResponseText) then begin
                        if ParseErrorMessage(ResponseText, ErrorMsg) then
                            Error('API Error: %1', ErrorMsg);

                        if responseJson.Get('crmid', tokenValue) then begin
                            if tokenValue.IsValue then begin
                                tokenString := tokenValue.AsValue().AsText();
                                Customer."CRM ID" := CopyStr(tokenString, 1, MaxStrLen(Customer."CRM ID"));
                                Customer.Modify(false);
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