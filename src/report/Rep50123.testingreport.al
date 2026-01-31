namespace GKBCustomization.GKBCustomization;
using Microsoft.Sales.Document;
using Microsoft.Purchases.History;
using Microsoft.Foundation.Company;

report 50123 "testing report"
{
    ApplicationArea = All;
    Caption = 'testing report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'TestRDL.rdl';
    dataset
    {
        dataitem(Salheader; "Sales Header")
        {
            column(Picture; companyInfo.Picture)
            {
            }
            column(Name; companyInfo.Name)
            {
            }
            column(Address1; companyInfo.Address)
            {
            }
            column(City; companyInfo.City)
            {
            }
            column(PostCode; companyInfo."Post Code")
            {
            }
            column(CountryCode; companyInfo."Country/Region Code")
            {

            }
            dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
            {
                column(PaytoName; "Pay-to Name")
                {
                }
                column(PaytoAddress; "Pay-to Address")
                {
                }
                column(PaytoAddress2; "Pay-to Address 2")
                {
                }
                column(PaytoCity; "Pay-to City")
                {
                }
                column(PaytoPostCode; "Pay-to Post Code")
                {
                }
                column(PaytoCountryCode; "Pay-to Country/Region Code")
                {
                }
                column(DeliveryDocketNo; "Delivery Docket No.")
                {
                }
                column(BuyfromContactNo; "Buy-from Contact No.")
                {
                }
                column(YourReference; "Your Reference")
                {
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    trigger OnInitReport()
    var

    begin
        companyInfo.get();
        companyInfo.CalcFields(Picture);
    end;

    var
        companyInfo: record "Company Information";
}