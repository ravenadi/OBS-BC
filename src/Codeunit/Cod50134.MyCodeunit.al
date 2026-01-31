codeunit 50134 MyCodeunit
{
    Permissions = TableData "Sales Invoice Header" = rimd;
    procedure SetWorkDescription1(Rec: Record "Sales Invoice Header" temporary; NewWorkDescription1: Text)
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
        Clear(SalesInvHeader."D01 Description");
        SalesInvHeader."D01 Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription1);
        SalesInvHeader.Modify();
    end;
    //DCS::HK 28102025++
    procedure SetCustPONum(SalesInvNo: Code[20]; NewCustPONum: Text)
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.get(SalesInvNo);
        SalesInvHeader."Customer PO Number" := NewCustPONum;
        SalesInvHeader.Modify();
    end;
    //DCS::HK 28102025++
}