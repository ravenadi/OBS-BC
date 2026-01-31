tableextension 50131 "Transfer Line Ext" extends "Transfer Line"
{
    fields
    {

        field(50100; "Item Availability By Location"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry"."Remaining Quantity"
                              WHERE("Item No." = FIELD("Item No."),
                                    "Location Code" = FIELD("Transfer-from Code")));
            Editable = false;
        }
        field(50101; "Transfer Note"; Text[200])
        {
            Caption = 'Transfer Note';
            DataClassification = ToBeClassified;
        }
    }
}
