pageextension 50125 "Purchase Lines Ext" extends "purchase lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field(Obrien_Business_Unit; Rec.Obrien_Business_Unit)
            {
                ApplicationArea = all;
                Visible = false;
            }
            //GKblabs_tv_24/03/26++++++
        }
        modify("Job No.")
        {
            Visible = true;
        }

        addafter("Line Amount")
        {
            field("Prepmt. Line Amount"; Rec."Prepmt. Line Amount")
            {
                ApplicationArea = All;
                Caption = 'Prepmt. Line Amount';
            }
        }

        addafter("Prepmt. Line Amount")
        {
            field("Net Line Amount"; Rec."Line Amount" - Rec."Prepmt. Line Amount")
            {
                ApplicationArea = All;
                Caption = 'Net Line Amount';
                ToolTip = 'Displays the Line Amount minus Prepayment Line Amount.';
            }
            //GKblabs_tv_24/03/26------
        }
    }
}