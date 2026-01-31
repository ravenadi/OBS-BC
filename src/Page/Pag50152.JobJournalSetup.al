namespace GKBCustomization.GKBCustomization;
using Microsoft.Projects.Project.Journal;

page 50152 "Job Journal Setup"
{
    ApplicationArea = All;
    Caption = 'Job Journal Setup';
    PageType = card;
    UsageCategory = Administration;
    SourceTable = "Job Journal Setup";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Journal Template"; Rec."Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Template field.', Comment = '%';
                    TableRelation = "Job Journal Template".Name;
                }
                field("Journal Batch"; Rec."Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Default Journal Batch field.', Comment = '%';
                    TableRelation = "Job Journal Batch".Name;
                }
            }
        }
    }
}
