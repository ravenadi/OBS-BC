page 50155 "Resource Posting Setup"
{
    ApplicationArea = All;
    Caption = 'Resource Posting Setup';
    PageType = List;
    SourceTable = "Resource Posting";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                // Caption = 'General';

                field("Gen. Product Posting"; Rec."Gen. Product Posting")
                {
                    ToolTip = 'Specifies the value of the Gen. Product Posting field.', Comment = '%';
                }
                field("Cost G/L"; Rec."Cost G/L")
                {
                    ToolTip = 'Specifies the value of the Cost G/L field.', Comment = '%';
                }
                field("Balance G/L"; Rec."Balance G/L")
                {
                    ToolTip = 'Specifies the value of the Balance G/L field.', Comment = '%';
                }
            }
        }
    }
}