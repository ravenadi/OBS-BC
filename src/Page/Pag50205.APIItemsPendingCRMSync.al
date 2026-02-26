page 50205 "API Items Pending CRM Sync"
{
    // API to return items that need to be synced to CRM
    // Conditions:
    // 1. "Not Sync Item" = false
    // 2. AND (SystemModifiedAt > NOW - 24 hours OR SystemCreatedAt > NOW - 24 hours OR "CRM ID" = '')
    PageType = API;
    Caption = 'API Items Pending CRM Sync';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0';
    EntityName = 'ItemPendingCRMSync';
    EntitySetName = 'ItemsPendingCRMSync';
    SourceTable = Item;
    DelayedInsert = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(bcid; Rec."No.")
                {
                    Caption = 'BC Item No.';
                }

                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(description; Rec.Description)
                {
                    Caption = 'OBS Product Name';
                }
                field(customerproductname; Rec."OBS Item Name")
                {
                    Caption = 'Customer Product Name';
                }
                field(d365productid; Rec."D365 Product ID")
                {
                    Caption = 'D365 Product ID';
                }
                field(baseunitofmeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit Of Measure';
                }
                field(defaultunitid; GetUnitCRMId())
                {
                    Caption = 'Default Unit CRM ID';
                }
                field(defaultunitgroupid; GetUnitGroupCRMId())
                {
                    Caption = 'Default Unit Group CRM ID';
                }
                field(currency; Rec.Currency)
                {
                    Caption = 'Currency';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(currencyid; Rec."Currency Id")
                {
                    Caption = 'Currency ID';
                }
                field(vendorno; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorid; GetVendorCRMId())
                {
                    Caption = 'Vendor CRM ID';
                }
                field(vendorcatalogueno; Rec."Vendor 1 Catalogue Number")
                {
                    Caption = 'Vendor Catalogue Number';
                }
                field(postinggroup; Rec."Posting Group")
                {
                    Caption = 'Posting Group';
                }
                field(standardcost; Rec."Standard Cost")
                {
                    Caption = 'Standard Cost';
                }
                field(unitcost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitprice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(tradetype; GetTradeTypeCode())
                {
                    Caption = 'Trade Type Code';
                }
                field(type; GetFieldServiceTypeCode())
                {
                    Caption = 'Type';
                }
                field(fieldservicetype; GetFieldServiceTypeCode())
                {
                    Caption = 'Field Service Type Code';
                }
                field(producttype; GetProductTypeValue())
                {
                    Caption = 'Product Type';
                }
                field(sapitemnumber; Rec.SAPITEMID)
                {
                    Caption = 'SAP Item Number';
                }
                field(itemcategorycode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field(status; GetStatusCode())
                {
                    Caption = 'Status';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(owner; GetOwnerCRMId())
                {
                    Caption = 'Owner CRM ID';
                }
                field(obsproductdescription; GetLongDescription())
                {
                    Caption = 'OBS Product Description';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'System Created At';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'System Modified At';
                }
                field(notSyncItem; Rec."Not Sync Item")
                {
                    Caption = 'Not Sync Item';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterItemsForSync();
    end;

    local procedure FilterItemsForSync()
    begin
        // Filter: Not Sync Item must be false
        Rec.SetRange("Not Sync Item", false);

        // NOTE: DO NOT filter by SystemModifiedAt here!
        // The ShouldIncludeRecord() function handles the time-based filtering
        // along with the CRM ID empty check (OR condition)
        // If we filter here, old records with empty CRM ID will be excluded!
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        ItemFound: Boolean;
    begin
        ItemFound := Rec.Find(Which);
        if ItemFound then
            ItemFound := ShouldIncludeRecord();

        while (not ItemFound) and (Rec.Next() <> 0) do
            ItemFound := ShouldIncludeRecord();

        exit(ItemFound);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
        CurrentSteps: Integer;
    begin
        CurrentSteps := Rec.Next(Steps);
        if CurrentSteps = 0 then
            exit(0);

        ResultSteps := 0;
        repeat
            if ShouldIncludeRecord() then
                ResultSteps += 1
            else
                CurrentSteps := Rec.Next(1);
        until (ResultSteps = Abs(Steps)) or (CurrentSteps = 0);

        exit(ResultSteps);
    end;

    local procedure ShouldIncludeRecord(): Boolean
    var
        Last24Hours: DateTime;
    begin
        Last24Hours := CurrentDateTime - (24 * 60 * 60 * 1000);

        // Include if:
        // 1. Modified in last 24 hours
        // 2. OR Created in last 24 hours
        // 3. OR CRM ID is empty (never synced)
        exit((Rec.SystemModifiedAt > Last24Hours) or
             (Rec.SystemCreatedAt > Last24Hours) or
             (Rec."CRM ID" = ''));
    end;

    local procedure GetUnitCRMId(): Text
    var
        UOMRec: Record "Unit of Measure";
    begin
        if Rec."Base Unit of Measure" <> '' then
            if UOMRec.Get(Rec."Base Unit of Measure") then
                if UOMRec."CRM ID" <> '' then
                    exit('/uoms(' + UOMRec."CRM ID" + ')');
        exit('');
    end;

    local procedure GetUnitGroupCRMId(): Text
    var
        UOMRec: Record "Unit of Measure";
    begin
        if Rec."Base Unit of Measure" <> '' then
            if UOMRec.Get(Rec."Base Unit of Measure") then
                if UOMRec."Unitgroup CRM ID" <> '' then
                    exit('/uomschedules(' + UOMRec."Unitgroup CRM ID" + ')');
        exit('');
    end;

    local procedure GetVendorCRMId(): Text
    var
        VendorRec: Record Vendor;
    begin
        if Rec."Vendor No." <> '' then
            if VendorRec.Get(Rec."Vendor No.") then
                if VendorRec."CRM ID" <> '' then
                    exit('/accounts(' + VendorRec."CRM ID" + ')');
        exit('');
    end;

    local procedure GetOwnerCRMId(): Text
    var
        EmpRec: Record Employee;
    begin
        if Rec.Owner <> '' then begin
            EmpRec.Reset();
            EmpRec.SetRange("No.", Rec.Owner);
            if EmpRec.FindFirst() then
                exit(EmpRec."CRM ID");
        end;
        exit('');
    end;

    local procedure GetTradeTypeCode(): Text
    var
        TradeTypeText: Text;
    begin
        TradeTypeText := Format(Rec."Trade Type");
        case TradeTypeText of
            'Service Engineer Dual Trade':
                exit('888880000');
            'First-Year Apprentice':
                exit('888880001');
            'Second-Year Apprenctice':
                exit('888880002');
            'Third-Year Apprenctice':
                exit('888880003');
            'Fourth-Year Apprenctice':
                exit('888880004');
            else
                exit('888880000');
        end;
    end;

    local procedure GetFieldServiceTypeCode(): Text
    var
        FieldServiceType: Text;
    begin
        FieldServiceType := Format(Rec.Type);
        case FieldServiceType of
            'Inventory':
                exit('690970000');
            'Non-Inventory':
                exit('690970001');
            'Service':
                exit('690970002');
            else
                exit('');
        end;
    end;

    local procedure GetProductTypeValue(): Text
    begin
        if (Format(Rec."Product Type") <> '') and (Format(Rec."Product Type") <> '0') then begin
            if Format(Rec."Product Type") = ' ' then
                exit('1')
            else
                exit(Format(Rec."Product Type"));
        end else
            exit('1');
    end;

    local procedure GetLongDescription(): Text
    var
        InStr: InStream;
        DescriptionText: Text;
        TempText: Text;
    begin
        if Rec."D365 Item Description Blob".HasValue then begin
            Rec.CalcFields("D365 Item Description Blob");
            Rec."D365 Item Description Blob".CreateInStream(InStr, TextEncoding::UTF8);
            // Read entire stream, not just one line
            while not InStr.EOS do begin
                InStr.ReadText(TempText);
                if DescriptionText <> '' then
                    DescriptionText += ' ';
                DescriptionText += TempText;
            end;
            exit(DescriptionText);
        end;
        // If blob is empty, try the text field
        if Rec."D365 Item Description" <> '' then
            exit(Rec."D365 Item Description");
        exit('');
    end;

    local procedure GetStatusCode(): Text
    begin
        case Rec.Status of
            Rec.Status::Active:
                exit('0');
            Rec.Status::Draft:
                exit('1');
            Rec.Status::Retired:
                exit('2');
            Rec.Status::"Under Revision":
                exit('3');
            else
                exit('0');
        end;
    end;
}
