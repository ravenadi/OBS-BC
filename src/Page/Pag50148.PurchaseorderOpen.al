page 50148 "Purchase order - Open"
{
    PageType = CardPart;
    SourceTable = "Purchase Header";
    ApplicationArea = All;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(PurchaseOrderGroup)
            {
                Caption = 'Purchase Order';

                field(OpenOrders; CountOpenOrders())
                {
                    Caption = 'Open';
                    DrillDown = true;
                    ToolTip = 'Number of open purchase orders.';
                    Style = Favorable;
                    StyleExpr = true;

                    trigger OnDrillDown()
                    var
                        POList: Page "Purchase Order List";
                        PurchHeader: Record "Purchase Header";
                    begin
                        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
                        POList.SetTableView(PurchHeader);
                        POList.Run();
                    end;
                }
            }
        }
    }

    local procedure CountOpenOrders(): Integer
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.SetRange(Status, PurchHeader.Status::Open);
        exit(PurchHeader.Count);
    end;
}
