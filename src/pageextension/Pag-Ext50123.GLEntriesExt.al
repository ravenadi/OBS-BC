pageextension 50250 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        addafter("Job No.")
        {
            field("Job Billing Type"; Rec."Job Billing Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the billing type from the related Job.';
            }
            field("Job System Status"; Rec."Job System Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the system status from the related Job.';
            }
            field("Job Description"; Rec."Job Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description from the related Job.';
            }
        }
    }
}