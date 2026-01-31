namespace GKBCustomizationsept.GKBCustomizationsept;

using Microsoft.Finance.GeneralLedger.Journal;
// HP::DCS 061025 ++

pageextension 50190 "General Journal Ext" extends "General Journal"
{
    layout
    {
        addafter("Document Date")
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the due date on the entry.';
            }
        }
    }
}
// HP::DCS 061025 --