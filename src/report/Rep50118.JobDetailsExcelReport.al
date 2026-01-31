report 50118 "Job Details Excel Report"
{
    Caption = 'Activity VS Payment Report';
    ProcessingOnly = true;

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Job; Job)
        {
            column(No_; "No.") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column("Branch"; "Global Dimension 1 Code") { } // Change if Branch is stored elsewhere
            column("Subject"; Subject) { } // Replace with correct field if needed
            trigger OnAfterGetRecord()
            var
            begin
                createbody();
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
                    // field("Show All"; ShowAll)
                    // {
                    //     ApplicationArea = All;
                    // }
                }
            }
        }

        actions
        {
        }
    }



    trigger OnPreReport()
    var

    begin
        CreateHeader();
    end;

    trigger OnPostReport()

    begin
        CreationofExcel();
    end;

    procedure CreationofExcel()
    begin
        TempExcelBuffer.CreateNewBook('Activity VS Payment');
        TempExcelBuffer.WriteSheet('Job', CompanyName, UserId);
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('JOb');
        TempExcelBuffer.OpenExcel();
    end;

    procedure CreateHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Project No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::text);
        TempExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Branch', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Subject', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);

    end;

    procedure CreateBody()
    var
        JobRec: Record Job;
    begin
        // JobRec.Reset();
        // JobRec.SetRange("Status", JobRec."Status"::Open);
        // if JobRec.FindSet() then begin
        //     repeat
        //         Clear(Subject);
        // If Subject is custom, fetch from related table or custom field
        Subject := job.Description; // Placeholder for "Subject"
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(job."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Job."Sell-to Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Job."Sell-to Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Job."Global Dimension 1 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Subject, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        // TempExcelBuffer.NewRow();
        //     until JobRec.Next() = 0;
        // end;
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        Subject: Text;
}
