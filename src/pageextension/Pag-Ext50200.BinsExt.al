namespace GKBCustomization.GKBCustomization;

using Microsoft.Warehouse.Structure;

pageextension 50210 "Bins Ext" extends "Bins"
{
    layout
    {
        addlast(Control1)
        {
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = All;
                Caption = 'CRM ID';
                ToolTip = 'Specifies the CRM ID for this bin.';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(UpdateCRM)
            {
                Caption = 'Update To CRM';
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update this bin record in the external CRM.';

                trigger OnAction()
                var
                    BinCRM: Codeunit "Bin Crm Management";
                begin
                    BinCRM.UpdateToCrm(Rec);
                    Message('Successfully updated in CRM.');
                end;
            }
        }
    }
}