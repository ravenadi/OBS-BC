codeunit 50112 "Contact Crm Management"
{
    procedure UpadeToCrm(Contact: Record Contact)
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        JObject: JsonObject;
        JsonText: Text;
        Customer: Record Customer;
        Vendor: Record Vendor;
        empRec: record Employee;
        responseJson: JsonObject;
        tokenValue: JsonToken;
        tokenString: Text;
        ErrorMsg: Text;
        RetryCount: Integer;
        MaxRetries: Integer;
        tokenValue1: JsonToken;
        tokenString1: text;
        URLsetup: Record "URL Setup";
    begin
        URLsetup.Get();
        // Initialize request content and headers
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        ContentHeaders.Add('Content-Encoding', 'UTF8');

        Customer.SetFilter(Name, Contact."Company Name");
        if Customer.FindFirst() then begin
            Contact."Company Name Crm" := Customer."CRM ID";
        end else begin
            Vendor.SetFilter(Name, Contact."Company Name");
            if Vendor.FindFirst() then begin
                Contact."Company Name Crm" := Vendor."CRM ID";
            end else begin
                Error('No matching customer or vendor found for the company name.');
            end;
        end;

        Contact.Modify();
        // DCS::HP 06102025 ++
        JObject.Add('code', Contact."No.");
        // DCS::HP 06102025 --
        JObject.Add('crmid', Contact."Crm Id");
        JObject.Add('companycontactid', Contact."Company Contact");
        JObject.Add('description', Contact.Description);
        JObject.Add('firstname', Contact."First Name");
        JObject.Add('middlemame', Contact."Middle Name");
        JObject.Add('Surname', Contact.Surname);
        JObject.Add('addressname', Contact."Address Name");
        JObject.Add('address', Contact.Address);
        JObject.Add('address2', Contact."Address 2");
        JObject.Add('address3', Contact."Address 3");
        JObject.Add('city', Contact.City);
        JObject.Add('state', Contact."D365 State");
        JObject.Add('county', Contact.County);
        JObject.Add('country', Contact."D365 Country");
        JObject.Add('postCode', Contact."Post Code");
        JObject.Add('faxno', Contact."Fax No.");
        JObject.Add('name', Contact.Name);
        JObject.Add('jobtitle', Contact."D365 Job Title");
        JObject.Add('phoneno', Contact."Phone No.");
        JObject.Add('email', Contact."E-Mail");
        JObject.Add('mobilephoneno', Contact."Mobile Phone No.");
        JObject.Add('dimensionid', Contact."Dimension ID");
        // DCS::HP 05082025 ++
        JObject.Add('emailgroupcode', Format(Contact."E-Mail Group Code"));
        // JObject.Add('companyname', Contact."Company Name");
        // JObject.Add('companyno', Contact."Company No.");
        JObject.Add('d365contactid', Contact."D365 Contact ID");
        JObject.Add('currency', Contact."Currency CRM Id");
        JObject.Add('territorycode', Contact."Territory Code");
        // DCS::HP 06102025 ++
        empRec.Reset();
        empRec.SetRange("No.", Contact.Owner);
        if empRec.FindFirst() then
            JObject.Add('owner', empRec."CRM ID");
        // JObject.Add('owner', Contact.Owner);
        // DCS::HP 06102025 --
        // DCS::HP30092025 ++
        JObject.Add('gender', contact.Gender);
        JObject.Add('PreferredMethodCont', contact."Preferred Method of Contact");
        JObject.Add('Email2', contact."E-Mail 2");
        JObject.Add('BusinessPhone2', contact."Business Phone 2");
        JObject.Add('PaymentMethod', contact."Payment Method");
        JObject.Add('Paymentterms', contact."Payment terms");
        JObject.Add('Add2Name', Contact."Address 2: Name");
        JObject.Add('Add2Street1', Contact."Address 2 Street 2");
        JObject.Add('Add2Street2', Contact."Address 2 Street 2");
        JObject.Add('Add2Street3', Contact."Address 2 Street 3");
        JObject.Add('Add2City', Contact."Address 2: City");
        JObject.Add('Add2State', Contact."Address 2: State/Province");
        JObject.Add('Add2ZIP', Contact."Address 2: ZIP/Postal Code");
        JObject.Add('Add2Country', Contact."Address 2: Country/Region");
        JObject.Add('fax', Contact.Fax);
        // DCS::HP 05082025 --
        // DCS::HP30092025 --

        JObject.WriteTo(JsonText);
        Content.WriteFrom(JsonText);

        repeat
            RetryCount += 1;
            Clear(Response);
            // DCS:: HP 19092025 URL changes ++ 
            // IsSuccessful := Client.Post(
            //     'https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/0eed1ce8d1754740895faf0421f02596/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=eQssP_bJK79O7PL3Ez7x14mCSep8h0psc_G-S0_nVIs',
            //     Content, Response);
            // URL FOR PROD
            // IsSuccessful := Client.Post(
            //     'https://50d025741381eff5a32b0e86779aa4.c3.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/e22272b1df244871a74307b86c9cb55b/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=McLpPBtIDgnlOBbfCTa6AU52t0CPtXWD896C26Qegeo',
            //     Content, Response);
            IsSuccessful := Client.Post(URLsetup."Contact URL", Content, Response);
            if IsSuccessful then begin
                Response.Content().ReadAs(ResponseText);
                if ResponseText <> '' then begin
                    if responseJson.ReadFrom(ResponseText) then begin
                        if ParseErrorMessage(ResponseText, ErrorMsg) then
                            Error('API Error: %1', ErrorMsg);

                        // DCS::HP 290925 ++

                        if responseJson.Get('crmid', tokenValue) then
                            if tokenValue.IsValue then begin
                                tokenString := tokenValue.AsValue().AsText();
                                Contact."CRM ID" := CopyStr(tokenString, 1, MaxStrLen(Contact."CRM ID"));
                            end;

                        if responseJson.Get('d365contactid', tokenValue1) then
                            if tokenValue1.IsValue then begin
                                tokenString1 := tokenValue1.AsValue().AsText();
                                Contact."D365 Contact ID" := CopyStr(tokenString1, 1, MaxStrLen(Contact."D365 Contact ID"));
                            end;

                        Contact.Modify(false);
                        exit;
                        // DCS::HP 290925 ++

                        // if responseJson.Get('crmid', tokenValue) then begin
                        //     if tokenValue.IsValue then begin
                        //         tokenString := tokenValue.AsValue().AsText();
                        //         Contact."CRM ID" := CopyStr(tokenString, 1, MaxStrLen(Contact."CRM ID"));
                        //         Contact.Modify(false);
                        //         exit;
                        //     end;
                        // end;
                        // Error('Response does not contain valid CRM ID. Full response: %1', ResponseText);
                        // if responseJson.Get('d365contactid', tokenValue1) then begin
                        //             if tokenValue1.IsValue then begin
                        //                 tokenString1 := tokenValue1.AsValue().AsText();
                        //                 Contact."D365 Contact ID" := CopyStr(tokenString1, 1, MaxStrLen(Contact."D365 Contact ID"));
                        //             end;
                        //         end;
                        //         Vendor.Modify(false);
                        //         exit;
                        //     end;
                        // end;
                        // Error('Response does not contain valid D365 Account ID. Full response: %1', ResponseText);
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