tableextension 50250 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(50250; "Job Billing Type"; Enum "Charge Status")
        {
            Caption = 'Job Billing Type';
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Billing Type" where("No." = field("Job No.")));
        }
        field(50251; "Job System Status"; Enum "Task Status1")
        {
            Caption = 'Job System Status';
            FieldClass = FlowField;
            CalcFormula = lookup(Job."System Status" where("No." = field("Job No.")));
        }
        field(50252; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Job.Description where("No." = field("Job No.")));
        }
    }
}