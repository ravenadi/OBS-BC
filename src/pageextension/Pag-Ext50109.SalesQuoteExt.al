pageextension 50109 "Sales Quote Ext" extends "Sales Quote"
{

    actions
    {
        addafter("Archive Document")
        {
            action(ConvertToBlanketOrder)
            {
                Caption = 'Convert to Blanket Sales Order';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    QuoteToBlanketOrder: Codeunit "Sales Quote to Blanket Order";
                begin
                    QuoteToBlanketOrder.ConvertQuoteToBlanketOrder(Rec);
                end;
            }
        }
    }


    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        IsUserAllowed: Boolean;
    begin
        if UserSetup.Get(UserId()) then begin
            IsUserAllowed := UserSetup."Sales Quote";
        end else begin
            IsUserAllowed := false;
        end;
        if not IsUserAllowed then
            CurrPage.Editable(false);
    end;
}
