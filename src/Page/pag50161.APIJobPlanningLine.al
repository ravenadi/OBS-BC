page 50161 "API Job Planning Line"
{
    PageType = API;
    Caption = 'API Job Planning Line';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'jobplanninglines';
    EntitySetName = 'jobplanninglines';
    SourceTable = "Job Planning Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(bc_id; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(jobno; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(jobtaskno; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
                field(lineno; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitcost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitprice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(lineamount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'Item No.';
                }
                field(planningdate; Rec."Planning Date")
                {
                    Caption = 'Planning Date';
                }
                field(planneddeliverydate; Rec."Planned Delivery Date")
                {
                    Caption = 'Planned Delivery Date';
                }
                field(resourcegroupno; Rec."Resource Group No.")
                {
                    Caption = 'Resource Group No.';
                }

            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        LastLine: Record "Job Planning Line";
    begin
        if Rec."Line No." = 0 then begin
            LastLine.Reset();
            LastLine.LockTable();
            LastLine.SetRange("Job No.", Rec."Job No.");
            LastLine.SetRange("Job Task No.", Rec."Job Task No.");

            if LastLine.FindLast() then
                Rec."Line No." := LastLine."Line No." + 1000
            else
                Rec."Line No." := 1000;
        end;
        exit(true);
    end;
}