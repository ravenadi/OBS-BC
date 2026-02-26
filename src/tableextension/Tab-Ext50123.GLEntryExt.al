tableextension 50250 "G/L Entry Ext" extends "G/L Entry"
{
    //Gkblabs_Tv_02/02/26
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
            Editable = false;
        }
        field(50258; "Job System Status Text"; Text[50])
        {
            Caption = 'Job System Status';
            Editable = false;
        }
        field(50252; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Job.Description where("No." = field("Job No.")));
        }
        field(50253; "Source Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Source No.")));
            Editable = false;
        }
        field(50254; "Source Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Source No.")));
            Editable = false;
        }
        field(50255; "Service Call Customer Code"; Code[20])
        {
            Caption = 'Service Call Customer Code';
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Sell-to Customer No." where("No." = field("Job No.")));
            Editable = false;
        }
        field(50256; "Service Call Customer Name"; Text[100])
        {
            Caption = 'Service Call Customer Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Sell-to Customer Name" where("No." = field("Job No.")));
            Editable = false;
        }
        field(50257; "Supplier/Customer Name"; Text[100])
        {
            Caption = 'Supplier/Customer Name';
            Editable = false;
        }
    }
}