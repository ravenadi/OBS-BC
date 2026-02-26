report 70107 "PO Project Label"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = 'POProjectLabel.docx';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Order));

            column(PONo; "No.") { }
            column(JobNo; "Job No") { }

            column(FullTopic; Job."Full Topic") { }
            column(CustomerName; Customer.Name) { }

            trigger OnAfterGetRecord()
            begin
                if Job.Get("Job No") then begin
                    if Customer.Get(Job."Bill-to Customer No.") then;
                end;
            end;
        }
    }

    var
        Job: Record Job;
        Customer: Record Customer;
}
