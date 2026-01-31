tableextension 50103 "Item Ext" extends Item
{
    fields
    {
        field(50100; "D365 Product ID"; Code[30])
        {
            Caption = 'D365 Product ID';
            DataClassification = ToBeClassified;
        }

        field(50101; "Vendor 1 Catalogue Number"; Text[100])
        {
            Caption = 'Vendor 1 Catalogue Number';
            DataClassification = ToBeClassified;
        }
        field(50102; "Trade Type"; enum "Apprentice Level")
        {
            Caption = 'Trade Type';
            DataClassification = ToBeClassified;
            // OptionCaption = 'Service Engineer Dual Trade,First-Year Apprentice,Second-Year Apprenctice,Third-Year Apprenctice,Fourth-Year Apprenctice';
            // OptionMembers = "Service Engineer Dual Trade","First-Year Apprentice","Second-Year Apprenctice","Third-Year Apprenctice","Fourth-Year Apprenctice";
        }
        field(50103; "OBS Item Name"; Text[100])
        {
            Caption = 'Customer Product Name';
            DataClassification = ToBeClassified;
        }
        field(50104; "Vendor Item Name"; Text[100])
        {
            Caption = 'Vendor Item Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor".Name WHERE("No." = FIELD("Vendor No.")));
        }
        field(50105; VendorName; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor".Name WHERE("No." = FIELD("Vendor No.")));
        }
        field(50106; QrCode; Blob)
        {
            Caption = 'Qr Code';
            DataClassification = ToBeClassified;
            Subtype = Bitmap;
        }
        field(50107; SAPITEMID; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50109; Currency; Code[30])              //lookup
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            // DCS::HP 05082025 ++
            trigger OnValidate()
            var
                currencyRec: Record Currency;
                GLSetup: Record "General Ledger Setup";
                //Gkblabs_Tv_22/12/25 ++
                currencyExchangeRate: Record "Currency Exchange Rate";
                exchangeRate: Decimal;
            begin
                if currencyRec.get(rec.Currency) then
                    "Currency Id" := currencyRec."CRM ID";

                // Gkblabs_Tv_19/12/25 ++
                // When currency changes to LCY, clear foreign currency fields
                GLSetup.Get();
                if (Currency = GLSetup."LCY Code") or (Currency = '') then begin
                    "Foreign Currency unit cost" := 0;
                    "Foreign Currency Unit Price" := 0;
                    //GKblabs_Tv_22/12/25 ++
                end else begin
                    // When currency changes to a foreign currency, recalculate Unit Cost and Unit Price
                    // if Foreign Currency unit cost or Unit Price already have values
                    if "Foreign Currency unit cost" <> 0 then begin
                        // Unit Cost remains unchanged - no exchange rate applied
                    end;

                    if "Foreign Currency Unit Price" <> 0 then begin
                        // Get exchange rate for new currency
                        currencyExchangeRate.SetRange("Currency Code", Currency);
                        currencyExchangeRate.SetFilter("Starting Date", '<=%1', WorkDate());
                        if currencyExchangeRate.FindLast() then begin
                            if currencyExchangeRate."Relational Exch. Rate Amount" <> 0 then
                                exchangeRate := currencyExchangeRate."Exchange Rate Amount" / currencyExchangeRate."Relational Exch. Rate Amount"
                            else
                                exchangeRate := currencyExchangeRate."Exchange Rate Amount";
                        end else
                            exchangeRate := 1;
                        // Apply exchange rate and add 7.5% markup to Unit Price
                        "Unit Price" := Round("Foreign Currency Unit Price" * exchangeRate * 1.075, GLSetup."Amount Rounding Precision");
                    end;
                end;
                // Gkblabs_Tv_19/12/25 --
            end;
            // DCS::HP 05082025 --
        }
        field(50110; "Posting Group"; enum "Sample Enum")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = "Sample1;Sample";
            // OptionCaption = 'Sample1,Sample2';
        }
        field(50111; "Vendor Id"; Text[100])   //lookup
        {
            DataClassification = ToBeClassified;

        }
        field(50112; "Product Type"; enum "Sales Category")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = "Sales Inventory","Miscellaneous Charges","Services","Flat Fees";
        }
        field(50113; "Product Structure"; enum "Sample Enum")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = "Sample1;Sample";
            // OptionCaption = 'Sample1,Sample2';
        }
        field(50114; Status; enum "Document Stage")
        {
            DataClassification = ToBeClassified;
            // OptionCaption = 'Draft,Active,Retired,Under Revision';
            // OptionMembers = "Draft","Active","Retired","Under Revision";
        }
        field(50115; "Currency Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50116; "Custom Vendor Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50117; "Base Unit Of Measure Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50118; "Unit"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;
        }
        field(50119; "Vendor Id CRM"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50120; "D365 Item Description"; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(50165; "D365 Item Description Blob"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'D365 Item Description Blob';
            Subtype = Memo;
        }
        field(50164; "Long Description"; Blob)
        {
            Caption = 'Long Description';
            Subtype = Memo;
            DataClassification = ToBeClassified;
        }
        field(50121; "Row"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Row';
        }
        field(50122; "Manufacturer Part Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Manufacturer Part Name';
        }
        field(50123; "Manufacturer Part No."; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Manufacturer Part No.';
        }
        field(50124; "Low Stock"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Low Stock';

        }
        // DCS::HP 290925 ++
        field(50125; Owner; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner';
            TableRelation = Employee."No.";
        }
        // DCS::HP 290925 --
        //DCS:: HJ 20250611 ++
        field(50126; "Not Sync Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Not Sync Item';
        }
        //Gkblabs_Tv_15/12/25 ++
        field(50159; "Foreign Currency unit cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Foreign Currency unit cost';

            trigger OnValidate()
            var
                currencyExchangeRate: Record "Currency Exchange Rate";
                GLSetup: Record "General Ledger Setup";
                exchangeRate: Decimal;
            begin
                // Gkblabs_Tv_19/12/25 ++
                // When Foreign Currency unit cost is entered, convert to Unit Cost and Last Direct Cost in LCY
                GLSetup.Get();
                if (Currency <> GLSetup."LCY Code") and (Currency <> '') then begin
                    // Get exchange rate from foreign currency to LCY
                    currencyExchangeRate.SetRange("Currency Code", Currency);
                    currencyExchangeRate.SetFilter("Starting Date", '<=%1', WorkDate());
                    if currencyExchangeRate.FindLast() then begin
                        // Standard BC exchange rate: 1 Foreign Currency = Exchange Rate Amount in LCY
                        // So to convert from foreign to LCY, we multiply by (Relational Exch. Rate Amount / Exchange Rate Amount)
                        if currencyExchangeRate."Exchange Rate Amount" <> 0 then
                            exchangeRate := currencyExchangeRate."Relational Exch. Rate Amount" / currencyExchangeRate."Exchange Rate Amount"
                        else
                            exchangeRate := 1;

                        "Unit Cost" := Round("Foreign Currency unit cost" * exchangeRate, GLSetup."Amount Rounding Precision");
                        "Last Direct Cost" := "Unit Cost";
                    end else begin
                        Error('No Exchange Rate found for currency %1 on or before %2. Please set up the exchange rate in Currency Exchange Rates.', Currency, WorkDate());
                    end;
                end else begin
                    "Unit Cost" := "Foreign Currency unit cost";
                    "Last Direct Cost" := "Unit Cost";
                end;
                // Gkblabs_Tv_19/12/25 --
            end;
        }
        field(50160; "Foreign Currency Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Foreign Currency Unit Price';

            trigger OnValidate()
            var
                currencyExchangeRate: Record "Currency Exchange Rate";
                GLSetup: Record "General Ledger Setup";
                exchangeRate: Decimal;
            begin
                // Gkblabs_Tv_19/12/25 ++
                // When Foreign Currency Unit Price is entered, convert to Unit Price in LCY
                GLSetup.Get();
                if (Currency <> GLSetup."LCY Code") and (Currency <> '') then begin
                    // Get exchange rate from foreign currency to LCY
                    currencyExchangeRate.SetRange("Currency Code", Currency);
                    currencyExchangeRate.SetFilter("Starting Date", '<=%1', WorkDate());
                    if currencyExchangeRate.FindLast() then begin
                        if currencyExchangeRate."Exchange Rate Amount" <> 0 then
                            exchangeRate := currencyExchangeRate."Relational Exch. Rate Amount" / currencyExchangeRate."Exchange Rate Amount"
                        else
                            exchangeRate := 1;

                        "Unit Price" := Round("Foreign Currency Unit Price" * exchangeRate * 1.075, GLSetup."Amount Rounding Precision");
                    end else begin
                        Error('No Exchange Rate found for currency %1 on or before %2. Please set up the exchange rate in Currency Exchange Rates.', Currency, WorkDate());
                    end;
                end else
                    "Unit Price" := Round("Foreign Currency Unit Price" * 1.075, GLSetup."Amount Rounding Precision");
                // Gkblabs_Tv_19/12/25 --
            end;
        }
        //Gkblabs_Tv_15/12/25 ++
        modify("Last Direct Cost")
        {
            trigger OnAfterValidate()
            var
                currencyExchangeRate: Record "Currency Exchange Rate";
                GLSetup: Record "General Ledger Setup";
                exchangeRate: Decimal;
            begin
                // When Last Direct Cost changes, update Unit Cost and recalculate Foreign Currency unit cost if currency is not LCY
                "Unit Cost" := "Last Direct Cost";
                GLSetup.Get();
                if (Currency <> GLSetup."LCY Code") and (Currency <> '') then begin
                    // Get exchange rate to convert from LCY to foreign currency
                    currencyExchangeRate.SetRange("Currency Code", Currency);
                    currencyExchangeRate.SetFilter("Starting Date", '<=%1', WorkDate());
                    if currencyExchangeRate.FindLast() then begin
                        if currencyExchangeRate."Exchange Rate Amount" <> 0 then
                            exchangeRate := currencyExchangeRate."Relational Exch. Rate Amount" / currencyExchangeRate."Exchange Rate Amount"
                        else
                            exchangeRate := 1;
                    end else
                        exchangeRate := 1;
                    "Foreign Currency unit cost" := Round("Last Direct Cost" * exchangeRate, GLSetup."Amount Rounding Precision");
                end else
                    "Foreign Currency unit cost" := 0;
            end;
        }
        //Gkblabs_Tv_15/12/25 --

        // Gkblabs_Tv_19/12/25 ++
        modify("Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                // When Unit Cost changes, recalculate Foreign Currency unit cost if currency is not LCY
                UpdateForeignCurrencyPrice();
            end;
        }

        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                // When Unit Price changes, recalculate Foreign Currency Unit Price if currency is not LCY
                UpdateForeignCurrencyUnitPrice();
            end;
        }
        // Gkblabs_Tv_19/12/25 --

    }

    fieldgroups
    {
        addlast(DropDown; "Vendor No.", "Vendor Item Name", "Vendor 1 Catalogue Number", "Alternative Item No.")
        {
        }
    }

    trigger OnInsert()
    begin
        UpdateLowStock();
    end;

    trigger OnModify()
    begin
        UpdateLowStock();
    end;

    procedure UpdateLowStock()
    begin
        CalcFields("Inventory");

        if "Inventory" <= "Reorder Point" then
            "Low Stock" := true
        else
            "Low Stock" := false;
    end;

    // Gkblabs_Tv_19/12/25 ++
    procedure UpdateForeignCurrencyPrice()
    var
        currencyExchangeRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        exchangeRate: Decimal;
    begin
        // When Unit Cost changes, recalculate Foreign Currency unit cost if currency is not LCY
        GLSetup.Get();
        if (Currency <> GLSetup."LCY Code") and (Currency <> '') then begin
            // Get exchange rate to convert from LCY to foreign currency
            currencyExchangeRate.SetRange("Currency Code", Currency);
            currencyExchangeRate.SetFilter("Starting Date", '<=%1', WorkDate());
            if currencyExchangeRate.FindLast() then begin
                if currencyExchangeRate."Exchange Rate Amount" <> 0 then
                    exchangeRate := currencyExchangeRate."Relational Exch. Rate Amount" / currencyExchangeRate."Exchange Rate Amount"
                else
                    exchangeRate := 1;
            end else
                exchangeRate := 1;
            "Foreign Currency unit cost" := Round("Unit Cost" * exchangeRate, GLSetup."Amount Rounding Precision");
        end else
            "Foreign Currency unit cost" := 0;
    end;

    procedure UpdateForeignCurrencyUnitPrice()
    var
        currencyExchangeRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        exchangeRate: Decimal;
    begin
        // When Unit Price changes, recalculate Foreign Currency Unit Price if currency is not LCY
        GLSetup.Get();
        if (Currency <> GLSetup."LCY Code") and (Currency <> '') then begin
            // Get exchange rate to convert from LCY to foreign currency
            currencyExchangeRate.SetRange("Currency Code", Currency);
            currencyExchangeRate.SetFilter("Starting Date", '<=%1', WorkDate());
            if currencyExchangeRate.FindLast() then begin
                if currencyExchangeRate."Exchange Rate Amount" <> 0 then
                    exchangeRate := currencyExchangeRate."Relational Exch. Rate Amount" / currencyExchangeRate."Exchange Rate Amount"
                else
                    exchangeRate := 1;
            end else
                exchangeRate := 1;
            // Remove 7.5% markup (divide by 1.075) and convert to foreign currency
            "Foreign Currency Unit Price" := Round(("Unit Price" / 1.075) * exchangeRate, GLSetup."Amount Rounding Precision");
        end else
            "Foreign Currency Unit Price" := 0;
    end;
    // Gkblabs_Tv_19/12/25 --

    procedure GetLongDescription(): Text[3000]
    var
        inS: InStream;
        longText: Text[3000];
    begin
        longText := '';
        if "Long Description".HasValue then begin
            "Long Description".CreateInStream(inS);
            inS.ReadText(longText);
        end;
        exit(longText);
    end;

    procedure SetLongDescription(Description: Text[3000])
    var
        outS: OutStream;
    begin
        "Long Description".CreateOutStream(outS);
        outS.WriteText(Description);
    end;

}