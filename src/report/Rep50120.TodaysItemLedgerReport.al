report 50120 "Today's Item Ledger Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ReportLayoutdoc;

    dataset
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {


            column(Posting_Date; "Posting Date")
            {
            }
            column(Entry_Type; "Entry Type")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No_; "Document No.")
            {
            }
            column(OBS_Product_Name; "OBS Product Name")
            {
            }

            column(Warehouse_Name; "Warehouse Name")
            {
            }
            column("Quantity"; Quantity)
            {
            }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code")
            {
            }

            column(Location_Code; "Location Code")
            {
            }
            trigger OnPreDataItem()
            var

            begin
                // SetRange("Posting Date", PostingDate); // Filter for today's entries
            end;

            trigger OnAfterGetRecord()
            var

            begin
                CalcFields("OBS Product Name");
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    Caption = 'General';
                    field(Posting_Date; PostingDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Filter by Posting Date.';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(ReportLayout)
        {
            Type = RDLC;
            LayoutFile = './src/Layout/ILE.rdl'; // Design the layout file in RDLC format
        }
        layout(ReportLayoutdoc)
        {
            Type = word;
            LayoutFile = './src/Layout/ILEdoc.docx'; // Design the layout file in RDLC format
        }
    }
    var
        PostingDate: date;
}