tableextension 50109 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; Comments2; Text[200])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50102; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DataClassification = ToBeClassified;
        }
        field(50103; "QuantityShippedtillnow"; Decimal)
        {
            Caption = 'Quantity Shipped till now';
            DataClassification = ToBeClassified;

        }
        field(50104; "SalesOrderCreated"; Boolean)
        {
            Caption = 'Sales Order Created';
            DataClassification = ToBeClassified;
        }
        // Fields For API Table
        field(50105; "Product"; Code[200])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }

        field(50106; Topic; Text[200])
        {
            Caption = 'Topic';
            DataClassification = ToBeClassified;
        }
        field(50107; "Invoice Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice Created';
        }
        field(50108; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'G/L Account No.';
        }
    }
}


