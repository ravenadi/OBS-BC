pageextension 50201 "Posted Sales Inv Lines Ext" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Description")
        {
            // GkbLabs_Tv_15/12/25
            field("Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task Number for the sales invoice line.';
            }
        }
    }
}
