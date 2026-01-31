pageextension 50133 "Job Planning Line Ext" extends "Job Planning Lines Part"
{
    layout
    {
       
        addafter("Line Amount")
        {
            field("Service Duration"; Rec."Service Duration")
            {
                ApplicationArea = All;
            }
            field("Total Cost For Service"; Rec."Total Cost For Service")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the total cost for the Service';
            }
            field(Owner; Rec.Owner)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Owner CRM field.', Comment = '%';
            }

        }
    }
    var
    //  dd: page "Job Planning Lines"
}