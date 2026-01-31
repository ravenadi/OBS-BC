namespace GKBCustomization.GKBCustomization;

page 50151 "Error Log"
{
    ApplicationArea = All;
    Caption = 'Error Log';
    PageType = List;
    SourceTable = "Error Log";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field.', Comment = '%';
                }
                field("Document No"; Rec."Document No")
                {
                    ToolTip = 'Specifies the value of the Document No field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Line No"; Rec."Line No")
                {
                    ToolTip = 'Specifies the value of the Line No field.', Comment = '%';
                }
            }
        }
    }
}
