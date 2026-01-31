tableextension 50121 "Purch. Rcpt. Line Ext" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50110; "Ordered By"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ordered By';
            //DCS ::HJ20250311 ++
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
         field(50211; "Name Ordered By"; Text[100])
        {
            DataClassification = ToBeClassified;
           TableRelation = Employee."First Name";
        }
        //DCS ::HJ20250311 --
        // DCS::HP 18092025 ++
        field(50210; "Car Registration No."; Code[50])
        {
            Caption = 'Car Registration No.';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 18092025 --
    }
}