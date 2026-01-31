page 50112 "API Sales Invoice"
{
    PageType = API;
    APIGroup = 'api';
    APIPublisher = 'integration';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'SalesInvoice';
    EntitySetName = 'SalesInvoices';
    SourceTable = "Sales Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("CRMID"; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field("No"; Rec."No.")
                {
                    Caption = 'InvoiceNumber';
                }
                field("SellToCustomerNo"; Rec."Sell-to Customer No.")
                {
                    Caption = 'CustomerNumber';
                }
                field("SellToCustomerName"; Rec."Sell-to Customer Name")
                {
                    Caption = 'CustomerName';
                }
                field("DocumentDate"; Rec."Document Date")
                {
                    Caption = 'DocumentDate';
                }
                field("PostingDate"; Rec."Posting Date")
                {
                    Caption = 'PostingDate';
                }
                field("DueDate"; Rec."Due Date")
                {
                    Caption = 'DueDate';
                }
                field("CurrencyCode"; Rec."Currency Code")
                {
                    Caption = 'CurrencyCode';
                }
                field("AmountIncludingVAT"; Rec."Amount Including VAT")
                {
                    Caption = 'TotalAmount';
                }
                field("Status"; Rec.Status)
                {
                    Caption = 'Status';
                }
                field("SellToAddress"; Rec."Sell-to Address")
                {
                    Caption = 'SellToAddress';
                }
                field("SellToCity"; Rec."Sell-to City")
                {
                    Caption = 'SellToCity';
                }
                field("SellToCounty"; Rec."Sell-to County")
                {
                    Caption = 'SellToCounty';
                }
                field("SellToPostCode"; Rec."Sell-to Post Code")
                {
                    Caption = 'SellToPostCode';
                }
                field("SellToCountryRegionCode"; Rec."Sell-to Country/Region Code")
                {
                    Caption = 'CountryRegionCode';
                }
                field("ExternalDocumentNo"; Rec."External Document No.")
                {
                    Caption = 'ExternalDocumentNo';
                }
                field("YourReference"; Rec."Your Reference")
                {
                    Caption = 'YourReference';
                }
                field("PaymentTermsCode"; Rec."Payment Terms Code")
                {
                    Caption = 'PaymentTermsCode';
                }
                field("PaymentMethodCode"; Rec."Payment Method Code")
                {
                    Caption = 'PaymentMethodCode';
                }
                field("SalespersonCode"; Rec."Salesperson Code")
                {
                    Caption = 'SalespersonCode';
                }
                field("CampaignNo"; Rec."Campaign No.")
                {
                    Caption = 'CampaignNo';
                }
                field("ResponsibilityCenter"; Rec."Responsibility Center")
                {
                    Caption = 'ResponsibilityCenter';
                }
                field("AssignedUserID"; Rec."Assigned User ID")
                {
                    Caption = 'AssignedUser ID';
                }
                field("VATRegistrationNo"; Rec."VAT Registration No.")
                {
                    Caption = 'VATRegistrationNo';
                }
                field("RegistrationNumber"; Rec."Registration Number")
                {
                    Caption = 'RegistrationNumber';
                }
                field("IncomingDocumentEntryNo"; Rec."Incoming Document Entry No.")
                {
                    Caption = 'IncomingDocumentEntryNo';
                }
            }
        }
    }
}
