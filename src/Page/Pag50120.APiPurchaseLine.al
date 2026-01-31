

page 50120 "APi Purchase Line"
{
    PageType = API;
    SourceTable = "Purchase Line";
    APIVersion = 'v2.0', 'v1.0';
    APIPublisher = 'integration';
    APIGroup = 'api';
    EntityName = 'PurchaseLine';
    EntitySetName = 'PurchaseLines';
    DelayedInsert = true;

    // Define the fields to be exposed in the API with only Caption property
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("DocumentType"; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field("CRMID"; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field("BuyfromVendorNo"; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Buy-from Vendor No.';
                }
                field("DocumentNo"; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field("LineNo"; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("Type"; Rec.Type)
                {
                    Caption = 'Type';
                }
                field("No"; Rec."No.")
                {
                    Caption = 'No.';
                }
                field("LocationCode"; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field("ExpectedReceiptDate"; Rec."Expected Receipt Date")
                {
                    Caption = 'Expected Receipt Date';
                }
                field("Description"; Rec.Description)
                {
                    Caption = 'Description';
                }
                field("Description2"; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field("UnitOfMeasure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field("Quantity"; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field("OutstandingQuantity"; Rec."Outstanding Quantity")
                {
                    Caption = 'Outstanding Quantity';
                }
                field("QtyToInvoice"; Rec."Qty. to Invoice")
                {
                    Caption = 'Qty. to Invoice';
                }
                field("QtyToReceive"; Rec."Qty. to Receive")
                {
                    Caption = 'Qty. to Receive';
                }
                field("DirectUnitCost"; Rec."Direct Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field("LineDiscountPct"; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
                }
                field("LineDiscountAmount"; Rec."Line Discount Amount")
                {
                    Caption = 'Line Discount Amount';
                }
                field("Amount"; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field("AmountIncludingVAT"; Rec."Amount Including VAT")
                {
                    Caption = 'Amount Including VAT';
                }
                field("VATBaseAmount"; Rec."VAT Base Amount")
                {
                    Caption = 'VAT Base Amount';
                }

                field("LineAmount"; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field("UnitCostLCY"; Rec."Unit Cost (LCY)")
                {
                    Caption = 'Unit Cost (LCY)';
                }
                field("SystemCreatedEntry"; Rec."System-Created Entry")
                {
                    Caption = 'System-Created Entry';
                }
                field("FAPostingType"; Rec."FA Posting Type")
                {
                    Caption = 'FA Posting Type';
                }
                field("FAPostingDate"; Rec."FA Posting Date")
                {
                    Caption = 'FA Posting Date';
                }

                field("JobNo"; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field("JobTaskNo"; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                field("JobPlanningLineNo"; Rec."Job Planning Line No.")
                {
                    Caption = 'Job Planning Line No.';
                }
                field("JobLineType"; Rec."Job Line Type")
                {
                    Caption = 'Job Line Type';
                }
                field("JobUnitPrice"; Rec."Job Unit Price")
                {
                    Caption = 'Job Unit Price';
                }
            }
        }
    }
}