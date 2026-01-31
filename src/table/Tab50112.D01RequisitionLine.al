table 50112 "D01 Requisition Line" //DCS HJ20252111
{
    Caption = 'Requisition Line';
    DataClassification = ToBeClassified;
    fields
    {
        field(50159; "Entry No "; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            // TableRelation = "Req. Wksh. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            // TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Worksheet Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Enum "Requisition Line Type")
        {
            Caption = 'Type';

            // trigger OnValidate()
            // var
            //     NewType: Enum "Requisition Line Type";
            // begin
            //     if Type <> xRec.Type then begin
            //         NewType := Type;

            //         DeleteRelations();
            //         "Dimension Set ID" := 0;
            //         "No." := '';
            //         "Variant Code" := '';
            //         "Location Code" := '';
            //         CleanProdOrderNo();
            //         ReqLineReserve.VerifyChange(Rec, xRec);
            //         AddOnIntegrMgt.ResetReqLineFields(Rec);
            //         Init();
            //         Type := NewType;
            //     end;
            // end;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            // TableRelation = if (Type = const("G/L Account")) "G/L Account"
            // else
            // if (Type = const(Item)) Item;

            // trigger OnValidate()
            // var
            //     ShouldValidateUnitofMeasureCode: Boolean;
            // begin
            //     CheckActionMessageNew();
            //     ReqLineReserve.VerifyChange(Rec, xRec);
            //     DeleteRelations();

            //     if "No." = '' then begin
            //         CreateDimFromDefaultDim();
            //         Init();
            //         Type := xRec.Type;
            //         exit;
            //     end;

            //     if "No." <> xRec."No." then begin
            //         "Variant Code" := '';
            //         CleanProdOrderNo();
            //         AddOnIntegrMgt.ResetReqLineFields(Rec);
            //     end;

            //     TestField(Type);
            //     case Type of
            //         Type::"G/L Account":
            //             CopyFromGLAcc();
            //         Type::Item:
            //             CopyFromItem();
            //     end;

            //     OnValidateNoOnAfterAssignFieldsForNo(Rec, xRec);

            //     ShouldValidateUnitofMeasureCode := "Planning Line Origin" <> "Planning Line Origin"::"Order Planning";
            //     OnValidateNoOfAfterCalcShouldValidateUnitofMeasureCode(Rec, xRec, Item, ShouldValidateUnitofMeasureCode);
            //     if ShouldValidateUnitofMeasureCode then
            //         if ("Replenishment System" = "Replenishment System"::Purchase) and
            //            (Item."Purch. Unit of Measure" <> '')
            //         then
            //             Validate("Unit of Measure Code", Item."Purch. Unit of Measure")
            //         else
            //             Validate("Unit of Measure Code", Item."Base Unit of Measure");

            //     CreateDimFromDefaultDim();
            // end;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            // trigger OnValidate()
            // begin
            //     Quantity := UOMMgt.RoundAndValidateQty(Quantity, "Qty. Rounding Precision", FieldCaption(Quantity));

            //     "Quantity (Base)" :=
            //         UOMMgt.CalcBaseQty(
            //             "No.", "Variant Code", "Unit of Measure Code", Quantity, "Qty. per Unit of Measure",
            //             "Qty. Rounding Precision (Base)", FieldCaption("Qty. Rounding Precision"), FieldCaption(Quantity),
            //             FieldCaption("Quantity (Base)"));

            //     if Type = Type::Item then begin
            //         OnValidateQuantityOnBeforeGetDirectCost(Rec, xRec, CurrFieldNo);
            //         GetDirectCost(FieldNo(Quantity));
            //         SetRemaningQuantity();

            //         if (CurrFieldNo = FieldNo(Quantity)) or (CurrentFieldNo = FieldNo(Quantity)) then
            //             SetActionMessage();

            //         "Net Quantity (Base)" := (Quantity - "Original Quantity") * "Qty. per Unit of Measure";

            //         OnValidateQuantityOnBeforeUnitCost(Rec, CurrFieldNo, CurrentFieldNo);
            //         Validate("Unit Cost");
            //         if ValidateFields() then
            //             if "Ending Date" <> 0D then
            //                 Validate("Ending Time")
            //             else begin
            //                 if "Starting Date" = 0D then
            //                     "Starting Date" := WorkDate();
            //                 Validate("Starting Time");
            //             end;
            //         ReqLineReserve.VerifyQuantity(Rec, xRec);
            //     end;
            // end;
        }
        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            // trigger OnLookup()
            // var
            //     Vend: Record Vendor;
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeLookupVendorNo(Rec, IsHandled);
            //     if IsHandled then
            //         exit;

            //     if LookupVendor(Vend, true) then
            //         Validate("Vendor No.", Vend."No.");

            //     OnAfterLookupVendorNo(Rec, Vend);
            // end;

            // trigger OnValidate()
            // var
            //     Vend: Record Vendor;
            //     ItemVend: Record "Item Vendor";
            //     TempSKU: Record "Stockkeeping Unit" temporary;
            //     IsHandled: Boolean;
            // begin
            //     CheckActionMessageNew();
            //     "Order Address Code" := '';
            //     if "Vendor No." <> '' then
            //         if Vend.Get("Vendor No.") then begin
            //             if Vend."Privacy Blocked" then begin
            //                 if PlanningResiliency then
            //                     TempPlanningErrorLog.SetError(
            //                       StrSubstNo(Text031, Vend.TableCaption(), Vend."No."),
            //                       Database::Vendor, CopyStr(Vend.GetPosition(), 1, 250));
            //                 Vend.VendPrivacyBlockedErrorMessage(Vend, false);
            //             end;
            //             CheckVendorBlocked(Vend);
            //             if "Order Date" = 0D then
            //                 Validate("Order Date", WorkDate());

            //             Validate("Currency Code", Vend."Currency Code");
            //             if ("Planning Line Origin" <> "Planning Line Origin"::Planning) or ("Price Calculation Method" = "Price Calculation Method"::" ") then
            //                 "Price Calculation Method" := Vend.GetPriceCalculationMethod();
            //             ValidateItemDescriptionAndQuantity(Vend);
            //             SetPurchaserCode(Vend."Purchaser Code", "Purchaser Code");
            //         end else begin
            //             if ValidateFields() then
            //                 Error(Text005, FieldCaption("Vendor No."), "Vendor No.");
            //             "Vendor No." := '';
            //             if ("Planning Line Origin" <> "Planning Line Origin"::Planning) or ("Price Calculation Method" = "Price Calculation Method"::" ") then
            //                 "Price Calculation Method" := Vend.GetPriceCalculationMethod();
            //         end
            //     else begin
            //         UpdateDescription();
            //         if ("Planning Line Origin" <> "Planning Line Origin"::Planning) or ("Price Calculation Method" = "Price Calculation Method"::" ") then
            //             "Price Calculation Method" := Vend.GetPriceCalculationMethod();
            //     end;
            //     UpdateDescription();

            //     GetLocationCode();
            //     OnValidateVendorNoOnAfterGetLocationCode(Rec);
            //     GetDefaultBinCode();

            //     if (Type = Type::Item) and ("No." <> '') and (not IsProdOrder()) then begin
            //         if ItemVend.Get("Vendor No.", "No.", "Variant Code") then begin
            //             IsHandled := false;
            //             OnValidateVendorNoOnBeforeSetVendorItemNoFromItemVend(Rec, IsHandled);
            //             if not IsHandled then
            //                 "Vendor Item No." := ItemVend."Vendor Item No.";
            //             if not DoNotUpdateOrderReceiptDate then
            //                 UpdateOrderReceiptDate(ItemVend."Lead Time Calculation");
            //         end else begin
            //             GetPlanningParameters.AtSKU(TempSKU, "No.", "Variant Code", "Location Code");
            //             if "Vendor No." = TempSKU."Vendor No." then
            //                 "Vendor Item No." := TempSKU."Vendor Item No."
            //             else
            //                 "Vendor Item No." := '';
            //         end;
            //         OnValidateVendorNoOnBeforeGetDirectCost(Rec, xRec, CurrFieldNo);
            //         GetDirectCost(FieldNo("Vendor No."))
            //     end;
            //     "Supply From" := "Vendor No.";

            //     UpdateDim();
            // end;
        }
        field(10; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(12; "Due Date"; Date)
        {
            Caption = 'Due Date';

            // trigger OnValidate()
            // var
            //     ShouldExitDueDate: Boolean;
            // begin
            //     if (CurrFieldNo = FieldNo("Due Date")) or (CurrentFieldNo = FieldNo("Due Date")) then
            //         SetActionMessage();

            //     ShouldExitDueDate := "Due Date" = 0D;
            //     OnValidateDueDateOnAfterCalcShouldExitDueDate(Rec, xRec, CurrFieldNo, ShouldExitDueDate);
            //     if ShouldExitDueDate then
            //         exit;

            //     if (CurrFieldNo = FieldNo("Due Date")) or (CurrentFieldNo = FieldNo("Due Date")) then
            //         if (Type = Type::Item) and
            //            ("Planning Level" = 0)
            //         then
            //             Validate(
            //               "Ending Date",
            //               LeadTimeMgt.GetPlannedEndingDate("No.", "Location Code", "Variant Code", "Due Date", '', "Ref. Order Type"))
            //         else
            //             Validate("Ending Date", "Due Date");

            //     CheckDueDateToDemandDate();
            // end;
        }
        field(13; "Requester ID"; Code[50])
        {
            Caption = 'Requester ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit System.Security.User."User Selection";
            begin
                UserSelection.ValidateUserName("Requester ID");
            end;
        }
        field(14; Confirmed; Boolean)
        {
            Caption = 'Confirmed';
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
            //                                               Blocked = const(false));

            // trigger OnValidate()
            // begin
            //     Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            // end;
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            // TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
            //                                               Blocked = const(false));

            // trigger OnValidate()
            // begin
            //     Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            // end;
        }
        field(17; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            // TableRelation = Location where("Use As In-Transit" = const(false));

            // trigger OnValidate()
            // var
            //     ItemVend: Record "Item Vendor";
            //     ShouldGetDefaultBin: Boolean;
            // begin
            //     ValidateLocationChange();
            //     CheckActionMessageNew();
            //     "Bin Code" := '';
            //     ReqLineReserve.VerifyChange(Rec, xRec);

            //     if Type = Type::Item then begin
            //         UpdateReplenishmentSystem();
            //         if "Location Code" <> xRec."Location Code" then
            //             if ("Location Code" <> '') and ("No." <> '') and not IsDropShipment() then begin
            //                 GetLocation("Location Code");
            //                 ShouldGetDefaultBin := Location."Bin Mandatory" and not Location."Directed Put-away and Pick";
            //                 OnValidateLocationCodeOnBeforeGetDefaultBin(Rec, ShouldGetDefaultBin, Location, CurrFieldNo);
            //                 if ShouldGetDefaultBin then
            //                     WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", "Bin Code");
            //             end;
            //         if ItemVend.Get("Vendor No.", "No.", "Variant Code") then
            //             "Vendor Item No." := ItemVend."Vendor Item No.";
            //     end;
            //     GetDirectCost(FieldNo("Location Code"));
            //     CreateDimFromDefaultDim();
            // end;
        }
        field(18; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(19; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(20; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(21; "Order Date"; Date)
        {
            Caption = 'Order Date';

            // trigger OnValidate()
            // begin
            //     "Starting Date" := "Order Date";

            //     GetDirectCost(FieldNo("Order Date"));

            //     if CurrFieldNo = FieldNo("Order Date") then
            //         Validate("Starting Date");
            // end;
        }
        field(22; "Vendor Item No."; Text[50])
        {
            Caption = 'Vendor Item No.';
        }
        field(23; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            // TableRelation = "Sales Header"."No." where("Document Type" = const(Order));

            // trigger OnValidate()
            // begin
            //     ReqLineReserve.VerifyChange(Rec, xRec);
            // end;
        }
        field(24; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            // trigger OnValidate()
            // begin
            //     ReqLineReserve.VerifyChange(Rec, xRec);
            // end;
        }
        field(25; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            // TableRelation = Customer;

            // trigger OnValidate()
            // begin
            //     if "Sell-to Customer No." = '' then
            //         "Ship-to Code" := ''
            //     else
            //         Rec.Validate("Ship-to Code", '');

            //     ReqLineReserve.VerifyChange(Rec, xRec);
            // end;
        }
        field(26; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Editable = false;
            // TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            // trigger OnValidate()
            // var
            //     Cust: Record Customer;
            //     ShipToAddr: Record "Ship-to Address";
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeOnValidateShipToCode(Rec, IsHandled);
            //     if IsHandled then
            //         exit;

            //     if "Ship-to Code" <> '' then begin
            //         ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code");
            //         "Location Code" := ShipToAddr."Location Code";
            //     end else begin
            //         Cust.Get("Sell-to Customer No.");
            //         "Location Code" := Cust."Location Code";
            //     end;
            // end;
        }
        field(28; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            // TableRelation = "Order Address".Code where("Vendor No." = field("Vendor No."));
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            // TableRelation = Currency;

            // trigger OnValidate()
            // var
            //     Currency: Record Currency;
            //     CurrExchRate: Record "Currency Exchange Rate";
            // begin
            //     Currency.Initialize("Currency Code");
            //     if "Currency Code" <> '' then begin
            //         TestField("Order Date");
            //         if PlanningResiliency then
            //             CheckExchRate(Currency);
            //         OnValidateCurrencyCodeOnBeforeUpdateCurrencyFactor(Rec, CurrExchRate);
            //         Rec.Validate("Currency Factor", CurrExchRate.ExchangeRate("Order Date", "Currency Code"));
            //     end else
            //         Rec.Validate("Currency Factor", 0);

            //     GetDirectCost(FieldNo("Currency Code"));
            // end;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;

            // trigger OnValidate()
            // var
            //     CurrExchRate: Record "Currency Exchange Rate";
            // begin
            //     if "Currency Code" <> '' then
            //         TestField("Currency Factor");
            //     if "Currency Factor" <> xRec."Currency Factor" then begin
            //         OnValidateCurrencyFactorOnBeforeUpdateDirectUnitCost(Rec, CurrExchRate);
            //         if xRec."Currency Factor" <> 0 then
            //             "Direct Unit Cost" :=
            //               CurrExchRate.ExchangeAmtFCYToLCY(
            //                 "Order Date", xRec."Currency Code", "Direct Unit Cost", xRec."Currency Factor");
            //         if "Currency Factor" <> 0 then
            //             "Direct Unit Cost" :=
            //               CurrExchRate.ExchangeAmtLCYToFCY(
            //                 "Order Date", "Currency Code", "Direct Unit Cost", "Currency Factor");
            //     end;
            // end;
        }
        field(31; "Reserved Quantity"; Decimal)
        {
            // CalcFormula = sum("Reservation Entry".Quantity where("Source ID" = field("Worksheet Template Name"),
            //                                                       "Source Ref. No." = field("Line No."),
            //                                                       "Source Type" = const(246),
            //                                                       "Source Subtype" = const("0"),
            //                                                       "Source Batch Name" = field("Journal Batch Name"),
            //                                                       "Source Prod. Order Line" = const(0),
            //                                                       "Reservation Status" = const(Reservation)));
            // Caption = 'Reserved Quantity';
            // DecimalPlaces = 0 : 5;
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(43; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            // TableRelation = "Salesperson/Purchaser" where(Blocked = const(false));

            // trigger OnValidate()
            // begin
            //     CreateDimFromDefaultDim();
            // end;
        }
        field(73; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            // TableRelation = "Dimension Set Entry";

            // trigger OnLookup()
            // begin
            //     Rec.ShowDimensions();
            // end;

            // trigger OnValidate()
            // begin
            //     DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            // end;
        }
        field(5401; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            // TableRelation = "Production Order"."No." where(Status = const(Released));
            // ValidateTableRelation = false;

            // trigger OnValidate()
            // begin
            //     AddOnIntegrMgt.ValidateProdOrderOnReqLine(Rec);
            //     Validate("Unit of Measure Code");
            // end;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            // TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));

            // trigger OnValidate()
            // var
            //     ItemVend: Record "Item Vendor";
            //     ShouldGetDefaultBin: Boolean;
            // begin
            //     if "Variant Code" <> '' then begin
            //         TestField(Type, Type::Item);
            //         GetItemVariant();
            //         ErrorIfItemVariantIsBlocked();
            //     end;
            //     CheckActionMessageNew();
            //     ReqLineReserve.VerifyChange(Rec, xRec);

            //     CalcFields("Reserved Qty. (Base)");
            //     TestField("Reserved Qty. (Base)", 0);

            //     GetDirectCost(FieldNo("Variant Code"));
            //     if "Variant Code" <> '' then begin
            //         UpdateDescription();
            //         UpdateReplenishmentSystem();
            //         if "Variant Code" <> xRec."Variant Code" then begin
            //             "Bin Code" := '';
            //             if ("Location Code" <> '') and ("No." <> '') then begin
            //                 GetLocation("Location Code");
            //                 ShouldGetDefaultBin := Location."Bin Mandatory" and not Location."Directed Put-away and Pick";
            //                 OnBeforeGetDefaultBin(Rec, ShouldGetDefaultBin);
            //                 if ShouldGetDefaultBin then
            //                     WMSManagement.GetDefaultBin("No.", "Variant Code", "Location Code", "Bin Code");
            //             end;
            //         end;
            //         if ItemVend.Get("Vendor No.", "No.", "Variant Code") then
            //             "Vendor Item No." := ItemVend."Vendor Item No.";
            //     end else
            //         Validate("No.");
            // end;
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            // TableRelation = Bin.Code where("Location Code" = field("Location Code"),
            //                                 "Item Filter" = field("No."),
            //                                 "Variant Filter" = field("Variant Code"));

            // trigger OnValidate()
            // begin
            //     CheckActionMessageNew();
            //     if (CurrFieldNo = FieldNo("Bin Code")) and
            //        ("Action Message" <> "Action Message"::" ")
            //     then
            //         TestField("Action Message", "Action Message"::New);
            //     TestField(Type, Type::Item);
            //     TestField("Location Code");
            //     GetItem();
            //     Item.TestField(Type, Item.Type::Inventory);
            //     if ("Bin Code" <> xRec."Bin Code") and ("Bin Code" <> '') then begin
            //         GetLocation("Location Code");
            //         Location.TestField("Bin Mandatory");
            //         Location.TestField("Directed Put-away and Pick", false);
            //         GetBin("Location Code", "Bin Code");
            //         TestField("Location Code", Bin."Location Code");
            //     end;
            //     ReqLineReserve.VerifyChange(Rec, xRec);
            // end;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5405; "Qty. Rounding Precision"; Decimal)
        {
            Caption = 'Qty. Rounding Precision';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(5406; "Qty. Rounding Precision (Base)"; Decimal)
        {
            Caption = 'Qty. Rounding Precision (Base)';
            InitValue = 0;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 1;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            // TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            // else
            // "Unit of Measure";

            // trigger OnValidate()
            // begin
            //     CheckActionMessageNew();
            //     if (Type = Type::Item) and ("No." <> '') and (not IsProdOrder()) then
            //         AssignItemUnitCostAndQuantitiesForUOM()
            //     else
            //         if not IsProdOrder() then
            //             "Qty. per Unit of Measure" := 1
            //         else
            //             "Qty. per Unit of Measure" := 0;

            //     OnValidateUnitofMeasureCodeOnBeforeGetDirectCost(Rec, Item);
            //     GetDirectCost(FieldNo("Unit of Measure Code"));

            //     if "Planning Line Origin" = "Planning Line Origin"::"Order Planning" then
            //         SetSupplyQty("Demand Quantity (Base)", "Needed Quantity (Base)")
            //     else
            //         Validate(Quantity);
            // end;
        }
        field(5408; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            // trigger OnValidate()
            // var
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeValidateQuantityBase(Rec, IsHandled, xRec, CurrFieldNo, CurrentFieldNo);
            //     if IsHandled then
            //         exit;

            //     TestProdOrderNo();
            //     TestField("Qty. per Unit of Measure", 1);
            //     Validate(Quantity, "Quantity (Base)");
            // end;
        }
        field(5431; "Reserved Qty. (Base)"; Decimal)
        {
            // CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Source ID" = field("Worksheet Template Name"),
            //                                                                "Source Ref. No." = field("Line No."),
            //                                                                "Source Type" = const(246),
            //                                                                "Source Subtype" = const("0"),
            //                                                                "Source Batch Name" = field("Journal Batch Name"),
            //                                                                "Source Prod. Order Line" = const(0),
            //                                                                "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            // FieldClass = FlowField;
        }
        field(5520; "Demand Type"; Integer)
        {
            Caption = 'Demand Type';
            Editable = false;
            // TableRelation = System.Reflection.AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(5521; "Demand Subtype"; Option)
        {
            Caption = 'Demand Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9";
        }
        field(5522; "Demand Order No."; Code[20])
        {
            Caption = 'Demand Order No.';
            Editable = false;
        }
        field(5525; "Demand Line No."; Integer)
        {
            Caption = 'Demand Line No.';
            Editable = false;
        }
        field(5526; "Demand Ref. No."; Integer)
        {
            Caption = 'Demand Ref. No.';
            Editable = false;
        }
        field(5527; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(5530; "Demand Date"; Date)
        {
            Caption = 'Demand Date';
            Editable = false;
        }
        field(5532; "Demand Quantity"; Decimal)
        {
            Caption = 'Demand Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5533; "Demand Quantity (Base)"; Decimal)
        {
            Caption = 'Demand Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5538; "Needed Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5539; "Needed Quantity (Base)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5540; Reserve; Boolean)
        {
            Caption = 'Reserve';

            // trigger OnValidate()
            // begin
            //     GetItem();
            //     if Item.Reserve <> Item.Reserve::Optional then
            //         TestField(Reserve, Item.Reserve = Item.Reserve::Always);
            //     if Reserve and IsProdDemand() then
            //         Error(Text030);
            //     TestField("Planning Level", 0);
            //     TestField("Planning Line Origin", "Planning Line Origin"::"Order Planning");
            // end;
        }
        field(5541; "Qty. per UOM (Demand)"; Decimal)
        {
            Caption = 'Qty. per UOM (Demand)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5542; "Unit Of Measure Code (Demand)"; Code[10])
        {
            Caption = 'Unit Of Measure Code (Demand)';
            Editable = false;
            // TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5552; "Supply From"; Code[20])
        {
            Caption = 'Supply From';
            // TableRelation = if ("Replenishment System" = const(Purchase)) Vendor
            // else
            // if ("Replenishment System" = const(Transfer)) Location where("Use As In-Transit" = const(false));

            // trigger OnLookup()
            // var
            //     Vend: Record Vendor;
            // begin
            //     case "Replenishment System" of
            //         "Replenishment System"::Purchase:
            //             if LookupVendor(Vend, true) then
            //                 Validate("Supply From", Vend."No.");
            //         "Replenishment System"::Transfer:
            //             if LookupFromLocation(Location) then
            //                 Validate("Supply From", Location.Code);
            //         else
            //             OnLookupSupplyFromOnCaseReplenishmentSystemElse(Rec);
            //     end;
            // end;

            // trigger OnValidate()
            // begin
            //     case "Replenishment System" of
            //         "Replenishment System"::Purchase:
            //             Validate("Vendor No.", "Supply From");
            //         "Replenishment System"::Transfer:
            //             Validate("Transfer-from Code", "Supply From");
            //         else
            //             OnValidateSupplyFromOnCaseReplenishmentSystemElse(Rec);
            //     end;
            // end;
        }
        field(5553; "Original Item No."; Code[20])
        {
            Caption = 'Original Item No.';
            Editable = false;
            // TableRelation = Item;
        }
        field(5554; "Original Variant Code"; Code[10])
        {
            Caption = 'Original Variant Code';
            Editable = false;
            // TableRelation = "Item Variant".Code where("Item No." = field("Original Item No."));
        }
        field(5560; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;
        }
        field(5563; "Demand Qty. Available"; Decimal)
        {
            Caption = 'Demand Qty. Available';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5590; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            // TableRelation = User."User Name";
        }
        field(5701; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            // TableRelation = if (Type = const(Item)) "Item Category";
        }
        field(5702; Nonstock; Boolean)
        {
            Caption = 'Catalog';
        }
        field(5703; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            // TableRelation = Purchasing;
        }
        field(5706; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            // TableRelation = Location where("Use As In-Transit" = const(false));

            // trigger OnValidate()
            // begin
            //     CheckActionMessageNew();
            //     "Supply From" := "Transfer-from Code";
            // end;
        }
        field(5707; "Transfer Shipment Date"; Date)
        {
            AccessByPermission = TableData "Transfer Header" = R;
            Caption = 'Transfer Shipment Date';
            Editable = false;
        }
        field(7000; "Price Calculation Method"; Enum "Price Calculation Method")
        {
            Caption = 'Price Calculation Method';
        }
        field(7002; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(7100; "Blanket Purch. Order Exists"; Boolean)
        {
            // CalcFormula = exist("Purchase Line" where("Document Type" = const("Blanket Order"),
            //                                            Type = const(Item),
            //                                            "No." = field("No."),
            //                                            "Outstanding Quantity" = filter(<> 0)));
            Caption = 'Blanket Purch. Order Exists';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(7110; "Custom Sorting Order"; Code[50])
        {
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            // TableRelation = "Routing Header";

            // trigger OnValidate()
            // var
            //     RoutingHeader: Record "Routing Header";
            //     RoutingDate: Date;
            // begin
            //     CheckActionMessageNew();
            //     "Routing Version Code" := '';

            //     if "Routing No." = '' then
            //         exit;

            //     if CurrFieldNo = FieldNo("Starting Date") then
            //         RoutingDate := "Starting Date"
            //     else
            //         RoutingDate := "Ending Date";
            //     if RoutingDate = 0D then
            //         RoutingDate := "Order Date";

            //     Validate("Routing Version Code", VersionMgt.GetRtngVersion("Routing No.", RoutingDate, true));
            //     if "Routing Version Code" = '' then begin
            //         RoutingHeader.Get("Routing No.");
            //         if PlanningResiliency and (RoutingHeader.Status <> RoutingHeader.Status::Certified) then
            //             TempPlanningErrorLog.SetError(
            //               StrSubstNo(Text033, RoutingHeader.TableCaption(), RoutingHeader.FieldCaption("No."), RoutingHeader."No."),
            //               Database::"Routing Header", CopyStr(RoutingHeader.GetPosition(), 1, 250));
            //         RoutingHeader.TestField(Status, RoutingHeader.Status::Certified);
            //         "Routing Type" := RoutingHeader.Type;
            //     end;
            // end;
        }
        field(99000751; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            // TableRelation = "Prod. Order Routing Line"."Operation No." where(Status = const(Released),
            //                                                                   "Prod. Order No." = field("Prod. Order No."),
            //                                                                   "Routing No." = field("Routing No."));

            // trigger OnValidate()
            // var
            //     ProdOrderRtngLine: Record "Prod. Order Routing Line";
            // begin
            //     if "Operation No." = '' then
            //         exit;

            //     TestField(Type, Type::Item);
            //     TestField("Prod. Order No.");
            //     TestField("Routing No.");

            //     ProdOrderRtngLine.Get(
            //       ProdOrderRtngLine.Status::Released,
            //       "Prod. Order No.",
            //       "Routing Reference No.",
            //       "Routing No.", "Operation No.");

            //     ProdOrderRtngLine.TestField(
            //       Type,
            //       ProdOrderRtngLine.Type::"Work Center");

            //     "Due Date" := ProdOrderRtngLine."Ending Date";
            //     CheckDueDateToDemandDate();

            //     Validate("Work Center No.", ProdOrderRtngLine."No.");

            //     Validate("Direct Unit Cost", ProdOrderRtngLine."Direct Unit Cost");
            // end;
        }
        field(99000752; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            // TableRelation = "Work Center";

            // trigger OnValidate()
            // begin
            //     GetWorkCenter();
            //     Validate("Vendor No.", WorkCenter."Subcontractor No.");
            // end;
        }
        field(99000754; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            Editable = false;
            // TableRelation = "Prod. Order Line"."Line No." where(Status = const(Finished),
            //                                                      "Prod. Order No." = field("Prod. Order No."));
        }
        field(99000755; "MPS Order"; Boolean)
        {
            Caption = 'MPS Order';
        }
        field(99000756; "Planning Flexibility"; Enum "Reservation Planning Flexibility")
        {
            Caption = 'Planning Flexibility';

            // trigger OnValidate()
            // begin
            //     if "Planning Flexibility" <> xRec."Planning Flexibility" then
            //         ReqLineReserve.UpdatePlanningFlexibility(Rec);
            // end;
        }
        field(99000757; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
        }
        field(99000882; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            // TableRelation = "Gen. Product Posting Group";
        }
        field(99000883; "Gen. Business Posting Group"; Code[20])
        {
            Caption = 'Gen. Business Posting Group';
            // TableRelation = "Gen. Business Posting Group";
        }
        field(99000884; "Low-Level Code"; Integer)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(99000885; "Production BOM Version Code"; Code[20])
        {
            Caption = 'Production BOM Version Code';
            // TableRelation = "Production BOM Version"."Version Code" where("Production BOM No." = field("Production BOM No."));

            // trigger OnValidate()
            // var
            //     ProdBOMVersion: Record "Production BOM Version";
            // begin
            //     CheckActionMessageNew();
            //     if "Production BOM Version Code" = '' then
            //         exit;

            //     ProdBOMVersion.Get("Production BOM No.", "Production BOM Version Code");
            //     if PlanningResiliency and (ProdBOMVersion.Status <> ProdBOMVersion.Status::Certified) then
            //         TempPlanningErrorLog.SetError(
            //           StrSubstNo(
            //             Text034, ProdBOMVersion.TableCaption(),
            //             ProdBOMVersion.FieldCaption("Production BOM No."), ProdBOMVersion."Production BOM No.",
            //             ProdBOMVersion.FieldCaption("Version Code"), ProdBOMVersion."Version Code"),
            //           Database::"Production BOM Version", CopyStr(ProdBOMVersion.GetPosition(), 1, 250));
            //     ProdBOMVersion.TestField(Status, ProdBOMVersion.Status::Certified);
            //     OnAfterValidateProductionBOMVersionCode(Rec, xRec, ProdBOMVersion);
            // end;
        }
        field(99000886; "Routing Version Code"; Code[20])
        {
            Caption = 'Routing Version Code';
            // TableRelation = "Routing Version"."Version Code" where("Routing No." = field("Routing No."));

            // trigger OnValidate()
            // var
            //     RoutingVersion: Record "Routing Version";
            // begin
            //     CheckActionMessageNew();
            //     if "Routing Version Code" = '' then
            //         exit;

            //     RoutingVersion.Get("Routing No.", "Routing Version Code");
            //     if PlanningResiliency and (RoutingVersion.Status <> RoutingVersion.Status::Certified) then
            //         TempPlanningErrorLog.SetError(
            //           StrSubstNo(
            //             Text034, RoutingVersion.TableCaption(),
            //             RoutingVersion.FieldCaption("Routing No."), RoutingVersion."Routing No.",
            //             RoutingVersion.FieldCaption("Version Code"), RoutingVersion."Version Code"),
            //           Database::"Routing Version", CopyStr(RoutingVersion.GetPosition(), 1, 250));
            //     RoutingVersion.TestField(Status, RoutingVersion.Status::Certified);
            //     "Routing Type" := RoutingVersion.Type;
            // end;
        }
        field(99000887; "Routing Type"; Option)
        {
            Caption = 'Routing Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;
        }
        field(99000888; "Original Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Original Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000889; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(99000890; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(99000891; "Original Due Date"; Date)
        {
            Caption = 'Original Due Date';
            Editable = false;
        }
        field(99000892; "Scrap %"; Decimal)
        {
            AccessByPermission = TableData "Production Order" = R;
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 5;
        }
        field(99000894; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            // trigger OnValidate()
            // begin
            //     if Type = Type::Item then begin
            //         GetWorkCenter();
            //         if not Subcontracting then begin
            //             Validate("Production BOM No.");
            //             Validate("Routing No.");
            //         end;
            //         Validate("Starting Time");
            //     end;
            // end;
        }
        field(99000895; "Starting Time"; Time)
        {
            Caption = 'Starting Time';

            // trigger OnValidate()
            // var
            //     ShouldSetDueDate: Boolean;
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeValidateStartingTime(Rec, ShouldSetDueDate, IsHandled, CurrFieldNo, CurrentFieldNo, xRec);
            //     if IsHandled then
            //         exit;

            //     TestField(Type, Type::Item);
            //     if ReqLine.Get("Worksheet Template Name", "Journal Batch Name", "Line No.") then
            //         PlanningLineMgt.Recalculate(Rec, 0)
            //     else
            //         CalcEndingDate('');

            //     CheckEndingDate(ValidateFields());

            //     ShouldSetDueDate := true;
            //     OnValidateStartingTimeOnBeforeSetDueDate(Rec, ShouldSetDueDate, xRec, CurrentFieldNo, CurrFieldNo);
            //     if ShouldSetDueDate then
            //         SetDueDate();

            //     SetActionMessage();
            //     if "Starting Time" = 0T then begin
            //         ManufacturingSetup.Get();
            //         "Starting Time" := ManufacturingSetup."Normal Starting Time";
            //     end;
            //     UpdateDatetime();
            // end;
        }
        field(99000896; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            // trigger OnValidate()
            // begin
            //     CheckEndingDate(ValidateFields());

            //     if Type = Type::Item then begin
            //         Validate("Ending Time");
            //         GetWorkCenter();
            //         if not Subcontracting then begin
            //             Validate("Production BOM No.");
            //             Validate("Routing No.");
            //         end;
            //     end;
            // end;
        }
        field(99000897; "Ending Time"; Time)
        {
            Caption = 'Ending Time';

            // trigger OnValidate()
            // var
            //     ShouldSetDueDate: Boolean;
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeValidateEndingTime(Rec, ShouldSetDueDate, IsHandled, CurrFieldNo, CurrentFieldNo);
            //     if IsHandled then
            //         exit;

            //     TestField(Type, Type::Item);
            //     if ReqLine.Get("Worksheet Template Name", "Journal Batch Name", "Line No.") then
            //         PlanningLineMgt.RecalculateWithOptionalModify(Rec, 1, false)
            //     else
            //         CalcStartingDate('');

            //     ShouldSetDueDate := (CurrFieldNo in [FieldNo("Ending Date"), FieldNo("Ending Date-Time")]) and (CurrentFieldNo <> FieldNo("Due Date"));
            //     OnValidateEndingTimeOnBeforeSetDueDate(Rec, ShouldSetDueDate);
            //     if ShouldSetDueDate then
            //         SetDueDate();

            //     SetActionMessage();
            //     if "Ending Time" = 0T then begin
            //         ManufacturingSetup.Get();
            //         "Ending Time" := ManufacturingSetup."Normal Ending Time";
            //     end;
            //     UpdateDatetime();
            // end;
        }
        field(99000898; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            // TableRelation = "Production BOM Header"."No.";

            // trigger OnValidate()
            // var
            //     ProdBOMHeader: Record "Production BOM Header";
            //     BOMDate: Date;
            // begin
            //     TestField(Type, Type::Item);
            //     CheckActionMessageNew();
            //     "Production BOM Version Code" := '';
            //     if "Production BOM No." = '' then
            //         exit;

            //     if CurrFieldNo = FieldNo("Starting Date") then
            //         BOMDate := "Starting Date"
            //     else begin
            //         BOMDate := "Ending Date";
            //         if BOMDate = 0D then
            //             BOMDate := "Order Date";
            //     end;

            //     Validate("Production BOM Version Code", VersionMgt.GetBOMVersion("Production BOM No.", BOMDate, true));
            //     if "Production BOM Version Code" = '' then begin
            //         ProdBOMHeader.Get("Production BOM No.");
            //         if PlanningResiliency and (ProdBOMHeader.Status <> ProdBOMHeader.Status::Certified) then
            //             TempPlanningErrorLog.SetError(
            //               StrSubstNo(
            //                 Text033,
            //                 ProdBOMHeader.TableCaption(),
            //                 ProdBOMHeader.FieldCaption("No."), ProdBOMHeader."No."),
            //               Database::"Production BOM Header", CopyStr(ProdBOMHeader.GetPosition(), 1, 250));

            //         ProdBOMHeader.TestField(Status, ProdBOMHeader.Status::Certified);
            //     end;
            //     OnAfterValidateProductionBOMNo(Rec, xRec, ProdBOMHeader);
            // end;
        }
        field(99000899; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
        }
        field(99000900; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;
        }
        field(99000901; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;

            // trigger OnValidate()
            // var
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeValidateUnitCost(Rec, IsHandled);
            //     if IsHandled then
            //         exit;

            //     TestField(Type, Type::Item);
            //     TestField("No.");

            //     Item.Get("No.");
            //     if Item."Costing Method" = Item."Costing Method"::Standard then begin
            //         if CurrFieldNo = FieldNo("Unit Cost") then
            //             Error(
            //               Text006,
            //               FieldCaption("Unit Cost"), Item.FieldCaption("Costing Method"), Item."Costing Method");
            //         "Unit Cost" := Item."Unit Cost" * "Qty. per Unit of Measure";
            //     end;
            //     "Cost Amount" := Round("Unit Cost" * Quantity);
            // end;
        }
        field(99000902; "Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
            MinValue = 0;
        }
        field(99000903; "Replenishment System"; Enum "Replenishment System")
        {
            Caption = 'Replenishment System';

            // trigger OnValidate()
            // var
            //     StockkeepingUnit: Record "Stockkeeping Unit";
            // begin
            //     TestField(Type, Type::Item);
            //     CheckActionMessageNew();
            //     if ValidateFields() and
            //        ("Replenishment System" = xRec."Replenishment System") and
            //        ("No." = xRec."No.") and
            //        ("Location Code" = xRec."Location Code") and
            //        ("Variant Code" = xRec."Variant Code")
            //     then
            //         exit;

            //     TestField(Type, Type::Item);
            //     TestField("No.");
            //     GetItem();

            //     if Item.IsNonInventoriableType() then
            //         TestField("Replenishment System", "Replenishment System"::Purchase);

            //     StockkeepingUnit := Item.GetSKU("Location Code", "Variant Code");
            //     if Subcontracting then
            //         StockkeepingUnit."Replenishment System" := StockkeepingUnit."Replenishment System"::"Prod. Order";
            //     OnValidateReplenishmentSystemOnAfterSetStockkeepingUnit(Rec, StockkeepingUnit, Subcontracting);

            //     "Supply From" := '';

            //     case "Replenishment System" of
            //         "Replenishment System"::Purchase:
            //             SetReplenishmentSystemFromPurchase(StockkeepingUnit);
            //         "Replenishment System"::"Prod. Order":
            //             SetReplenishmentSystemFromProdOrder(StockkeepingUnit);
            //         "Replenishment System"::Transfer:
            //             SetReplenishmentSystemFromTransfer(StockkeepingUnit);
            //         else
            //             OnValidateReplenishmentSystemCaseElse(Rec);
            //     end;
            // end;
        }
        field(99000904; "Ref. Order No."; Code[20])
        {
            Caption = 'Ref. Order No.';
            Editable = false;
            // #pragma warning disable AL0603
            //             TableRelation = if ("Ref. Order Type" = const("Prod. Order")) "Production Order"."No." where(Status = field("Ref. Order Status"))
            // #pragma warning restore AL0603
            //             else
            //             if ("Ref. Order Type" = const(Purchase)) "Purchase Header"."No." where("Document Type" = const(Order))
            //             else
            //             if ("Ref. Order Type" = const(Transfer)) "Transfer Header"."No." where("No." = field("Ref. Order No."));
            //             ValidateTableRelation = false;

            // trigger OnLookup()
            // var
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnLookupRefOrderNoOnBeforeOpenPage(Rec, IsHandled);
            //     if not IsHandled then
            //         LookupRefOrderNo();
            // end;
        }
        field(99000905; "Ref. Order Type"; Enum "Requisition Ref. Order Type")
        {
            Caption = 'Ref. Order Type';
            Editable = false;
        }
        field(99000906; "Ref. Order Status"; Enum Microsoft.Manufacturing.Document."Production Order Status")
        {
            BlankZero = true;
            Caption = 'Ref. Order Status';
            Editable = false;
        }
        field(99000907; "Ref. Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ref. Line No.';
            Editable = false;
        }
        field(99000908; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            //TableRelation = "No. Series";
        }
        field(99000909; "Expected Operation Cost Amt."; Decimal)
        {
            // AutoFormatType = 1;
            // CalcFormula = sum("Planning Routing Line"."Expected Operation Cost Amt." where("Worksheet Template Name" = field("Worksheet Template Name"),
            //                                                                                 "Worksheet Batch Name" = field("Journal Batch Name"),
            //                                                                                 "Worksheet Line No." = field("Line No.")));
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(99000910; "Expected Component Cost Amt."; Decimal)
        {
            // AutoFormatType = 1;
            // CalcFormula = sum("Planning Component"."Cost Amount" where("Worksheet Template Name" = field("Worksheet Template Name"),
            //                                                             "Worksheet Batch Name" = field("Journal Batch Name"),
            //                                                             "Worksheet Line No." = field("Line No.")));
            Caption = 'Expected Component Cost Amt.';
            Editable = false;
            // FieldClass = FlowField;
        }
        field(99000911; "Finished Qty. (Base)"; Decimal)
        {
            Caption = 'Finished Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000912; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000913; "Related to Planning Line"; Integer)
        {
            Caption = 'Related to Planning Line';
            Editable = false;
        }
        field(99000914; "Planning Level"; Integer)
        {
            Caption = 'Planning Level';
            Editable = false;
        }
        field(99000915; "Planning Line Origin"; Enum "Planning Line Origin Type")
        {
            Caption = 'Planning Line Origin';
            Editable = false;
        }
        field(99000916; "Action Message"; Enum "Action Message Type")
        {
            Caption = 'Action Message';

            // trigger OnValidate()
            // var
            //     IsHandled: Boolean;
            // begin
            //     IsHandled := false;
            //     OnBeforeValidateActionMessage(Rec, xRec, IsHandled);
            //     if IsHandled then
            //         exit;

            //     if ("Action Message" = xRec."Action Message") or
            //        (("Action Message" in ["Action Message"::" ", "Action Message"::New]) and
            //         (xRec."Action Message" in ["Action Message"::" ", "Action Message"::New]))
            //     then
            //         exit;
            //     TestField("Action Message", xRec."Action Message");
            // end;
        }
        field(99000917; "Accept Action Message"; Boolean)
        {
            Caption = 'Accept Action Message';

            // trigger OnValidate()
            // begin
            //     if "Action Message" = "Action Message"::" " then
            //         Validate("Action Message", "Action Message"::New);
            // end;
        }
        field(99000918; "Net Quantity (Base)"; Decimal)
        {
            Caption = 'Net Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000919; "Starting Date-Time"; DateTime)
        {
            Caption = 'Starting Date-Time';

            // trigger OnValidate()
            // begin
            //     "Starting Date" := DT2Date("Starting Date-Time");
            //     "Starting Time" := DT2Time("Starting Date-Time");

            //     Validate("Starting Date");
            // end;
        }
        field(99000920; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';

            // trigger OnValidate()
            // begin
            //     "Ending Date" := DT2Date("Ending Date-Time");
            //     "Ending Time" := DT2Time("Ending Date-Time");

            //     Validate("Ending Date");
            // end;
        }
        field(99000921; "Order Promising ID"; Code[20])
        {
            Caption = 'Order Promising ID';
        }
        field(99000922; "Order Promising Line No."; Integer)
        {
            Caption = 'Order Promising Line No.';
        }
        field(99000923; "Order Promising Line ID"; Integer)
        {
            Caption = 'Order Promising Line ID';
        }
        field(50100; StatusReq; Enum "Status") //DCS:SK 19/05/2025 ExtMerged 
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(50101; "projectNo"; Code[30])
        {
            Caption = 'Project No.';
            // TableRelation = Job;
        }
        field(50102; "AlternateVendorNo."; Code[30])
        {
            Caption = 'Vendor No';
            // TableRelation = Vendor;
        }
        field(50103; "Crm Id"; Text[100])
        {
            Caption = 'Crm Id';
            DataClassification = ToBeClassified;
        }

        field(50104; "VendorName"; Text[100])
        {
            Caption = 'Vendor Name';
            // TableRelation = Vendor.Name;
            // ValidateTableRelation = false;

            // trigger OnValidate()
            // var
            //     Vendor: Record Vendor;
            //     Item: Record Item;
            // begin
            //     if Rec."VendorName" = '' then begin
            //         Rec."Vendor No." := '';
            //         exit;
            //     end;

            //     if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then begin
            //         if Item.Get(Rec."No.") then begin
            //             if Item.Type = Item.Type::Inventory then begin
            //                 Error('Cannot modify vendor for Inventory items.');
            //             end;
            //         end;
            //     end;

            //     Vendor.Reset();
            //     Vendor.SetCurrentKey(Name);
            //     Vendor.SetRange(Name, Rec."VendorName");

            //     if Vendor.FindFirst() then begin
            //         Rec."Vendor No." := Vendor."No.";
            //     end else
            //         Error('Vendor with name %1 not found.', Rec."VendorName");
            // end;
        }
        field(50105; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Vendor".Name WHERE("No." = FIELD("Vendor No.")));
            // ObsoleteState = Removed;
        }
        field(50106; "Requested By Name"; Code[30])
        {
            Caption = 'Requested By';
            //  TableRelation = Employee."No.";
            // trigger OnValidate()
            // var
            //     Employee: Record Employee;
            // begin
            //     if Rec."Requested By Name" <> '' then begin
            //         if Employee.Get(Rec."Requested By Name") then
            //             Rec."Requested By Name2" := Employee."First Name" + ' ' + Employee."Last Name"
            //         else
            //             Rec."Requested By Name2" := '';
            //     end else
            //         Rec."Requested By Name2" := '';
            // end;
        }
        field(50157; "Requested By Name2"; Text[100])
        {
            Caption = 'Requested By Name';
        }
        field(50107; "Project Task No"; Code[30])
        {
            Caption = 'Project Task No';
            DataClassification = ToBeClassified;
            // TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD(projectNo));

            // trigger OnValidate()
            // var
            //     JobTask: Record "Job Task";
            // begin
            //     if JobTask.Get(Rec.projectNo, Rec."Project Task No") then begin
            //         Rec."Shortcut Dimension 1 Code" := JobTask."Global Dimension 1 Code";
            //     end else begin
            //         Rec."Shortcut Dimension 1 Code" := '';
            //     end;
            // end;
        }
        field(50108; "Dimension Value"; Code[30])
        {
            // TableRelation = "Dimension Value";
            Caption = 'Dimension Value';
            DataClassification = ToBeClassified;
        }
        field(50109; "Work Order No"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Work Order No';
            // TableRelation = "Work Order";
            // trigger OnValidate()
            // var
            //     WorkOrder: Record "Work Order";
            // begin
            //     if xRec."Work Order No" <> Rec."Work Order No" then begin
            //         WorkOrder.Reset();
            //         if WorkOrder.Get(Rec."Work Order No") then begin
            //             Rec."Project Task No" := WorkOrder."Project Task No";
            //             Rec.projectNo := WorkOrder."Job No.";
            //             Rec."Shortcut Dimension 1 Code" := WorkOrder."Shortcut Dimension 1 Code";
            //         end;
            //     end;
            // end;
        }
        field(50110; "Stock Check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Stock Check';
        }
        field(50111; "Ship To"; enum "Customer Location")
        {
            Caption = 'Ship To';
            DataClassification = ToBeClassified;
            // OptionMembers = "Customer","Warehouse";
        }
        field(50112; "Alternate Vendor For Item"; Boolean)
        {
            Caption = 'Alternate Vendor For Item';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50113; "Item Availability By Location"; Decimal)
        {
            Caption = 'Item Availability By Location';

            // trigger OnValidate()
            // var
            //     Item: Record Item;
            // begin
            //     if rec."Location Code" = '' then
            //         Rec."Item Availability By Location" := 0;
            //     exit;
            // end;
        }
        field(50114; "Item Inventory"; Decimal)
        {
            Caption = 'Item Inventory';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
            // trigger OnValidate()
            // var
            //     Item: Record Item;
            // begin
            //     if Rec."No." <> '' then begin
            //         if Item.Get(Rec."No.") then begin
            //             Rec."Item Inventory" := Item.Inventory;
            //         end;
            //     end;
            // end;
        }
        field(50115; "PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PO Created';
        }
        //DCS::HK 01102025 ++
        field(50150; "Owner"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Owner';
            // TableRelation = Employee."No.";
        }
        // DCS::HP 071025 ++
        field(50154; "Owner CRM"; Text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Owner CRM';
            // trigger OnValidate()
            // var
            //     empRec: Record Employee;
            // begin
            //     empRec.SetRange("CRM ID", Rec."Owner CRM");
            //     if empRec.FindFirst() then
            //         Rec.Owner := empRec."No."
            // end;
        }
        field(50151; "Product"; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Item."No.";
        }
        field(50152; "Warehouse"; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Location.Code;
        }
        field(50153; "Defalut Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Unit of Measure".Code;
        }
        // DCS::HP 071025 ++
        field(50155; "Default Unit CRM"; text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Default Unit CRM';
            // trigger OnValidate()
            // var
            //     uomRec: Record "Unit of Measure";
            // begin
            //     uomRec.SetRange("CRM ID", Rec."Default Unit CRM");
            //     if uomRec.FindFirst() then
            //         Rec."Defalut Unit" := uomRec.code;
            // end;
        }
        field(50156; "Currency CRM"; text[200])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency CRM';
            // trigger OnValidate()
            // var
            //     locRec: Record Location;
            // begin
            //     locRec.SetRange("CRM ID", Rec."currency CRM");
            //     if locRec.FindFirst() then
            //         Rec."Currency Code" := locRec.code;
            // end;
        }
        field(50158; "Default PO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Default PO';
        }
    }
    keys
    {
        key(Key1; "Worksheet Template Name", "Journal Batch Name", "Line No.", "Entry No ")
        {
            Clustered = true;
        }
        key(Key2; "Worksheet Template Name", "Journal Batch Name", "Vendor No.", "Sell-to Customer No.", "Ship-to Code", "Order Address Code", "Currency Code", "Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Location Code", "Transfer-from Code", "Purchasing Code")
        {
            MaintainSQLIndex = false;
        }
        key(Key3; Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date", "Drop Shipment")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key4; Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Order Date")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key5; Type, "No.", "Variant Code", "Location Code", "Starting Date")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key6; "Worksheet Template Name", "Journal Batch Name", Type, "No.", "Due Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key7; "Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Ref. Line No.")
        {
        }
        key(Key8; "Replenishment System", Type, "No.", "Variant Code", "Transfer-from Code", "Transfer Shipment Date")
        {
            IncludedFields = "Quantity (Base)";
        }
        key(Key9; "Order Promising ID", "Order Promising Line ID", "Order Promising Line No.")
        {
        }
        key(Key10; "User ID", "Demand Type", "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
        }
        key(Key11; "User ID", "Demand Type", "Demand Subtype", "Demand Order No.", "Demand Line No.", "Demand Ref. No.")
        {
        }
        key(Key12; "User ID", "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key13; "Worksheet Template Name", "Journal Batch Name", "Custom Sorting Order")
        {
        }
        key(Key14; "Demand Order No.", "Demand Ref. No.", "Demand Subtype", "Demand Line No.", "Demand Type")
        {
            IncludedFields = "User ID";
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "No.", Description, Quantity, "Replenishment System", "Order Date")
        { }
    }


}
