pageextension 50162 "Posted Warehouse Shipment" extends "Posted Whse. Shipment"
{
    layout
    {
        addlast(General)
        {
            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {

        addafter("&Print")
        {
            action("Print QR Codes")
            {
                ApplicationArea = All;
                Caption = 'Print QR Codes';
                Image = Print;
                ToolTip = 'Print QR Codes for the items in this receipt.';
                trigger OnAction()
                var
                    PostedwarehouseReceiptHeader: Record "Posted Whse. Shipment Header";
                begin
                    PostedwarehouseReceiptHeader.Reset();
                    PostedwarehouseReceiptHeader.SetRange("No.", Rec."No.");
                    if PostedwarehouseReceiptHeader.FindFirst() then
                        Report.RunModal(Report::"Warehouse Ship Item QRCodes", true, false, PostedwarehouseReceiptHeader);
                end;
            }
        }

    }


    var
        myInt: Integer;
}