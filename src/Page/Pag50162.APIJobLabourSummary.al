page 50162 "API Job Labour Summary"
{
    //GKb-surender
    PageType = API;
    Caption = 'API Job Labour Summary';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'joblaboursummaries';
    EntitySetName = 'joblaboursummaries';
    SourceTable = Job;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(jobNo; Rec."No.")
                {
                    Caption = 'Job No.';
                }
                field(totalLabourQuantity; GetTotalLabourQuantity())
                {
                    Caption = 'Total Labour Quantity';
                }
                field(crmId; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
            }
        }
    }

    // No actions exposed on the API page to keep payload minimal

    local procedure GetTotalLabourQuantity(): Decimal
    var
        JobLabourMgt: Codeunit "Job Labour Summary Mgt";
        val: Decimal;
    begin
        // Ensure the stored value is up to date, then return it
        JobLabourMgt.RecalculateJobLabour(Rec."No.");
        Rec.Get(Rec."No.");
        val := Rec."Total Labour Quantity";
        exit(val);
    end;
}