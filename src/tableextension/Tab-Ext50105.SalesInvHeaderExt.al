tableextension 50105 "Sales Inv. Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50156; "Job No."; Text[100])
        {
            Caption = 'Work Order No.';
            FieldClass = FlowField;
            CalcFormula = lookup(job."No." where("Sales Order" = field("Blanket Sales Order No."), "No." = filter('<>''''')));
        }
        field(50165; "Customer PO Number"; Text[100])
        {
            Caption = 'Customer PO Number';
            DataClassification = ToBeClassified;
        }
        field(50170; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }
        field(50173; "Address 3"; Text[100])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
        }
        // Dcs:: aaj
        field(50179; "Blanket Sales Order No."; Code[20])
        {
            Caption = 'Work Order No.';  // DCS :: HJ20251028
            DataClassification = CustomerContent;
            
        }

        // DCS::HK 13102025 ++
        field(50190; "D01 Description"; BLOB)
        {
            caption = 'Description';
            // Subtype = Memo;
        }
        // DCS::HK 13102025 --
        field(50109; Owner; Text[100])
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
            Editable = false;
        }
        field(50192; "Full Topic"; Text[300])
        {
            DataClassification = ToBeClassified;

        }
    }

    // DCS::HK 13102025 ++
    procedure GetWorkDescription1(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        Desc: Text;
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.get(Rec."No.");
        OnBeforeGetWorkDescription1(Rec);
        SalesInvHeader.CalcFields("D01 Description");
        clear(TempBlob);
        TempBlob.FromRecord(SalesInvHeader, FieldNo("D01 Description"));
        TempBlob.CreateInStream(InStream, TEXTENCODING::UTF8);
        if InStream.Length() = 0 then
            exit('');
        // InStream.ReadText(Desc, InStream.Length());
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), FieldName("D01 Description")));
    end;

    procedure SetWorkDescription1(NewWorkDescription1: Text)
    var
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
        Desc: Text;
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Reset();
        SalesInvHeader.Get(Rec."No.");
        OnBeforeGetWorkDescription1(Rec);
        Clear(SalesInvHeader."D01 Description");
        SalesInvHeader."D01 Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription1);
        SalesInvHeader.Modify();

    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetWorkDescription1(var SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
    end;
    // DCS::HK 13102025 --
}

