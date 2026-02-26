tableextension 50104 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50102; Name; Text[300])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name';
        }
        field(50103; "Unit of Measure Code CRMID"; Text[100])
        {
            Caption = 'Unit of Measure Code CRMID';
            DataClassification = ToBeClassified;
        }
        field(50104; "Unit of Measure Code"; Text[100])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
        }
        field(50105; "Unit Cost CRMID"; Text[100])
        {
            Caption = 'Unit Cost CRMID';
            DataClassification = ToBeClassified;
        }
        field(50106; "Customer CRMID"; Text[100])
        {
            Caption = 'Customer CRMID';
            DataClassification = ToBeClassified;
        }
        field(50107; "Bill-to address name"; Text[100])
        {
            Caption = 'Address Name';
            DataClassification = ToBeClassified;
        }
        field(50108; "Currency CRM ID"; Text[100])
        {
            Caption = 'Currency CRM ID';
            DataClassification = ToBeClassified;



        }
        field(50109; Owner; Text[100])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            //DCS ::HJ20251030++
            trigger OnLookup()
            var
                Employee: Record Employee;
                EmployeeList: Page "Employee List";
            begin
                Employee.Reset();
                if Page.RunModal(Page::"Employee List", Employee) = Action::LookupOK then begin
                    Rec.Owner := Employee."No.";
                    Rec.Owner := StrSubstNo('%1 %2', Employee."First Name", Employee."Last Name");
                end;
            end;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Rec.Owner <> '' then begin
                    if Employee.Get(Rec.Owner) then
                        Rec.Owner := StrSubstNo('%1 %2', Employee."First Name", Employee."Last Name")
                    else
                        Error('Employee %1 does not exist.', Rec.Owner);
                end;
            end;
            //DCS ::HJ20251030--


        }
        field(50110; "Owner CRMID"; Text[100])
        {
            Caption = 'Owner CRMID';
            DataClassification = ToBeClassified;
            ////Pankaj_10Oct2025 +
            trigger OnValidate()
            var
                USerSetUp: Record "User Setup";
            begin
                USerSetUp.Reset();
                USerSetUp.SetRange("CRM ID", Rec."Owner CRMID");
                IF USerSetUp.FindFirst() then
                    Rec.Owner := USerSetUp."User ID";
            end;
            //Pankaj_10Oct2025--
        }
        field(50111; Dimension; Text[100])
        {
            Caption = 'Dimension';
            DataClassification = ToBeClassified;
        }
        field(50112; "Dimension CRM ID"; Text[100])
        {
            Caption = 'Dimension CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50113; "Price List"; Text[100])
        {
            Caption = 'Price List';
            DataClassification = ToBeClassified;
        }
        field(50114; "Quote"; Text[100])
        {
            Caption = 'Quote';
            DataClassification = ToBeClassified;
        }
        field(50115; "Quote CRM ID"; Text[100])
        {
            Caption = 'Quote CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50116; "Opportunity"; Text[100])
        {
            Caption = 'Opportunity';
            DataClassification = ToBeClassified;
        }
        field(50117; "Opportunity CRM ID"; Text[100])
        {
            Caption = 'Opportunity CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50118; "Lead Type"; enum "Service Category")
        {
            Caption = 'Lead Type';
            DataClassification = ToBeClassified;
            // OptionMembers = " ","Service/Parts",Training,Energy,Sales,"N/A";
        }
        field(50119; "Work Order Type"; Text[100])
        {
            Caption = 'Work Order Type';
            DataClassification = ToBeClassified;
            TableRelation = "GKB Work Order Type";
        }
        field(50120; "Freight Amount"; Text[100])
        {
            Caption = 'Freight Amount';
            DataClassification = ToBeClassified;
        }
        field(50121; "Freight Terms"; enum "Custom Enum 30")
        {
            Caption = 'Freight Terms';
            // OptionMembers = " ","100000001","100000000","100000002","100000003","100000004","100000005","100000006","100000007","100000008","100000009","100000010","100000011","100000012","100000013","1","2";
            // OptionCaption = ' ,CIF,CFR,CIP,CPT,DAF,DDP,DDU,DELIVERY,DEQ,DES,EXW,FAS,FCA,PICKUP,FOB,No Charge';
            DataClassification = ToBeClassified;
        }
        field(50122; "Creation Method"; enum "Custom Enum 31")
        {
            Caption = 'Creation Method';
            // OptionMembers = " ","776160000","776160001";
            // OptionCaption = ' ,Unknown,Win Quote';
            DataClassification = ToBeClassified;
        }
        field(50123; "Ship-to Address 3"; Text[100])
        {
            Caption = 'Ship-to Address 3';
            DataClassification = ToBeClassified;
        }
        field(50124; "D365 Bill-To State"; Text[100])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(50125; "D365 Bill-to country"; Text[100])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }
        field(50126; "D365 City"; Text[100])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(50127; "D365 Bill-to Post Code"; Text[100])
        {
            Caption = 'Bill-To Post Code';
            DataClassification = ToBeClassified;
        }
        field(50128; "D365 ShiptoCountry/RegionCode"; Text[50])
        {
            Caption = 'Ship-to Country/Region Code';
        }
        field(50129; "D365 Ship-to Post Code"; Text[100])
        {
            Caption = 'Ship-to Post Code';
        }

        field(50150; "Work Details"; Blob)
        {
            Caption = 'Work Details';
            DataClassification = ToBeClassified;
            ObsoleteState = Removed;
            // ExtendedDatatype= RichContent
        }
        field(50151; RichText; Blob)
        {
            Caption = 'Rich Text';
            DataClassification = CustomerContent;
        }
        field(50152; "D365 Bill-to Address 3"; Text[100])
        {
            Caption = 'Bill-to Address 3';
        }
        field(50153; "Sales Order Name"; Text[100])
        {
            Caption = 'Sales Order Name';
            ObsoleteState = Pending;
        }
        field(50154; "Invoice Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice Created';
        }
        field(50155; "Sales Order No."; Text[100])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));


        }
        field(50156; "Job No."; Text[100])
        {
            Caption = 'Work Order No.';
            // HK::DCS 14102025 (Made the field editable on the requirement of GKB)
            editable = true;
            // TableRelation = Job."No.";
            // FieldClass = FlowField;
            // CalcFormula = lookup(job."No." where("Sales Order" = field("Blanket Sales Order No."), "No." = filter('<>''''')));
            FieldClass = FlowField;
            CalcFormula = lookup(Job."No." Where("Sales Order" = field("No.")));//DCS ::SP20250311

            // trigger OnLookup()
            // var
            //     JobRec: Record Job;
            //     JobListPage: Page "Job List";
            // begin
            //     JobRec.SetRange("Sales Order", Rec."No.");
            //     PAGE.RunModal(PAGE::"Job List", JobRec);
            // end;
        }
        field(50157; "Job Task No"; Code[30])
        {
            Caption = 'Project Task No';
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
        }
        field(50158; Description; Text[300])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        // Fields are created for the Blanket Sales Order To SALES INVOICE

        field(50159; "Percentage To Invoice"; Decimal)
        {
            Caption = '% To Invoice';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 4;
        }

        field(50160; "Invoiced Percentage"; Decimal)
        {
            Caption = 'Invoiced %';
            Editable = false;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 2;
        }

        field(50161; "Remaining Percentage"; Decimal)
        {
            Caption = 'Remaining %';
            Editable = false;
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 2;
            InitValue = 100;
        }

        field(50162; "Invoicing Amount"; Decimal)
        {
            Caption = 'Invoicing Amount';
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 0 : 2;
        }

        field(50163; "Amount Invoiced"; Decimal)
        {
            Caption = 'Amount Invoiced';
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 0 : 2;
        }

        field(50164; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
            MinValue = 0;
            DecimalPlaces = 0 : 2;
        }
        field(50165; "Customer PO Number"; Text[100])
        {
            Caption = 'Customer PO Number';
            DataClassification = ToBeClassified;
        }
        field(50166; "Billing Type"; enum "Charge Status")
        {
            Caption = 'Billing Type';
            // OptionMembers = " ","Charge Up","Quoted","Monthly Billing","Not Chargeable","N/A";
            DataClassification = ToBeClassified;
        }
        field(50167; "GST Prod Posting Group"; Code[20])
        {
            Caption = 'GST Prod Posting Group';
            Description = 'GST Product Posting Group at the header level';
            TableRelation = "VAT Product Posting Group";
            DataClassification = ToBeClassified;
        }
        field(50168; "Sales Name"; Text[100])
        {
            Caption = 'Name';
            // DataClassification = ToBeClassified;
        }
        field(50169; "D365 Sell-to Address 3"; Text[100])
        {
            Caption = 'Sell-to Address 3';
        }
        field(50170; "Delivery Docket No."; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50171; "Delivery Docket Date"; Date)
        {
            Caption = 'Delivery Docket Date';
            DataClassification = ToBeClassified;
        }
        field(50172; Percentage; Decimal)
        {
            Caption = 'Percentage to Update';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if (Percentage < 0) or (Percentage > 100) then
                    Error('Please enter a value between 0 and 100.');
            end;
        }
        field(50174; "CPI(Yes/No)"; Enum "CIP Enum")
        {
            DataClassification = ToBeClassified;
        }
        field(50175; "CIP Renewal Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        // DCS::HK 13102025 ++
        field(50176; "Invoice Date"; Date)
        // DCS::HK 13102025 --
        {
            DataClassification = ToBeClassified;
        }
        field(50177; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50178; "Last Invoice Created Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        // DCS:: aaj
        field(50179; "Blanket Sales Order No."; Code[20])
        {
            Caption = 'Work Order No.';// DCS :: HJ20251028
            NotBlank = true;
            // FieldClass = FlowField;
            // CalcFormula = lookup(Job."No." Where("Sales Order" = field("No.")));//DCS ::SP20250311
            //Editable = false;
        }
        field(50180; "Check Boolean"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        // DCS::HP 25092025 ++
        field(50181; "Agreement ID"; Integer)
        {
            Caption = 'Agreement ID';
            DataClassification = ToBeClassified;
        }
        field(50182; "Agreement % 1"; Decimal) //YK
        {
            Caption = 'Agreement % 1';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
            trigger OnValidate()
            begin
                ValidateAgreementPercentageTotal;
                if ("Agreement % 1" <> 0) and ("Obrien Business Unit Code 1" = '') then
                    Rec.TestField("Obrien Business Unit Code 1");
                // Error('Obrien Business Unit Code 1 must be filled if Agreement %% 1 is entered.');
                //     else
                //         if ("Agreement % 1" = 0) and ("Obrien Business Unit Code 1" <> '') then
                //             Error('Agreement %% 1 must be filled if Obrien Business Unit Code 1 is entered.');
            end;
        }
        field(50183; "Agreement % 2"; Decimal)
        {
            Caption = 'Agreement % 2';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
            trigger OnValidate()
            begin
                ValidateAgreementPercentageTotal;
                if ("Agreement % 2" <> 0) and ("Obrien Business Unit Code 2" = '') then
                    Rec.TestField("Obrien Business Unit Code 2");
                // Error('Obrien Business Unit Code 2 must be filled if Agreement %% 2 is entered.')
                // //     else

                // //         if ("Agreement % 2" = 0) and ("Obrien Business Unit Code 2" <> '') then
                // //             Error('Agreement %% 2 must be filled if Obrien Business Unit Code 2 is entered.');
            end;
        }
        field(50184; "Agreement % 3"; Decimal)
        {
            Caption = 'Agreement % 3';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 2;
            MinValue = 0;
            MaxValue = 100;
            trigger OnValidate()
            begin
                ValidateAgreementPercentageTotal;
                // end;
                // trigger OnValidate()
                // begin
                if ("Agreement % 3" <> 0) and ("Obrien Business Unit Code 3" = '') then
                    Rec.TestField("Obrien Business Unit Code 3");
                // Error('Obrien Business Unit Code 3 must be filled if Agreement %% 3 is entered.')
                // //     else

                // //         if ("Agreement % 3" = 0) and ("Obrien Business Unit Code 3" <> '') then
                // //             Error('Agreement %% 3 must be filled if Obrien Business Unit Code 3 is entered.');
            end;
        }
        field(50185; "Obrien Business Unit Code 1"; code[20]) //YK
        {
            Caption = 'Obrien Business Unit Code 1';
            DataClassification = ToBeClassified;
            trigger onvalidate()
            var
                myInt: Integer;
            begin
                // Rec.ValidateShortcutDimCode(1, "Obrien Business Unit Code 1");
                if ("Obrien Business Unit Code 1" <> '') and ("Agreement % 1" = 0) then
                    Message('Agreement % 1 must be filled if Obrien Business Unit Code 1 is entered.');
            end;
        }
        field(50186; "Obrien Business Unit Code 2"; code[20])
        {
            Caption = 'Obrien Business Unit Code 2';
            DataClassification = ToBeClassified;
            trigger onvalidate()
            var
                myInt: Integer;
            begin
                if ("Obrien Business Unit Code 2" <> '') and ("Agreement % 2" = 0) then
                    message('Agreement %% 2 must be filled if Obrien Business Unit Code 2 is entered.');
            end;
        }
        field(50187; "Obrien Business Unit Code 3"; code[20])
        {
            Caption = 'Obrien Business Unit Code 3';
            DataClassification = ToBeClassified;
            trigger onvalidate()
            var
                myInt: Integer;
            begin
                if ("Obrien Business Unit Code 3" <> '') and ("Agreement % 3" = 0) then
                    message('Agreement %% 3 must be filled if Obrien Business Unit Code 3 is entered.');
            end;
        }
        // DCS::HJ 09102025 ++
        field(50188; "Currency Code CRM"; Code[10])
        {
            Caption = 'Currency Code CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                currencyRec: Record Currency;
            begin
                if rec."Currency CRM ID" <> '' then begin// 13102025 PK ++
                    currencyRec.SetRange(currencyRec."CRM ID", rec."Currency CRM ID");
                    if currencyRec.FindFirst() then
                        rec."Currency Code" := currencyRec.Code;
                end;// 13102025 PK --
            end;
        }
        field(50189; "owningbusinessunit CRM"; Code[50])//Code[20]) //Pankaj_10Oct2025 Lenth increate form 20 to 50
        {
            Caption = 'owningbusinessunit CRM';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Dimensionval: Record "Dimension Value";
            begin
                // Dimensionval."owningbusinessunit CRM"
                Dimensionval.SetRange("Dimension Code", 'Obrien_Business Unit');
                Dimensionval.SetRange("CRM ID", Rec."Dimension CRM ID");
                if Dimensionval.FindFirst() then
                    rec."Shortcut Dimension 1 Code" := Dimensionval.Code;

            end;
        }
        // DCS::HJ 09102025 ++
        // DCS::HJ 24092025 --
        // DCS::HK 13102025 ++
        field(50190; "D01 Description"; BLOB)
        {
            caption = 'Description';
            // Subtype = Memo;
        }
        field(50191; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50193; "Invoice Frequency"; Option)
        {
            Caption = 'Invoice Frequency';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Weekly","Bi-weekly","Monthly","Quarterly","Semi-annually";
            OptionCaption = ' ,Weekly,Bi-weekly,Monthly,Quarterly,Semi-annually';
        }
        // DCS::HK 13102025 --

        //DCS::HK 28102025 ++
        field(50192; "Full Topic"; Text[300])
        {
            DataClassification = ToBeClassified;

        }
        //DCS::HK 28102025 --


    }

    trigger OnModify()
    var
        TotalAmount: Decimal;
        SalesLine: Record "Sales Line";

    begin

        if Rec."Document Type" = Rec."Document Type"::"Blanket Order" then begin

            // Validate percentage limits
            if Rec."Invoiced Percentage" > 100 then
                Error('Invoiced Percentage cannot be greater than 100.');

            if (Rec."Percentage To Invoice" + Rec."Invoiced Percentage") > 100 then
                Error('Total of Invoiced Percentage and Percentage To Invoice cannot exceed 100.');
            TotalAmount := 0;
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange("Document No.", Rec."No.");
            if SalesLine.FindSet() then begin
                repeat
                    // HP changes amount value
                    TotalAmount += SalesLine."Amount Including VAT";
                until SalesLine.Next() = 0;
            end;

            Rec."Invoicing Amount" := Round((Rec."Percentage To Invoice" / 100) * TotalAmount, 0.01);
            //HK

        end;
    end;

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
        if (Rec."Customer CRMID" <> '') and (xRec."Customer CRMID" <> Rec."Customer CRMID") then begin
            customerRec.SetFilter("CRM ID", Rec."Customer CRMID");
            if customerRec.FindFirst() then begin
                Rec."Bill-to Customer No." := customerRec."No.";
                modified := modified + 1;
            end;
        end;

        if (Rec."Dimension CRM ID" <> '') and (xRec."Dimension CRM ID" <> Rec."Dimension CRM ID") then begin
            dimRec.SetFilter("CRM ID", Rec."Dimension CRM ID");
            if dimRec.FindFirst() then begin
                Rec.Dimension := dimRec.Code;
                modified := modified + 1;
            end;
        end;

        if (Rec."Currency CRM ID" <> '') and (xRec."Currency CRM ID" <> Rec."Currency CRM ID") then begin
            if rec."Currency CRM ID" <> '' then begin// 13OCT2025 Pankaj --
                currencyRec.SetFilter("CRM ID", Rec."Currency CRM ID");
                if currencyRec.FindFirst() then begin
                    Rec."Currency Code" := currencyRec.Code;
                    modified := modified + 1;
                end;
            end;
        end;

        if modified > 0 then begin
            Rec.Modify(false);
        end;
    end;

    trigger OnAfterInsert()  // DCS :: HJ20251028 ++
    begin
        if rec."Document Type" = rec."Document Type"::"Blanket Order" then begin
            Rec.CalcFields("Job No.");
            // if Rec."Blanket Sales Order No." = '' then begin
            Rec."Blanket Sales Order No." := Rec."Job No.";
            // rec.Modify();
            // end;
        end;
    end;  // DCS :: HJ20251028 --

    var
        Readdataskippedmsg: Label 'Loading Field %1 Will be skipped because there was an error when reading tha date.';

    procedure SetRichText(RichText1: Text)
    var
        OutStream: OutStream;
    begin
        Clear(RichText);
        RichText.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(RichText1);
        Modify();
    end;

    procedure GetRichText() TermConditions: Text
    var
        InStream: Instream;
        typehelper: Codeunit "Type Helper";
    begin
        CalcFields(RichText);
        RichText.CreateInStream(InStream, TextEncoding::UTF8);
        if not typehelper.TryReadAsTextWithSeparator(InStream, typehelper.LFSeparator(), TermConditions) then
            Message(Readdataskippedmsg, FieldCaption(RichText));
    end;

    procedure ValidateAgreementPercentageTotal()
    var
        Total: Decimal;
    begin
        Total := "Agreement % 1" + "Agreement % 2" + "Agreement % 3";
        if Total > 100 then
            Error('Total of Agreement % fields cannot exceed 100. Current total: %1', Total);
    end;
    // DCS::HK 13102025 ++
    procedure GetWorkDescription1() WorkDescription1: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("D01 Description");
        "D01 Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("D01 Description")));
    end;

    procedure SetWorkDescription1(NewWorkDescription1: Text)
    var
        OutStream: OutStream;
    begin
        OnBeforeSetWorkDescription1(Rec, NewWorkDescription1);
        Clear("D01 Description");
        "D01 Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription1);
        Modify();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetWorkDescription1(var SalesHeader: Record "Sales Header"; var NewWorkDescription1: Text)
    begin
    end;


    // DCS::HK 13102025 --
}