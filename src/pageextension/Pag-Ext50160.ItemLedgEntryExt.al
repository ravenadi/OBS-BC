pageextension 51002 "Item LedgEntry Ext Custom" extends "Item ledger Entries"
{
    layout
    {
        addafter("Location Code")
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = all;
            }
        }
    }
}