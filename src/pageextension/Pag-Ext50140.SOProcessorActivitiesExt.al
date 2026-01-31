pageextension 50140 "SO Processor Activities Ext" extends "SO Processor Activities" //DCS:SK 19/05/2025 ExtMerged NS
{
    layout
    {
        addafter("For Release")
        {
            cuegroup("Requisition Status")
            {
                Caption = 'Requisition';
                // DCS::HP 031025 ++
                // field("Pending Approval"; Rec."Pending Approval")
                // {
                //     ApplicationArea = Suite;
                //     ToolTip = 'Number of open requisitions';
                //     DrillDownPageId = "Req. Worksheet";
                // }
                // field("Rejected"; Rec."Rejected")
                // {
                //     ApplicationArea = Suite;
                //     ToolTip = 'Number of requisitions pending approval';
                //     DrillDownPageId = "Req. Worksheet";
                // }
                // field(Released; Rec.Released)
                // {
                //     ApplicationArea = Suite;
                //     ToolTip = 'Number of released requisitions';
                //     DrillDownPageId = "Req. Worksheet";
                // }
                // DCS::HP 031025 --
                field("PO Created"; Rec."PO Created")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Number of requisitions with PO created';
                    DrillDownPageId = "Purchase Order List";
                }
            } //DCS:SK 19/05/2025 ExtMerged NS
        }
    }


}
