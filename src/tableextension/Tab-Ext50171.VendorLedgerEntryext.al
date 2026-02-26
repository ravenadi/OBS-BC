//DCS::HK 13112025 ++
tableextension 50171 "Vendor Ledger Entry ext" extends "Vendor Ledger Entry"
{
    fields
    {
        field(50100; Name; Text[100])
        {
            Caption = 'Name';
            FieldClass = flowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
        }

        field(50101; "Vendor E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            FieldClass = flowField;
            CalcFormula = Lookup(Vendor."E-Mail" WHERE("No." = FIELD("Vendor No.")));
        }
    }
}
//DCS::HK 13112025 --