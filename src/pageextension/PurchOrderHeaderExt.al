pageextension 50244 PurchOrderExt extends "Purchase Order"
{
    layout
    {
        // The built-in footer/totals section on the Purchase Order page isn't
        // exposed as a named control in all environments. Depending on the
        // "Check Doc. Total Amounts" feature the standard "Amount Including
        // VAT" control may be present or not (and the internal name varies).
        // As a result we cannot reliably anchor into the totals area; attempting
        // to do so leads to AL0270 errors.  The field is therefore added at the
        // end of the General group instead, which is always available.
        addlast(General)
        {
            field("Total Direct Unit Cost"; Rec."Total Direct Unit Cost")
            {
                ApplicationArea = All;
                Caption = 'Total Direct Unit Cost';
                Editable = false;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // ensure the flowfield is recalculated for every header record
        Rec.CalcFields("Total Direct Unit Cost");
    end;
}
