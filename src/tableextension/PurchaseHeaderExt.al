tableextension 50179 PurchaseHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50200; "Total Direct Unit Cost"; Decimal)
        {
            Caption = 'Total Direct Unit Cost';
            FieldClass = FlowField;
            CalcFormula = 
                Sum("Purchase Line"."Direct Unit Cost"
                    where(
                        "Document Type" = field("Document Type"),
                        "Document No."   = field("No."),
                        "Job No."        = filter(<> '')
                    ));
        }
    }
}