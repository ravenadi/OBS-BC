page 50136 "Work Order Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "GKB Work Order Type";
    CardPageId = "Work Order Type Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Work Order Name"; Rec."Work Order Type Name")
                {
                    Caption = 'Work Order Type Name';
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = all;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}