// DCS::HP18112025 ++
pageextension 50197 "Pos Purchase Credit Memos Ext" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s number for this credit memo.';
            }

            // GkbLabs_Tv_18/11/25
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the document that this credit memo applies to.';
            }
            // GkbLabs_Tv_18/11/25
        }
        // DCS::HP18112025 --



    }
}
