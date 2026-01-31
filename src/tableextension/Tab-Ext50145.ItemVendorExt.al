tableextension 50145 "Item Vendor Ext" extends "Item Vendor"
{
    fields
    {
        field(50100; "Current Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = CustomerContent;
            Description = 'Stores the Direct Unit Cost of Alternate Vendors from price list line';
            AutoFormatType = 1;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50101; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor".Name WHERE("No." = FIELD("Vendor No.")));
        }
    }
    fieldgroups
    {
        addlast(DropDown; "Vendor Name", "Current Cost")
        {
        }
    }
}
