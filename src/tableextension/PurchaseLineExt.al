tableextension 50192 PurchaseLineExt extends "Purchase Line"
{
    fields
    {
        field(50192; "Total Direct Unit Cost"; Decimal)
        {
            Caption = 'Total Direct Unit Cost';
            FieldClass = FlowField;
            CalcFormula =
                Sum("Purchase Line"."Direct Unit Cost"
                    where(
                        "Document Type" = field("Document Type"),
                        "Document No."   = field("Document No."),
                        "Job No."        = filter(<> '')
                    ));
        }
    }
}