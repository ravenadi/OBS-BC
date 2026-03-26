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

        modify("Order No.")
        {
            trigger OnDrillDown()
            var
                PurchHeaderArchive: Record "Purchase Header Archive";
                PurchOrderArchivesPage: Page "Purchase Order Archives";
            begin
                if Rec."Order No." = '' then
                    exit;
                PurchHeaderArchive.SetRange("Document Type", PurchHeaderArchive."Document Type"::Order);
                PurchHeaderArchive.SetRange("No.", Rec."Order No.");
                PurchHeaderArchive.SetRange("Vendor Invoice No.", Rec."Vendor Invoice No.");
                PurchOrderArchivesPage.SetTableView(PurchHeaderArchive);
                PurchOrderArchivesPage.Run();
            end;
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