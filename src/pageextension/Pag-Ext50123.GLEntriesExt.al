pageextension 50250 "General Ledger Entries Ext" extends "General Ledger Entries"
{
    //Gkblabs_Tv_02/02/26
    layout
    {
        addafter("Job No.")
        {
            field("Job Billing Type"; Rec."Job Billing Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the billing type from the related Job.';
            }
            field("Job System Status"; JobSystemStatusText)
            {
                ApplicationArea = All;
                Caption = 'Job System Status';
                ToolTip = 'Specifies the system status from the related Job.';
                Editable = false;
            }
            field("Job Description"; Rec."Job Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the description from the related Job.';
            }
            field("Service Call Customer Code"; Rec."Service Call Customer Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Sell-to Customer No. from the related Job.';
            }
            field("Service Call Customer Name"; Rec."Service Call Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Sell-to Customer Name from the related Job.';
            }
        }
        addafter("Source No.")
        {
            field("Supplier/Customer Name"; SupplierCustomerName)
            {
                ApplicationArea = All;
                Caption = 'Supplier/Customer Name';
                ToolTip = 'Specifies the vendor or customer name based on Source Type.';
                Editable = false;
            }
        }
        modify("Source Currency Code")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Source Currency Amount")
        {
            Visible = true;
            ApplicationArea = All;
        }
    }

    var
        SupplierCustomerName: Text[100];
        JobSystemStatusText: Text[50];

    trigger OnAfterGetRecord()
    var
        JobRec: Record Job;
    begin
        Rec.CalcFields("Source Vendor Name", "Source Customer Name");
        if Rec."Source Vendor Name" <> '' then
            SupplierCustomerName := Rec."Source Vendor Name"
        else if Rec."Source Customer Name" <> '' then
            SupplierCustomerName := Rec."Source Customer Name"
        else
            SupplierCustomerName := '';

        // Job System Status logic
        if Rec."Job No." <> '' then begin
            if JobRec.Get(Rec."Job No.") then
                JobSystemStatusText := Format(JobRec."System Status")
            else
                JobSystemStatusText := '';
        end else
            JobSystemStatusText := '';
    end;
}