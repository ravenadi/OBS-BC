pageextension 70108 "PO Label Action Ext" extends "Purchase Order"
{
    actions
    {
        addlast(Reporting)
        {
            action(POLabel)
            {
                ApplicationArea = All;
                Caption = 'PO Label';
                Image = Print;

                trigger OnAction()
                var
                    PurchaseHeaderRec: Record "Purchase Header";
                begin
                    PurchaseHeaderRec := Rec;
                    PurchaseHeaderRec.SetRecFilter();

                    Report.RunModal(
                        Report::"PO Project Label",
                        true,   // Show request page
                        true,   // Show preview
                        PurchaseHeaderRec
                    );
                end;
            }
        }
    }
}
