tableextension 50136 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50100; "Allow Edit Mode"; Boolean)
        {
            Caption = 'Allow Vendor Edit Mode';
            DataClassification = CustomerContent;
        }
        field(50101; "Allow Edit Vandor Bank"; Boolean)
        {
            Caption = 'Allow Vendor Bank Edit';
            DataClassification = CustomerContent;
        }
        field(50102; "Customer Card"; Boolean)
        {
            Caption = 'Customer Card Edit';
            DataClassification = ToBeClassified;
        }
        field(50103; "G\L Account"; Boolean)
        {
            Caption = 'G\L Account Edit';
            DataClassification = ToBeClassified;
        }
        field(50104; Location; Boolean)
        {
            Caption = 'Location Edit';
            DataClassification = ToBeClassified;
        }
        field(50105; "Sales Quote"; Boolean)
        {
            Caption = 'Sales Quote';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 24082025 ++
        field(50106; "CRM ID"; text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        field(50107; "User Employee No."; Code[20]) /////Pankaj_10Oct2025 NEw Field Added
        {
            Caption = 'Owner';
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        //DCS::HK 14112025 ++
        field(50108; "Req. Worksheet Status Allowed"; Boolean)
        {
            Caption = 'Req. Worksheet Status Allowed';
            DataClassification = ToBeClassified;
        }
        //DCS::HK 14112025 --
    }
}