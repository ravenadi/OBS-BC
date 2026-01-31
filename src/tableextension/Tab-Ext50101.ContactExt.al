tableextension 50101 "Contact Ext" extends Contact
{
    fields
    {
        field(50100; "D365 State"; Text[200])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(50101; "D365 Country"; Text[200])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }
        field(50102; "D365 City"; Text[200])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(50103; "D365 Post Code"; Text[200])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
        }
        field(50104; "Address 3"; Text[200])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
        }
        field(50105; "Address Name"; Text[200])
        {
            Caption = 'Address Name';
            DataClassification = ToBeClassified;
        }
        field(50106; "Description"; Text[1000])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50107; "Dimension"; Code[200])
        {
            Caption = 'Dimension';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            trigger OnValidate()
            var
                DimensionRec: Record "Dimension Value";
            begin
                DimensionRec.SetRange(Code, rec.Dimension);
                if DimensionRec.findfirst then
                    "Dimension ID" := DimensionRec."CRM ID";
            end;
        }
        field(50108; "Dimension ID"; Text[200])
        {
            Caption = 'Dimension ID';
            DataClassification = ToBeClassified;
            // DCS::HP 13082025 ++
            trigger OnValidate()
            var
                DimensionRec: Record "Dimension Value";
            begin
                DimensionRec.SetRange("CRM ID", rec."Dimension ID");
                if DimensionRec.FindFirst() then
                    Dimension := DimensionRec.code;
            end;
            // DCS::HP 13082025 --
        }
        field(50109; "Currency CRM Id"; Text[200])
        {
            Caption = 'Currency CRM Id';
            DataClassification = ToBeClassified;
            // DCS::HP 13082025 ++
            trigger OnValidate()
            var
                currencyRec: Record Currency;
            begin
                currencyRec.SetRange("CRM ID", Rec."Currency CRM Id");
                if currencyRec.FindFirst() then
                    rec."D365 Currency Code" := currencyRec.Code;
            end;
            // DCS::HP 13082025 --
        }
        field(50110; "D365 Job Title"; Text[200])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
        }
        field(50111; "D365 Contact ID"; Text[200])
        {
            Caption = 'Contact ID';
            DataClassification = ToBeClassified;
        }
        field(50112; "E-Mail Group Code"; enum "Contact Role")
        {
            Caption = 'E-Mail Group Code';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Account Payable,Accounts,Billing,Billing + Maintenance,Energy,Head Office Contact,Maintenance,Management,Managing Director,Orders,Sales,Statements,Training,Worksheet Email';
            // OptionMembers = " ","Account Payable","Accounts","Billing","Billing + Maintenance","Energy","Head Office Contact","Maintenance","Management","Managing Director","Orders","Sales","Statements","Training","Worksheet Email";
        }

        field(50156; "Address 2: Name"; text[100])
        {
            Caption = 'Address 2: Name';
            DataClassification = ToBeClassified;
        }
        field(50113; "Address 2 Street1"; Text[200])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(50114; "Address 2 Street 2"; Text[200])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(50115; "Address 2 Street 3"; Text[200])
        {
            Caption = 'Address 3 Street 3';
            DataClassification = ToBeClassified;
        }
        field(50160; "Address 2: City"; text[100])
        {
            Caption = 'Address 2: City';
            DataClassification = ToBeClassified;
        }
        field(50161; "Address 2: State/Province"; text[100])
        {
            Caption = 'Address 2: State/Province';
            DataClassification = ToBeClassified;
        }
        field(50162; "Address 2: ZIP/Postal Code"; text[100])
        {
            Caption = 'Address 2: ZIP/Postal Code';
            DataClassification = ToBeClassified;
        }
        field(50163; "Address 2: Country/Region"; text[100])
        {
            Caption = 'Address 2: Country/Region';
            DataClassification = ToBeClassified;
        }
        field(50116; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 05082025 ++
        field(50117; "Company Contact"; Text[200])
        {
            Caption = 'Company Contact';
            DataClassification = ToBeClassified;
            // TableRelation = Customer."No.";
            TableRelation = if ("Contact Business Relation" = const(Customer)) Customer."No."
            else if ("Contact Business Relation" = const(Vendor)) Vendor."No.";
            trigger OnValidate()
            var
                CustomerRec: Record Customer;
                VendorRec: Record Vendor;
            begin
                // end;
                case Rec."Contact Business Relation" of
                    Rec."Contact Business Relation"::Customer:
                        begin
                            if CustomerRec.Get("Company Contact") then
                                "Company Name Crm" := CustomerRec.Name;
                        end;
                    Rec."Contact Business Relation"::Vendor:
                        begin
                            if VendorRec.Get("Company Contact") then
                                "Company Name Crm" := VendorRec.Name;
                        end;
                end;
            end;
        }
        field(50118; "Company Name Crm"; Text[200])
        {
            Caption = 'Company Name Crm';
            DataClassification = ToBeClassified;
        }
        field(50143; "D365 Currency Code"; Text[200])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
            // DCS::HP 05082025 ++
            trigger OnValidate()
            var
                currencyRec: Record Currency;
            begin
                if currencyRec.get(rec."D365 Currency Code") then
                    "Currency CRM Id" := currencyRec."CRM ID";
            end;
            // DCS::HP 05082025 --
        }
        // DCS::HP 05082025 --
        // DCS::HP 290925 ++
        field(50144; Owner; Text[200])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        // DCS::HP 290925 --

        field(50153; "Business Phone 2"; integer)
        {
            Caption = 'Business Phone 2';
            DataClassification = ToBeClassified;
        }
        field(50154; "Payment Method"; text[100])
        {
            Caption = 'Payment Method';
            DataClassification = ToBeClassified;
            // HK::DCS 061025 ++
            TableRelation = "Payment Method".Code;
            // HK::DCS 061025 --
        }
        field(50155; "Payment terms"; text[100])
        {
            Caption = 'Payment terms';
            DataClassification = ToBeClassified;
            // HK::DCS 061025 ++
            TableRelation = "Payment Terms".Code;
            // HK::DCS 061025 --
        }
        field(50164; "Fax"; text[100])
        {
            Caption = 'Fax';
            DataClassification = ToBeClassified;
        }
        field(50165; Gender; enum Gender)
        {
            Caption = 'Gender';
            DataClassification = ToBeClassified;
            // OptionCaption = 'Male,Female';
            // OptionMembers = "Male","Female";
        }
        // HK::DCS 061025 ++ Changed data type from text to enum 
        field(50166; "Preferred Method of Contact"; enum "Preferred Contact Enum")
        {
            Caption = 'Preferred Method of Contact';
            DataClassification = ToBeClassified;
        }
        
        // HK::DCS 061025 --

        // field(50152; "Email 2"; text[100])
        // {
        //     Caption = 'Email 2';
        //     DataClassification = ToBeClassified;
        // }


        // field(50157; "Address 2: Street 1"; text[100])
        // {
        //     Caption = 'Address 2: Street 1';
        //     DataClassification = ToBeClassified;
        // }
        // field(50158; "Address 2: Street 2"; text[100])
        // {
        //     Caption = 'Address 2: Street 2';
        //     DataClassification = ToBeClassified;
        // }
        // field(50159; "Address 2: Street 3"; text[100])
        // {
        //     Caption = 'Address 2: Street 3';
        //     DataClassification = ToBeClassified;
        // }


    }

    trigger OnAfterModify()
    var
        dimRec: Record "Dimension Value";
        customerRec: Record Customer;
        currencyRec: Record Currency;
        dimensionCode: text;
        customerCode: text;
        modified: Integer;
    begin

        modified := 0;

        if (Rec."Currency CRM Id" <> '') and (xRec."Currency CRM ID" <> Rec."Currency CRM ID") then begin
            currencyRec.SetFilter("CRM ID", Rec."Currency CRM ID");
            if currencyRec.FindFirst() then begin
                Rec."Currency Code" := currencyRec.Code;
                modified := modified + 1;
            end;




        end;

        if (Rec."Dimension ID" <> '') and (xRec."Dimension ID" <> Rec."Dimension ID") then begin
            dimRec.SetFilter("CRM ID", Rec."Dimension ID");
            if dimRec.FindFirst() then begin
                Rec.Dimension := dimRec.Code;
                modified := modified + 1;
            end;
        end;

        if modified > 0 then begin
            Rec.Modify(false);
        end;
    end;

    trigger OnModify()
    begin
        UpdateStandardFields();
    end;

    trigger OnAfterInsert()
    begin
        // addcurrencycrm();
        UpdateStandardFields();
    end;

    local procedure UpdateStandardFields()
    begin
        "City" := "D365 City";
        County := "D365 State";
        // DCS:: HP 13082025 ++
        // "Country/Region Code" := "D365 Country";
        // DCS:: HP 13082025 --
        "Post Code" := "D365 post Code";
    end;

    // DCS::HP 05082025 ++
    // local procedure addcurrencycrm()
    // var
    //     currencyRec: Record Currency;
    // begin
    //     if currencyRec.get(rec."Currency Code") then
    //         "Currency CRM Id" := currencyRec."CRM ID";
    // end;
    // DCS::HP 05082025 --

}