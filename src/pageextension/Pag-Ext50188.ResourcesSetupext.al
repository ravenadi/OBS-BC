pageextension 50188 "Resources Setup ext" extends "Resources Setup"
{
    layout
    {
        addafter(Numbering)
        {
            Group(Posting)
            {
                Caption = 'Posting';
                field(Journal; Rec.Journal)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal field.', Comment = '%';
                }
                field(Batch; Rec.Batch)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Batch field.', Comment = '%';
                }
            }
        }
    }
}