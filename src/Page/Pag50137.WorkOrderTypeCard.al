page 50137 "Work Order Type Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "GKB Work Order Type";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Work Order Name"; Rec."Work Order Type Name")
                {
                    ApplicationArea = all;
                    Caption = 'Work Order Type Name';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
            }
        }
    }
}