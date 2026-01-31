tableextension 50102 "Vendor Ext" extends Vendor
{

    fields
    {
        // modify("Gen. Bus. Posting Group")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         if "Gen. Bus. Posting Group" = 'Domestic' then begin
        //             rec.Validate("Currency Code", '');
        //         end;
        //     end;
        // }
        // DCS::HP 10092025 ++
        modify("Country/Region Code")
        {

            trigger OnAfterValidate()
            var
                countryRec: Record "Country/Region";
            begin
                countryRec.Reset();
                countryRec.SetRange(code, "Country/Region Code");
                if countryRec.FindFirst() then begin
                    "D365 Country" := countryRec.Name;
                    Modify(true);
                end;
            end;
        }
        // DCS::HP 10092025 --
        field(50100; "D365 State"; Text[100])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(50101; "D365 Country"; Text[100])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
            // TableRelation = "Country/Region".Name;
        }
        field(50102; "D365 City"; Text[100])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(50103; "D365 Postal Code"; Text[100])
        {
            Caption = 'PostCode';
            DataClassification = ToBeClassified;
        }
        field(50104; "Address 3"; Text[100])
        {
            Caption = 'Address 3';
        }
        field(50105; "Address Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Description"; Text[1000])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(50107; "Dimension"; Text[100])
        {
            Caption = 'Dimension';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            // DCS::HP 14082025 ++
            trigger OnValidate()
            var
                DimensionRec: Record "Dimension Value";
            begin
                DimensionRec.SetRange(Code, rec.Dimension);
                if DimensionRec.findfirst then
                    "Dimension ID" := DimensionRec."CRM ID";
            end;
            // DCS::HP 14082025 --
        }
        field(50108; "Dimension ID"; Text[100])
        {
            Caption = 'Dimension ID';
            DataClassification = ToBeClassified;
            // DCS::HP 14082025 ++
            trigger OnValidate()
            var
                DimensionRec: Record "Dimension Value";
            begin
                DimensionRec.SetRange("CRM ID", rec."Dimension ID");
                if DimensionRec.FindFirst() then
                    Dimension := DimensionRec.code;
            end;
            // DCS::HP 14082025 --
        }
        field(50109; "Currency Code Id"; Text[100])
        {
            Caption = 'Currency Code Id';
            DataClassification = ToBeClassified;
        }
        field(50110; "D365 Job Title"; Text[200])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
        }
        field(50116; "CRM Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50117; "Company Conatct"; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact"."No." WHERE("Name" = FIELD(Name)));
        }
        field(50119; "Vendor Profile"; enum "Industry Sector")
        {
            Caption = 'Vendor Profile';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Agriculture,Beverages,Buildings,Chemical,Competition,Concrete,Consultants,Education,Engineer Procure Construct,Food,Government Organisation,Health Care,Hotel & Casinos,Laundry & Clean,Manufacturing,Materials Construction & Packaging,Mining and Precious Metals,N/A,OEM Machinery,Oil & Gas,Other,Packaging,Pet Food,Pharma & Biotech,Power Generation,Pulp & Paper,Recycling,Rubber & Pastic,SIG Affiliations,Service Providers,Service Retail,Social Services,Special Outbound Trade Contractors,Specialty Realty,Textiles,Timber And Forestry,Transportation,Utility Creation and Distribution,Vehicle Retail,Water and Waste,Wholesale';
            // OptionMembers = " ","Agriculture","Beverages","Buildings","Chemical","Competition","Concrete","Consultants","Education","Engineer Procure Construct","Food","Government Organisation","Health Care","Hotel & Casinos","Laundry & Clean","Manufacturing","Materials Construction & Packaging","Mining and Precious Metals","N/A","OEM Machinery","Oil & Gas","Other","Packaging","Pet Food","Pharma & Biotech","Power Generation","Pulp & Paper","Recycling","Rubber& Pastic","SIG Affiliations","Service Providers","Service Retail","Social Services","Special Outbound Trade Contractors","Specialty Realty","Textiles","Timber And Forestry","Transportation","Utility Creation and Distribution","Vehicle Retail","Water and Waste","Wholesale";
        }
        field(50120; "Supplier account Group"; enum "Business Function")
        {
            Caption = 'Supplier account Group';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Accounting,Amenities,Boiler Ancillaries,Boiler Manufacturer,Burner Management,Communication,Competition,Consultants,Credit Cards,Electrical,Employees,Engineering,Equipment Rental,Freight & Transport,Gas Components,Inspection & Certification,IT,Legal,Motor Vehicles,Plumbing,Safety Equipment,Subcontractor,Tooling,Travel,Other,N/A';
            // OptionMembers = " ","Acctunting","Amenities","Boiler Ancillaries","Boiler Manufacturer","Burner Management","Communication","Competition","Consultants","Credit Cards","Electrical","Employees","Engineering","Equipment Rental","Freight & Transport","Gas Components","Inspection & Certification","IT","Legal","Motor Vehicles","Plumbing","Safety Equipment","Subcontractor","Tooling","Travel","Other","N/A";
        }
        field(50121; "D365 Account ID"; Text[100])
        {
            Caption = 'D365 Account ID';
            DataClassification = ToBeClassified;
        }
        field(50122; "SAP Vendor Number"; Text[100])
        {
            Caption = 'SAP Vendor Number';
            DataClassification = ToBeClassified;
        }
        field(50123; "Service Agreement"; enum "Subscription Plan")
        {
            Caption = 'Service Agreement';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Basic,Pro';
            // OptionMembers = " ","Basic","Pro";
        }
        field(50124; "Account Contract Manager"; Text[100])
        {
            Caption = 'Account Contract Manager';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(50125; "Capex From"; Date)
        {
            Caption = 'Capex From';
            DataClassification = ToBeClassified;
        }
        field(50126; "Capex To"; Date)
        {
            Caption = 'Capex To';
            DataClassification = ToBeClassified;
        }
        field(50127; "ABN No."; Text[100])
        {
            Caption = 'ABN No';
            DataClassification = ToBeClassified;
        }
        field(50128; "Customer Group"; enum "Membership Level")
        {
            Caption = 'Customer Group';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Platinum,Gold,Silver,Bronze,N/A';
            // OptionMembers = " ",Platinum,Gold,Silver,Bronze,"N/A";
        }
        field(50129; "Contact Groups"; enum "Party Type")
        {
            Caption = 'Contact Groups';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Competitor,Consultant,Customer,Influencer,Investor,Manufacturer,Partner,Press,Prospect,Reseller,Sub Contractor,Vendor,Others';
            // OptionMembers = " ",Competitor,Consultant,Customer,Influencer,Investor,Manufacturer,Partner,Press,Prospect,Reseller,"Sub Contractor",Vendor,Others;
        }
        field(50130; "Credit Hold"; Boolean)
        {
            Caption = 'Credit Hold';
            DataClassification = ToBeClassified;
        }
        field(50131; "Owner Ship"; enum "Company Type")
        {
            Caption = 'Owner Ship';
            // OptionCaption = ' ,Private,Public,Subsidary,Other';
            // OptionMembers = " ",Private,Public,Subsidary,Other;
        }

        field(50132; State; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50144; "Owner"; Code[30])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(50134; "Parent Account"; Text[100])
        {
            Caption = 'Parent Account';
            DataClassification = ToBeClassified;
        }
        field(50135; "Is Also a Customer"; Boolean)
        {
            Caption = 'Is Also a Customer';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                CreateCustomerFromVendor: Codeunit "Create Customer From Vendor";
            begin
                if "Is Also a Customer" then
                    CreateCustomerFromVendor.HandleVendorModification(Rec, Rec);
            end;
        }

        field(50136; WEB; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50137; "Account Contract Manager Id"; Text[100])
        {
            Caption = 'Account Contract Manager ID';
            DataClassification = ToBeClassified;
        }
        field(50138; Territory; Code[20])
        {
            Caption = 'Territory';
            DataClassification = ToBeClassified;
        }
        field(50139; "Territory Code Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }

        field(50140; "Custom Contact Id"; Text[100])
        {
            Caption = 'Custom Contact Id';
            DataClassification = ToBeClassified;
        }
        field(50141; "Owner Id"; Text[100])
        {
            Caption = 'Owner Id';
            DataClassification = ToBeClassified;
        }
        field(50142; "Reason Code"; enum "Approval Status1")
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Active,Pending,Inactive';
            // OptionMembers = " ",Active,Pending,Inactive,;
        }
        // DCS::HP 14082025 ++
        field(50150; "Primary Contact ID"; text[200])
        {
            Caption = 'Primary Contact ID';
            DataClassification = ToBeClassified;
        }
        field(50151; "Credit Limit"; Decimal)
        {
            Caption = 'Credit Limit';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 19092025 ++
        field(50152; "Vendor Remittance Email"; Text[250])
        {
            Caption = 'Vendor Remittance Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Custom Report Selection"."Send To Email"
                                 where("Source No." = field("No."),
                                       Usage = const("Report Selection Usage"::"V.Remittance")));
        }
        // DCS::HP 19092025 --

    }

    trigger OnAfterModify()
    var
        dimRec: Record "Dimension Value";
        customerRec: Record Customer;
        currencyRec: Record Currency;
        contactRec: Record Contact;
        territoryRec: Record Territory;
        modified: Integer;
    begin

        modified := 0;
        // Check if field has changed and is not empty
        if (Rec."CRM Id" <> '') and (xRec."CRM Id" <> Rec."CRM Id") then begin
            contactRec.SetFilter("CRM ID", Rec."CRM Id");
            if contactRec.FindFirst() then begin
                Rec."Primary Contact No." := contactRec."No.";
                modified := modified + 1;
            end;
        end;

        if (Rec."Currency Code Id" <> '') and (xRec."Currency Code Id" <> Rec."Currency Code Id") then begin
            currencyRec.SetFilter("CRM ID", Rec."Currency Code Id");
            if currencyRec.FindFirst() then begin
                Rec."Currency Code" := currencyRec.Code;
                modified := modified + 1;
            end;
        end;

        if (Rec."Dimension ID" <> '') and (xRec."Dimension ID" <> Rec."Dimension ID") then begin
            dimRec.SetFilter("CRM ID", Rec."Dimension ID");
            if dimRec.FindFirst() then begin
                Rec."Global Dimension 1 Code" := dimRec.Code;
                modified := modified + 1;
            end;
        end;

        if (Rec."Territory Code ID" <> '') and (xRec."Territory Code ID" <> Rec."Territory Code ID") then begin
            territoryRec.SetFilter("CRM ID", Rec."Territory Code ID");
            if territoryRec.FindFirst() then begin
                Rec."Territory Code" := territoryRec.Code;
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
    var
        UserSetupRec: Record "User Setup";
        EmpREC: Record Employee;
    begin
        UpdateStandardFields();
        ////Pankaj_10Oct2025 + //Owner Data Will Be come form Employee Table 
        // if UserSetupRec.Get(UserId()) then begin
        //     rec.owner := UserSetupRec."User ID";
        //     rec.Modify();

        if UserSetupRec.Get(UserId()) then begin
            EmpREC.Reset();
            EmpREC.SetRange("No.", UserSetupRec."User Employee No.");
            IF EmpREC.FindFirst() then begin
                rec.owner := EmpREC."No.";
                rec.Modify();
            end;
        end;
        ////Pankaj_10Oct2025 -

    end;

    local procedure UpdateStandardFields()
    begin
        "City" := "D365 City";
        County := "D365 State";
        // "Country/Region Code" := "D365 Country";
        "Post Code" := "D365 postal Code";
    end;

}