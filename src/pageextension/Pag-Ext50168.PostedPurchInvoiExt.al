pageextension 50168 "Posted Purch Invoi. Ext" extends "Posted Purchase Invoices"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = false;
        }

        // GkbLabs_Tv_15/12/25
        addafter("Vendor Invoice No.")
        {
            field("Work Order No"; Rec."Work Order No")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Work Order Number for the purchase invoice.';
            }
        }
    }
    // GkbLabs_Tv_15/12/25
    // DCS::HP08122025 ++
    actions
    {
        modify(CorrectInvoice)
        {
            Visible = false;
        }
    }
    // DCS::HP08122025 --

}