namespace GKBCustomization.GKBCustomization;

using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Purchases.Document;

/// <summary>
/// Page Requisition Line Archive (ID 50160).
/// Lists all archived requisition lines that have been converted to Purchase Orders.
/// </summary>


//Gkblabs_Tv_03/12/25
page 50160 "Requisition Line Archive"
{
    ApplicationArea = All;
    Caption = 'Requisition Line Archive';
    PageType = List;
    SourceTable = "Requisition Line Archive";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the unique entry number.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line number.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the type of requisition line (Item/G/L Account).';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the item or G/L account.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the description of the item or service.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity required.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ToolTip = 'Specifies the unit of measure.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the vendor number.';
                }
                field("VendorName"; Rec."VendorName")
                {
                    ToolTip = 'Specifies the vendor name.';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    ToolTip = 'Specifies the direct unit cost.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code.';
                    Visible = false;
                }
                field("StatusReq"; Rec."StatusReq")
                {
                    ToolTip = 'Specifies the status of the requisition line.';
                }
                field("projectNo"; Rec."projectNo")
                {
                    ToolTip = 'Specifies the project number.';
                }
                field("Project Task No"; Rec."Project Task No")
                {
                    ToolTip = 'Specifies the project task number.';
                    Visible = false;
                }
                field("Requested By Name2"; Rec."Requested By Name2")
                {
                    ToolTip = 'Specifies the full name of who requested the item.';
                }
                field("Owner"; Rec."Owner")
                {
                    ToolTip = 'Specifies the owner of the requisition.';
                }
                field("Work Order No"; Rec."Work Order No")
                {
                    ToolTip = 'Specifies the work order number.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the location code.';
                }
                field("Ship To"; Rec."Ship To")
                {
                    ToolTip = 'Specifies the shipping location.';
                    Visible = false;
                }
                field("PO Number"; Rec."PO Number")
                {
                    ToolTip = 'Specifies the purchase order number created from this requisition.';
                    StyleExpr = 'Strong';
                }
                field("PO Line Number"; Rec."PO Line Number")
                {
                    ToolTip = 'Specifies the line number in the purchase order.';
                }
                field("Archived Date"; Rec."Archived Date")
                {
                    ToolTip = 'Specifies when this record was archived.';
                }
                field("Archived By"; Rec."Archived By")
                {
                    ToolTip = 'Specifies which user archived this record.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ViewPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'View Purchase Order';
                Image = Document;
                ToolTip = 'Open the purchase order created from this requisition.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    if Rec."PO Number" = '' then begin
                        Message('No purchase order linked to this archived requisition.');
                        exit;
                    end;

                    PurchaseHeader.Reset();
                    PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.SetRange("No.", Rec."PO Number");
                    if PurchaseHeader.FindFirst() then
                        Page.Run(Page::"Purchase Order", PurchaseHeader)
                    else
                        Message('Purchase Order %1 not found. It may have been posted or deleted.', Rec."PO Number");
                end;
            }
        }
    }
}
