report 50125 "Aged AR Excel Export"
{
    Caption = 'Aged AR Excel Export';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(No_; "No.") { }
            column(Name; Name) { }

            dataitem("CustLedgerEntry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = where(Open = const(true));

                trigger OnAfterGetRecord()
                var
                    DaysOutstanding: Integer;
                begin
                    DaysOutstanding := Today() - "Due Date";

                    if DaysOutstanding <= 30 then
                        BucketAmounts[1] += "Remaining Amt. (LCY)"
                    else
                        if DaysOutstanding <= 60 then
                            BucketAmounts[2] += "Remaining Amt. (LCY)"
                        else
                            if DaysOutstanding <= 90 then
                                BucketAmounts[3] += "Remaining Amt. (LCY)"
                            else
                                if DaysOutstanding <= 120 then
                                    BucketAmounts[4] += "Remaining Amt. (LCY)"
                                else
                                    BucketAmounts[5] += "Remaining Amt. (LCY)"
                end;

                trigger OnPostDataItem()
                begin
                    if (BucketAmounts[1] + BucketAmounts[2] + BucketAmounts[3] + BucketAmounts[4] + BucketAmounts[5]) <> 0 then
                        InsertExcelRow();
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(BucketAmounts);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    field("As of Date"; AsOfDate)
                    {
                        ApplicationArea = All;
                        Caption = 'As of Date';
                    }
                }
            }
        }
    }

    var
        ExcelBuf: Record "Excel Buffer";
        AsOfDate: Date;
        BucketAmounts: array[6] of Decimal;

    trigger OnPreReport()
    begin
        ExcelBuf.DeleteAll();
        InsertExcelHeader();
    end;

    trigger OnPostReport()
    begin
        ExcelBuf.CreateNewBook('Aged AR Export');
        ExcelBuf.WriteSheet('Aging Report', CompanyName, UserId);
        ExcelBuf.CloseBook();
        ExcelBuf.OpenExcel();
    end;

    procedure InsertExcelHeader()
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn('Customer No.', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('Customer Name', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('0 - 30 Days', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('31 - 60 Days', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('61 - 90 Days', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('91 - 120 Days', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn('121+ Days', false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
    end;

    procedure InsertExcelRow()
    var
        i: Integer;
    begin
        ExcelBuf.NewRow();
        ExcelBuf.AddColumn(Customer."No.", false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);
        ExcelBuf.AddColumn(Customer.Name, false, '', false, false, false, '', ExcelBuf."Cell Type"::Text);

        for i := 1 to 5 do
            ExcelBuf.AddColumn(BucketAmounts[i], false, '', false, false, false, '#,##0.00', ExcelBuf."Cell Type"::Number);
    end;
}
