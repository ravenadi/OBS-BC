page 50141 "Req WO FactBox"
{
    ApplicationArea = All;
    Caption = 'Purchase Request Details';
    PageType = CardPart;
    SourceTable = "Requisition Line";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Replenishment System"; Rec."Replenishment System")
                {
                    ApplicationArea = Planning;
                    TableRelation = Item;
                    ToolTip = 'Specifies the type of supply order that is created by the planning system when the item needs to be replenished.';
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies text that describes the entry.';
                }
                field(InventoryList; InventoryList)
                {
                    Caption = 'Inventory';
                    ToolTip = 'Specifies the number of inventory';
                }

                field(PurchaseQty; PurchaseQty)
                {
                    Caption = 'Qty On Purchase Order';
                    ToolTip = 'Specifirs the number of purchase order';
                }
                field(SalesQty; SalesQty)
                {
                    Caption = 'Qty On Sales Order';
                    ToolTip = 'Specifies The number of sales orders';
                }
                field(Availability; CalcAvailability(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Availability';
                    DecimalPlaces = 0 : 5;
                    DrillDown = true;
                    Editable = true;
                    ToolTip = 'Specifies how many units of the item on the Requisition line are available.';

                    trigger OnDrillDown()
                    var
                        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
                    begin
                        ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByEvent());
                        CurrPage.Update(true);
                    end;
                }

                group(Purchase)
                {
                    Caption = 'Purchase';
                    Visible = false;
                    field("Vendor No."; Rec."Vendor No.")
                    {
                        ApplicationArea = Planning;
                        Lookup = false;
                        ToolTip = 'Specifies the code of the vendor from whom this item is supplied by default.';

                        trigger OnDrillDown()
                        var
                            Vendor: Record Vendor;
                        begin
                            Vendor.SetFilter("No.", Rec."Vendor No.");

                            PAGE.Run(PAGE::"Vendor Card", Vendor);
                        end;
                    }
                    field("Vendor Item No."; Rec."Vendor Item No.")
                    {
                        ApplicationArea = Planning;
                        Lookup = false;
                        ToolTip = 'Specifies the number that the vendor uses for this item.';
                    }


                    field(Availability2; ItemAvailability(Rec))
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Availability';
                        DecimalPlaces = 0 : 5;
                        DrillDown = true;
                        Editable = true;
                        ToolTip = 'Specifies how many units of the item on the Requisition line are available.';

                        trigger OnDrillDown()
                        var
                            ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
                        begin
                            ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByEvent());
                            CurrPage.Update(true);
                        end;
                    }

                }

            }
        }
    }
    local procedure CalcAvailability(var ReqLine: Record "Requisition Line"): Decimal
    var
        AvailableToPromise: Codeunit "Available to Promise";
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        AvailableQuantity: Decimal;
        PeriodType: Enum "Analysis Period Type";
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        IsHandled: Boolean;
        Item: Record Item;
    begin
        if Item.Get(Rec."No.") then begin
            if ReqLine."Due Date" <> 0D then //"Expected Receipt Date"
                AvailabilityDate := ReqLine."Due Date" //"Expected Receipt Date"
            else
                AvailabilityDate := WorkDate();
            Item.Reset();
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", ReqLine."Variant Code");
            Item.SetRange("Location Filter", ReqLine."Location Code");
            Item.SetRange("Drop Shipment Filter", false);
            IsHandled := false;
            if IsHandled then exit(AvailableQuantity);
            exit(AvailableToPromise.CalcQtyAvailabletoPromise(Item, GrossRequirement, ScheduledReceipt, AvailabilityDate, PeriodType, LookaheadDateformula));
        end;
    end;

    local procedure ItemAvailability(ReqLine: Record "Requisition Line"): Decimal
    var
        Item: Record Item;
    begin
        if Item.Get(ReqLine."No.") then begin
            Item.CalcFields(Inventory, "Qty. on Prod. Order", "Qty. on Sales Order");
            exit(Item.Inventory + Item."Qty. on Prod. Order" - Item."Qty. on Sales Order");

        end;
    end;

    procedure ShowItemAvailFromPurchLine(var ReqLine: Record "Requisition Line"; AvailabilityType: Option Date,Variant,Location,Bin,"Event",BOM,UOM)
    var
        Item: Record Item;
        NewDate: Date;
        NewVariantCode: Code[10];
        NewLocationCode: Code[10];
        NewUnitOfMeasureCode: Code[10];
        IsHandled: Boolean;
        ItemAvailCU: Codeunit "Item Availability Forms Mgt";
    begin
        ReqLine.TestField(Type, ReqLine.Type::Item);
        ReqLine.TestField("No.");
        Item.Reset();
        Item.Get(ReqLine."No.");
        FilterItem(Item, ReqLine."Location Code", ReqLine."Variant Code", ReqLine."Due Date"); //"Expected Receipt Date");
        IsHandled := false;
        //OnBeforeShowItemAvailFromPurchLine(Item, ReqLine, IsHandled, AvailabilityType);
        if IsHandled then exit;
        case AvailabilityType of
            AvailabilityType::Date:
                if ItemAvailCU.ShowItemAvailabilityByPeriod(Item, ReqLine.FieldCaption(ReqLine."Due Date"), ReqLine."Due Date", NewDate) then
                    ReqLine.Validate(ReqLine."Due Date", NewDate);
            AvailabilityType::Variant:
                if ItemAvailCU.ShowItemAvailabilityByVariant(Item, ReqLine.FieldCaption(ReqLine."Variant Code"), ReqLine."Variant Code", NewVariantCode) then
                    ReqLine.Validate(ReqLine."Variant Code", NewVariantCode);
            AvailabilityType::Location:
                if ItemAvailCU.ShowItemAvailabilityByLocation(Item, ReqLine.FieldCaption(ReqLine."Location Code"), ReqLine."Location Code", NewLocationCode) then
                    ReqLine.Validate(ReqLine."Location Code", NewLocationCode);
            AvailabilityType::"Event":
                if ItemAvailCU.ShowItemAvailabilityByEvent(Item, ReqLine.FieldCaption(ReqLine."Due Date"), ReqLine."Due Date", NewDate, false) then
                    ReqLine.Validate(ReqLine."Due Date", NewDate);
            AvailabilityType::BOM:
                if ItemAvailCU.ShowItemAvailabilityByBOMLevel(Item, ReqLine.FieldCaption(ReqLine."Due Date"), ReqLine."Due Date", NewDate) then
                    ReqLine.Validate(ReqLine."Due Date", NewDate);
            AvailabilityType::UOM:
                if ItemAvailCU.ShowItemAvailabilityByUOM(Item, ReqLine.FieldCaption(ReqLine."Unit of Measure Code"), ReqLine."Unit of Measure Code", NewUnitOfMeasureCode) then
                    ReqLine.Validate(ReqLine."Unit of Measure Code", NewUnitOfMeasureCode);
        end;
    end;

    local procedure FilterItem(var Item: Record Item; LocationCode: Code[20]; VariantCode: Code[20]; Date: Date)
    begin
        // Do not make global
        // Request to make function global has been rejected as it is a skeleton function of the codeunit
        Item.SetRange("No.", Item."No.");
        Item.SetRange("Date Filter", 0D, Date);
        Item.SetRange("Variant Filter", VariantCode);
        Item.SetRange("Location Filter", LocationCode);
    end;

    var
        InventoryList: Integer;
        PurchaseQty: Integer;
        SalesQty: Integer;

    trigger OnAfterGetRecord()
    begin
        GetItemInfo(Rec)
    end;

    local procedure GetItemInfo(ReqLine: Record "Requisition Line"): Integer
    var
        Item: Record Item;
    begin
        if Item.Get(ReqLine."No.") then begin
            Item.CalcFields(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
            InventoryList := Item.Inventory;
            PurchaseQty := Item."Qty. on Purch. Order";
            SalesQty := Item."Qty. on Sales Order";
        end;
    end;

}
