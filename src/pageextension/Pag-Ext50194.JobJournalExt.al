// DCS::HP06112024 ++
pageextension 50194 "Job Journal Ext" extends "Job Journal"
{
    layout
    {
        addafter(Type)
        {
            field("Entry Type"; Rec."Entry Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
            }
        }
    }
}
// DCS::HP06112024 --