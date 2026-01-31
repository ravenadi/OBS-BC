tableextension 50114 "Purchase Header Ext" extends "Purchase Header"
{

    fields
    {
        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            var
                PurchHeader: Record "Purchase Header";
            begin
                if Rec."Vendor Invoice No." = '' then
                    exit;
                case Rec."Document Type" of
                    Rec."Document Type"::Order:
                        begin
                            PurchHeader.Reset();
                            PurchHeader.SetRange("Vendor Invoice No.", "Vendor Invoice No.");
                            PurchHeader.SetRange("Document Type", "Document Type"::Order);
                            PurchHeader.SetFilter("No.", '<>%1', "No."); // exclude current PO
                            if PurchHeader.FindFirst() then
                                Error('Vendor Invoice No. %1 already exists on Purchase Order %2',
                                    "Vendor Invoice No.", PurchHeader."No.");
                        end;

                    Rec."Document Type"::Invoice:
                        begin
                            PurchHeader.Reset();
                            PurchHeader.SetRange("Vendor Invoice No.", "Vendor Invoice No.");
                            PurchHeader.SetRange("Document Type", "Document Type"::Invoice);
                            PurchHeader.SetFilter("No.", '<>%1', "No."); // exclude current PO
                            if PurchHeader.FindFirst() then
                                error('Vendor Invoice No. %1 already exists on Purchase Invoice %2',
                                    "Vendor Invoice No.", PurchHeader."No.");
                        end;
                end;
            end;
        }
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "Ordered By"; Code[20])
        {
            Caption = 'Ordered By';
            TableRelation = Employee."No.";
            ValidateTableRelation = true;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Rec."Ordered By" <> '' then begin
                    if Employee.Get(Rec."Ordered By") then
                        Rec."Name Ordered By" := Employee."First Name" + ' ' + Employee."Last Name"
                    else
                        Rec."Name Ordered By" := '';
                end else
                    Rec."Name Ordered By" := '';
            end;
        }
        field(50107; "Name Ordered By"; text[100])
        {
            TableRelation = Employee."First Name";
        }
        field(50102; "Created By"; Code[20])
        {
            Caption = 'Created By';
        }
        field(50103; "Job No"; Code[50])
        {
            Caption = 'Work Order No.';
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(50104; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }
        field(50105; "Address 3"; Text[100])
        {
            Caption = 'Address 3';
        }
        field(50106; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        // DCS::HP11112025 ++
        field(50208; "Special Instruction"; Text[100])
        {
            Caption = 'Special Instruction';
            DataClassification = ToBeClassified;
        }
        // DCS::HP11112025 --



    }
    trigger OnInsert()
    var
        user: Record "User Setup";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        IF User.GET(USERID) THEN
            Rec."Created By" := User."User ID";

        // DCS::HP 14082025 ++
        if Rec."Delivery Docket No." = '' then
            Rec."Delivery Docket No." := NoSeriesMgt.GetNextNo('DLVDOC', Today(), true);
        // DCS::HP 14082025 --
    end;


}