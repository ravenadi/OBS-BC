page 50117 "API Sales Price List"
{

    PageType = API;
    APIGroup = 'api';
    APIPublisher = 'integration';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'Salepricelist';
    EntitySetName = 'Salepricelists';
    DelayedInsert = true;
    SourceTable = "Price List Header";

    // Define the fields to be exposed in the API
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("CrmId"; Rec."Crm Id")
                {
                    Caption = 'Crm ID';
                }
                field(Code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(SourceType; Rec."Source Type")
                {
                    Caption = 'Source Type';
                }
                field(AssignToParentNo; Rec."Assign-to Parent No.")
                {
                    Caption = 'Assign-to Parent No.';
                }
                field(SourceNo; Rec."Source No.")
                {
                    Caption = 'Source No.';
                }
                field(AssignToNo; Rec."Assign-to No.")
                {
                    Caption = 'Assign-to No.';
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    Caption = 'VAT Business Posting Group (Price)';
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    Caption = 'Price Includes VAT';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(StartingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(EndingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }
                field(AllowUpdatingDefaults; Rec."Allow Updating Defaults")
                {
                    Caption = 'Allow Updating Defaults';
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    Caption = 'Allow Invoice Discount';
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    Caption = 'Allow Line Discount';
                }
            }
        }
    }
}
