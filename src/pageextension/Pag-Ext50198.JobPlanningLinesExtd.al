// DCS::HP01122025++
pageextension 50198 "Job Planning Lines Extd" extends "Job Planning Lines"
{
    layout
    {
        addafter("Job Task No.")
        {
            field("Project Sub-Task No."; Rec."Project Sub-Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Project Sub-Task No. field.', Comment = '%';
                Visible = false;
            }
        }
    }
}
// DCS::HP01122025--