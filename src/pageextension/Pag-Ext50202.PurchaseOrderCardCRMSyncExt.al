pageextension 50202 "PO Card CRM Sync Ext Custom" extends "Purchase Order"
{
    actions
    {
        addlast(Processing)
        {
            action(SendToCRMCustom)
            {
                ApplicationArea = All;
                Caption = 'Update To CRM';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Send this purchase order to CRM (custom button).';
                trigger OnAction()
                var
                    Sync: Codeunit "PO CRM Sync Mgmt";
                begin
                    if Rec."Document Type" <> Rec."Document Type"::Order then
                        exit;
                    if Rec."No." = '' then
                        exit;
                    Sync.SendPurchaseOrderToCRM(Rec."No.");
                end;
            }
        }
    }
}