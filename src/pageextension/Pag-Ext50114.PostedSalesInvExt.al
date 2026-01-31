
pageextension 50114 "Posted Sales Inv. Ext" extends "Posted Sales Invoices"
{
    //YK
    layout
    {
        addafter(Amount)
        {
            field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
            }
            // GkbLabs_Tv_15/12/25
            field("Job No."; Rec."Job No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Number for the sales invoice.';
            }
        }
    }
    // GkbLabs_Tv_22/12/25
    actions
    {
        modify(CorrectInvoice)
        {
            Visible = false;
        }
    }
    //GkbLabs_Tv_22/12/25
    // DCS::HP08122025 --
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}
