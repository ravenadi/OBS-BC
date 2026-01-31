page 50119 "API Purchase Order"
{
    PageType = API;
    SourceTable = "Purchase Header";
    APIVersion = 'v2.0';
    APIGroup = 'api';
    APIPublisher = 'integration'; // Replace with actual publisher name
    EntityName = 'PurchaseOrder';
    EntitySetName = 'PurchaseOrders';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(No; Rec."No.")
                {
                    Caption = 'Order Number';
                }
                field("CRMID"; Rec."CRM ID")
                {
                    Caption = 'Crm Id';
                }
                field(BuyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor Number';
                }
                field(BuyFromVendorName; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    Caption = 'Document Date';
                }
                field(InvoiceReceivedDate; Rec."Invoice Received Date")
                {
                    Caption = 'Invoice Received Date';
                }
                field(DueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(VendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                    Caption = 'Vendor Invoice Number';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(YourReference; Rec."Your Reference")
                {
                    Caption = 'Your Reference';
                }
                field(OrderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(QuoteNo; Rec."Quote No.")
                {
                    Caption = 'Quote Number';
                }
                field(VendorOrderNo; Rec."Vendor Order No.")
                {
                    Caption = 'Vendor Order Number';
                }
                field(VendorShipmentNo; Rec."Vendor Shipment No.")
                {
                    Caption = 'Vendor Shipment Number';
                }
                field(BuyFromAddress; Rec."Buy-from Address")
                {
                    Caption = 'Vendor Address';
                }
                field(BuyFromCity; Rec."Buy-from City")
                {
                    Caption = 'Vendor City';
                }
                field(BuyFromCounty; Rec."Buy-from County")
                {
                    Caption = 'Vendor County';
                }
                field(BuyFromPostCode; Rec."Buy-from Post Code")
                {
                    Caption = 'Vendor Post Code';
                }
                field(BuyFromCountryRegionCode; Rec."Buy-from Country/Region Code")
                {
                    Caption = 'Vendor Country/Region';
                }
                field(BuyFromContactNo; Rec."Buy-from Contact No.")
                {
                    Caption = 'Vendor Contact Number';
                }
                field(BuyFromContact; Rec."Buy-from Contact")
                {
                    Caption = 'Vendor Contact';
                }
                field(PaymentTermsCode; Rec."Payment Terms Code")
                {
                    Caption = 'Payment Terms Code';
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    Caption = 'Posting Description';
                }
                field(VATReportingDate; Rec."VAT Reporting Date")
                {
                    Caption = 'VAT Reporting Date';
                }
                field(TaxAreaCode; Rec."Tax Area Code")
                {
                    Caption = 'Tax Area Code';
                }
                field(PaymentDiscountPct; Rec."Payment Discount %")
                {
                    Caption = 'Payment Discount Percentage';
                }
                field(PaymentDiscountDate; Rec."Pmt. Discount Date")
                {
                    Caption = 'Payment Discount Date';
                }
                field(JobQueueStatus; Rec."Job Queue Status")
                {
                    Caption = 'Job Queue Status';
                }
                field(LanguageCode; Rec."Language Code")
                {
                    Caption = 'Language Code';
                }
                field(FormatRegion; Rec."Format Region")
                {
                    Caption = 'Format Region';
                }
                field(VendorExchangeRateACY; Rec."Vendor Exchange Rate (ACY)")
                {
                    Caption = 'Vendor Exchange Rate (ACY)';
                }
                field(OnHold; Rec."On Hold")
                {
                    Caption = 'On Hold';
                }
                field(InboundWarehouseHandlingTime; Rec."Inbound Whse. Handling Time")
                {
                    Caption = 'Inbound Warehouse Handling Time';
                }
                field(LeadTimeCalculation; Rec."Lead Time Calculation")
                {
                    Caption = 'Lead Time Calculation';
                }
                field(RequestedReceiptDate; Rec."Requested Receipt Date")
                {
                    Caption = 'Requested Receipt Date';
                }
                field(PromisedReceiptDate; Rec."Promised Receipt Date")
                {
                    Caption = 'Promised Receipt Date';
                }
            }
        }
    }
}
