namespace GKBCustomization.GKBCustomization;

using Microsoft.Warehouse.Document;

pageextension 50182 "Warehouse Receipts Ext" extends "Warehouse Receipts"
{
    layout
    {
        addLast(Content)
        {
            field("D01 Preview Posting"; Rec."D01 Preview Posting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the D01 Preview Posting field.', Comment = '%';
            }
        }
    }
}
