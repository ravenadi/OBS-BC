tableextension 50100 "Cutomer Ext" extends Customer
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
        field(50108; "Dimension ID"; Text[200])
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
        field(50109; "Currency Code Id"; Text[200])
        {
            Caption = 'Currency Code Id';
            DataClassification = ToBeClassified;
        }
        // 50110 to 50118 we are not use beacuse otherwise create issue to create customer from contact beacuse field is different so we can not use ID.
        field(50119; "Customer Profile"; enum "Industry Sector")
        {
            Caption = 'Customer Profile';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Agriculture,Beverages,Buildings,Chemical,Competition,Concrete,Consultants,Education,Engineer Procure Construct,Food,Government Organisation,Health Care,Hotel & Casinos,Laundry & Clean,Manufacturing,Materials Construction & Packaging,Mining and Precious Metals,N/A,OEM Machinery,Oil & Gas,Other,Packaging,Pet Food,Pharma & Biotech,Power Generation,Pulp & Paper,Recycling,Rubber & Plastic,SIG Affiliations,Service Providers,Service Retail,Social Services,Special Outbound Trade Contractors,Specialty Realty,Textiles,Timber And Forestry,Transportation,Utility Creation and Distribution,Vehicle Retail,Water and Waste,Wholesale';
            // OptionMembers = " ","Agriculture","Beverages","Buildings","Chemical","Competition","Concrete","Consultants","Education","Engineer Procure Construct","Food","Government Organisation","Health Care","Hotel & Casinos","Laundry & Clean","Manufacturing","Materials Construction & Packaging","Mining and Precious Metals","N/A","OEM Machinery","Oil & Gas","Other","Packaging","Pet Food","Pharma & Biotech","Power Generation","Pulp & Paper","Recycling","Rubber& Plastic","SIG Affiliations","Service Providers","Service Retail","Social Services","Special Outbound Trade Contractors","Specialty Realty","Textiles","Timber And Forestry","Transportation","Utility Creation and Distribution","Vehicle Retail","Water and Waste","Wholesale";
        }
        field(50120; "Supplier account Group"; enum "Business Function")
        {
            Caption = 'Supplier Account Group';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Accounting,Amenities,Boiler Ancillaries,Boiler Manufacturer,Burner Management,Communication,Competition,Consultants,Credit Cards,Electrical,Employees,Engineering,Equipment Rental,Freight & Transport,Gas Components,Inspection & Certification,IT,Legal,Motor Vehicles,Plumbing,Safety Equipment,Subcontractor,Tooling,Travel,Other,N/A';
            // OptionMembers = " ","Accounting","Amenities","Boiler Ancillaries","Boiler Manufacturer","Burner Management","Communication","Competition","Consultants","Credit Cards","Electrical","Employees","Engineering","Equipment Rental","Freight & Transport","Gas Components","Inspection & Certification","IT","Legal","Motor Vehicles","Plumbing","Safety Equipment","Subcontractor","Tooling","Travel","Other","N/A";
        }
        field(50121; "D365 Account ID"; Text[200])
        {
            Caption = 'D365 Account ID';
            DataClassification = ToBeClassified;
        }
        field(50122; "SAP Customer Number"; Text[200])
        {
            Caption = 'SAP Customer Number';
            DataClassification = ToBeClassified;
        }
        field(50123; "Service Agreement"; enum "Subscription Plan")
        {
            Caption = 'Service Agreement';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Basic,Pro';
            // OptionMembers = " ","Basic","Pro";
        }
        field(50124; "Account Contract Manager"; Text[200])
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
        field(50127; "ABN No."; Text[200])
        {
            Caption = 'ABN No';
            DataClassification = ToBeClassified;

        }
        field(50128; "Customer group"; enum "Membership Level")
        {
            Caption = 'Customer Group';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Platinum,Gold,Silver,Bronze,N/A';
            // OptionMembers = " ",Platinum,Gold,Silver,Bronze,"N/A";
            ObsoleteState = Removed;
        }
        field(50129; "Contact Group"; enum "Party Type")
        {
            Caption = 'Contact Group';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Competitor,Consultant,Customer,Influencer,Investor,Manufacturer,Partner,Press,Prospect,Reseller,Sub Contractor,Vendor,Others';
            // OptionMembers = " ",Competitor,Consultant,Customer,Influencer,Investor,Manufacturer,Partner,Press,Prospect,Reseller,"Sub Contractor",Vendor,Others;
        }
        field(50130; "Credit Hold"; Boolean)
        {
            Caption = 'Credit Hold';
            DataClassification = ToBeClassified;
        }

        field(50131; "Import Serial No"; Text[200])
        {
            Caption = 'Import Serial No';
            DataClassification = toBeClassified;
        }
        field(50132; "Owner Ship"; enum "Company Type")
        {
            Caption = 'Owner Ship';
            // OptionCaption = ' ,Private,Public,Subsidary,Other';
            // OptionMembers = " ",Private,Public,Subsidary,Other;
        }
        field(50133; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50134; "Account Contract Manager ID"; Text[200])
        {
            Caption = 'Account Contract Manager ID';
            DataClassification = ToBeClassified;
        }
        field(50135; WEB; Text[200])
        {
            Caption = 'Web';
            DataClassification = ToBeClassified;
        }
        field(50136; "Contact Code"; Code[200])
        {
            Caption = 'Caption Code';
            DataClassification = ToBeClassified;
            TableRelation = Contact;
        }
        field(50137; "Customer Price Group Id"; Text[200])
        {
            Caption = 'Customer Price Group Id';
            DataClassification = ToBeClassified;
        }
        field(50138; "Custom Contact Id"; Text[200])
        {
            Caption = 'Custom Contact Id';
            DataClassification = ToBeClassified;
        }
        field(50139; Territory; Code[200])
        {
            Caption = 'Territory';
            DataClassification = ToBeClassified;
        }
        field(50140; "Territory Code ID"; Text[200])
        {
            Caption = 'Territory Code ID';
            DataClassification = ToBeClassified;
        }
        field(50141; "Territory Id"; Text[200])
        {
            Caption = 'Territory Id';
            DataClassification = ToBeClassified;
        }
        field(50142; "Company Contact"; Text[200])
        {
            Caption = 'Company Contact';
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact"."No." WHERE("Name" = FIELD(Name)));
        }
        field(50143; "Owner Id"; Text[200])
        {
            Caption = 'Owner Id';
            DataClassification = ToBeClassified;
        }
        field(50144; "Owner"; Code[200])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(50145; "Parent Account"; Text[200])
        {
            Caption = 'Parent Account';
            DataClassification = ToBeClassified;
        }
        field(50146; "Parent Account CRM ID"; Text[200])
        {
            Caption = 'Parent Account CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50147; "Vendor No."; Code[200])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
            DataClassification = ToBeClassified;
        }
        field(50148; "Reason Code"; enum "Approval Status1")
        {
            Caption = 'Reason Code';
            DataClassification = ToBeClassified;
            // OptionCaption = ' ,Active,Pending,Inactive';
            // OptionMembers = " ",Active,Pending,Inactive,;
        }
        field(50110; "Custom No"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        // DCS::HP 19092025 ++
        field(50111; "Customer Statement Email"; Text[250])
        {
            Caption = 'Customer Statement Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Custom Report Selection"."Send To Email"
                                 where("Source No." = field("No."),
                                       Usage = const("Report Selection Usage"::"C.Statement")));
        }
        // DCS::HP 19092025 --
        field(50156; "Address 2: Name"; text[100])
        {
            Caption = 'Address 2: Name';
            DataClassification = ToBeClassified;
        }
        field(50113; "Address 2: Street 1"; text[100])
        {
            Caption = 'Address 2: Street 1';
            DataClassification = ToBeClassified;
        }
        field(50114; "Address 2: Street 2"; text[100])
        {
            Caption = 'Address 2: Street 2';
            DataClassification = ToBeClassified;
        }
        field(50115; "Address 2: Street 3"; text[100])
        {
            Caption = 'Address 2: Street 3';
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
        field(50162; "Address 2: ZIP/Postal Code"; Text[100])
        {
            Caption = 'Address 2: ZIP/Postal Code';
            DataClassification = ToBeClassified;
        }
        field(50163; "Address 2: Country/Region"; text[100])
        {
            Caption = 'Address 2: Country/Region';
            DataClassification = ToBeClassified;
        }
        field(50158; "Billing Account"; text[100])
        {
            Caption = 'Billing Account';
            DataClassification = ToBeClassified;
        }

    }

    fieldgroups
    {
        addlast(DropDown; "Custom No")
        {

        }
    }
    trigger OnAfterInsert()
    begin
        UpdateStandardFields();
    end;

    local procedure UpdateStandardFields()
    begin
        "City" := "D365 City";
        County := "D365 State";
        "Country/Region Code" := "D365 Country";
        "Post Code" := "D365 Post Code";
    end;

    trigger OnAfterModify()
    var
        dimRec: Record "Dimension Value";
        customerRec: Record Customer;
        currencyRec: Record Currency;
        contactRec: Record Contact;
        territoryRec: Record Territory;
        modified: Integer;
    begin

        UpdateStandardFields();

        modified := 0;
        // Check if field has changed and is not empty
        if (Rec."CRM ID" <> '') and (xRec."CRM ID" <> Rec."CRM ID") then begin
            contactRec.SetFilter("CRM ID", Rec."CRM ID");
            if contactRec.FindFirst() then begin
                Rec."Company Contact" := contactRec."No.";
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
                Rec.Dimension := dimRec.Code;
                modified := modified + 1;
            end;
        end;
        if (Rec."Territory Code ID" <> '') and (xRec."Territory Code ID" <> Rec."Territory Code ID") then begin
            territoryRec.SetFilter("CRM ID", Rec."Territory Code ID");
            if territoryRec.FindFirst() then begin
                Rec.Territory := territoryRec.Code;
                modified := modified + 1;
            end;
        end;
        if modified > 0 then begin
            Rec.Modify(false);
        end;
    end;

}