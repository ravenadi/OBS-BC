tableextension 50116 "Purch. Rcpt. Header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "Ordered By"; Text[100])
        {
            Caption = 'Ordered By';
            DataClassification = ToBeClassified;
            TableRelation =Employee."No.";
            ValidateTableRelation =true;

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
         field(50106; "Name Ordered By"; Text[100])
        {
            Caption = 'Name Ordered By';
            DataClassification = ToBeClassified;
            TableRelation = Employee."First Name";
        }
        field(50102; "Created By"; Text[100])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
        }
        field(50103; "Work Order No"; Text[100])
        {
            Caption = 'Work Order No';
            DataClassification = ToBeClassified;
        }
        field(50104; "Delivery Docket No."; Code[50])
        {
            Caption = 'Delivery Docket No.';
            DataClassification = ToBeClassified;
        }
        field(50105; "Delivery Document No"; Code[50])
        {
            Caption = 'Delivery Document No';
            DataClassification = ToBeClassified;
        }
    }
}