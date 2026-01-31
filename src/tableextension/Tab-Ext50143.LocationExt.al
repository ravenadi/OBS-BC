tableextension 50143 "Location Ext" extends Location
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "Crm Id"; Text[100])
        {
            Caption = 'Crm Id';
            DataClassification = ToBeClassified;
        }
        field(50102; "D365 City"; Text[50])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(50103; "D365 State"; Text[50])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(50104; "D365 Country"; Text[50])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }
        field(50105; "D365 Postal Code"; Text[50])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
        }
        field(50106; "Address Name"; Text[50])
        {
            Caption = 'Address Name';
            DataClassification = ToBeClassified;
        }
        field(50107; "Address 3"; Text[50])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
        }
        field(50108; "Adjustment Crm Id"; Text[50])
        {
            Caption = 'Adjustment Crm Id';
            DataClassification = ToBeClassified;
        }
        field(50109; Description; Text[200])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50110; Owner; Code[200])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(50111; Dimension; Code[200])
        {
            Caption = 'Dimension';
            DataClassification = ToBeClassified;
        }
        field(50112; "D365 Warehouse Name"; Text[200])
        {
            Caption = 'D365 Warehouse Name';
            DataClassification = ToBeClassified;
        }
    }

    trigger OnModify()
    begin
        UpdateStandardFields();
    end;

    trigger OnAfterInsert()
    begin
        UpdateStandardFields();
    end;

    local procedure UpdateStandardFields()
    begin
        "City" := "D365 City";
        County := "D365 State";
        "Country/Region Code" := "D365 Country";
        "Post Code" := "D365 postal Code";
    end;

    trigger OnAfterModify()
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        IsSuccessful: Boolean;
        Response: HttpResponseMessage;
        ResponseText: Text;
        json: JsonObject;
        responsejson: JsonObject;
        jsontext: Text;
        tokenvalue: JsonToken;
        tokenstring: Text;
    begin
        Content.GetHeaders(ContentHeaders);

        if not ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Add('Content-Type', 'application/json');

        if not ContentHeaders.Contains('Content-Encoding') then
            ContentHeaders.Add('Content-Encoding', 'UTF8');

        json.Add('crmid', Rec."Crm Id");
        json.Add('adjustmentcrmid', Rec."Adjustment Crm Id");
        json.Add('locationid', Rec.Code);
        json.Add('name', Rec.Name);
        json.Add('addressname', Rec."Address Name");
        json.Add('address1', Rec."Address");
        json.Add('address2', Rec."Address 2");
        json.Add('address3', Rec."Address 3");
        json.Add('city', Rec."D365 City");
        json.Add('state', Rec."D365 State");
        json.Add('country', Rec."D365 Country");
        json.Add('postcode', Rec."D365 Postal Code");
        // DCS:: HP 23092025 ++
        json.Add('Description', Rec.Description);
        json.Add('Owner', Rec.Owner);
        json.Add('Dimension', Rec.Dimension);
        // DCS:: HP 23092025 --

        json.WriteTo(jsontext);
        Content.WriteFrom(jsontext);
        // DCS:: HP 19092025 URL changes ++ 
        IsSuccessful := Client.Post('https://113311c04185ef33bd7fdd5579537b.cc.environment.api.powerplatform.com:443/powerautomate/automations/direct/workflows/95387ab15f0f45eea5ff5c30359c374a/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=Y5E9ye6F6DGpC76g3O_9wc4rNT2g2B7cBpu1p63NzOQ', Content, Response);
        if IsSuccessful then begin
            Response.Content().ReadAs(ResponseText);
            responsejson.ReadFrom(ResponseText);
            if responsejson.Contains('crmid') then begin
                responsejson.Get('crmid', tokenvalue);
                tokenstring := tokenvalue.AsValue().AsText();
                Rec."Crm Id" := Format(tokenstring);
                Rec.modify(false);
            end;
            if responsejson.Contains('adjustmentcrmid') then begin
                responsejson.Get('adjustmentcrmid', tokenvalue);
                tokenstring := tokenvalue.AsValue().AsText();
                Rec."Adjustment Crm Id" := Format(tokenstring);
                Rec.modify(false);
            end;
        end;
    end;
}