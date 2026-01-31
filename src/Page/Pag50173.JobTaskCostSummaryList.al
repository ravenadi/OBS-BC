// DCS::HP01122025++
page 50173 "Job Task Cost Summary List"
{
    // ApplicationArea = All;
    Caption = 'Job Task Cost Summary List';
    PageType = List;
    SourceTable = "Job";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Project Usage (Total Cost)"; Rec."Project Usage (Total Cost)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Actual (Total Cost) field.', Comment = '%';
                }
                // DCS::HP02122025 ++
                field("CRM ID"; Rec."CRM ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Crm Id field.', Comment = '%';
                }
                // DCS::HP02122025 --
            }
        }
    }
}
// DCS::HP01122025--