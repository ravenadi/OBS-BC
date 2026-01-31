page 50140 "Work Order Substatus List"
{
    PageType = List;
    SourceTable = "Work Order Substatus";
    ApplicationArea = All;
    // UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
                field("System Substatus"; Rec."System Substatus")
                {
                    ApplicationArea = All;
                    Caption = 'System Substatus';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                field("CRM ID"; Rec."CRM ID")
                {
                    ApplicationArea = All;
                    Caption = 'CRM ID';
                }
            }
        }
    }
}
