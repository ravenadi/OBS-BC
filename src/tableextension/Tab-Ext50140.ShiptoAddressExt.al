tableextension 50140 "Ship-to Address Ext" extends "Ship-to Address"
{
    fields
    {
        field(50100; "Owning Business Unit"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
        }
        field(50101; "Postal Code"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Postal Code';
        }
        field(50102; "Address 3"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "D365 State"; Text[100])
        {
            Caption = 'State';
            DataClassification = ToBeClassified;
        }
        field(50104; "D365 Country"; Text[100])
        {
            Caption = 'Country';
            DataClassification = ToBeClassified;
        }
        field(50105; "D365 City"; Text[100])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
        }
        field(50106; "Crm Id"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Customer CRM"; Text[204])
        {
            Caption = 'Customer CRM';
            FieldClass = FlowField;
            CalcFormula = Lookup("Customer"."CRM ID" WHERE("No." = FIELD("Customer No.")));
        }
        field(50108; "JSON Request"; Text[2048])
        {
            Caption = 'JSON Request';
            DataClassification = ToBeClassified;
        }
    // DCS::HP 22082025 ++
        field(50109; "D365 Account ID"; Text[200])
        {
            Caption = 'D365 Account ID';
            DataClassification = ToBeClassified;
        }
    }
    // trigger OnInsert()
    // var
    //     CustomerRec: record customer;
    // begin
    //     CustomerRec.Reset();
    //     CustomerRec.SetRange("D365 Account ID", rec."D365 Account ID");
    //     if CustomerRec.FindFirst() then
    //         "Customer No." := CustomerRec."No.";
    // end;
    // DCS::HP 22082025 --
}