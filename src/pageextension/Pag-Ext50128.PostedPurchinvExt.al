pageextension 50128 "Posted Purch Inv. Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        modify("Order No.")
        {
            trigger OnDrillDown()
            var
                PurchHeadArchive: Record "Purchase Header Archive";
            begin
                PurchHeadArchive.Reset();
                PurchHeadArchive.SetRange("Document Type", PurchHeadArchive."Document Type"::Order);
                PurchHeadArchive.SetRange("No.", Rec."Order No.");

                if PurchHeadArchive.FindLast() then begin
                    Page.Run(Page::"Purchase Order Archive", PurchHeadArchive);
                end
            end;
        }
        addafter(Corrective)
        {
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
            field("Work Order No"; Rec."Work Order No")
            {
                ApplicationArea = all;
            }
            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = all;
                Caption = 'Delivery Docket No.';
            }
            field("Remaining Amount"; Rec."Remaining Amount")
            {
                ApplicationArea = All;
                Caption = 'Remaining Amount';
                ToolTip = 'Specifies the remaining amount outstanding on the posted purchase invoice.';
            }
        }
    }
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