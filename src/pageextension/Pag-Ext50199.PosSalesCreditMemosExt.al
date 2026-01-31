pageextension 50199 "Pos Sales Credit Memos Ext" extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            // GkbLabs_Tv_18/11/25
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the document that this credit memo applies to.';
            }
        }
    }
}
