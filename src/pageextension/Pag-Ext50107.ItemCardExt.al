pageextension 50107 "Item Card Ext" extends "Item Card"
{
    layout
    {
        modify(Description)
        {
            Caption = 'OBS Product Name';
        }
        modify("Manufacturer Code")
        {
            Caption = 'Manufacturer Name';

        }
        modify("Unit Cost")
        {
            ShowMandatory = true;
        }
        modify("Unit Price")
        {

            ShowMandatory = true;
        }
        //GKBLABS_TV_19/12/25
        addafter("Unit Price")
        {
            field("Foreign Currency Unit Price"; Rec."Foreign Currency Unit Price")
            {
                ApplicationArea = All;
                Caption = 'Foreign Currency Unit Price';
                ToolTip = 'Specifies the unit price in foreign currency';
            }
        }
        //GKBLABS_TV_19/12/25 END
        addafter("Manufacturer Code")
        {
            field("Manufacturer Part Name"; Rec."Manufacturer Part Name")
            {
                ApplicationArea = All;
                Caption = 'Manufacturer Part Name';
            }
            field("Manufacturer Part No."; Rec."Manufacturer Part No.")
            {
                ApplicationArea = All;
                Caption = 'Manufacturer Part No.';

            }
        }
        addlast(InventoryGrp)
        {
            field("Item Availability By Location"; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'Item Availability By Location';
                DrillDown = true;
                Editable = false;
                trigger OnDrillDown()
                var
                    ItemAvailabilityPage: Page "Item Availability by Location";
                    ItemFilter: Record Item;
                begin
                    ItemFilter.SetRange("No.", Rec."No.");
                    ItemAvailabilityPage.SetTableView(ItemFilter);
                    ItemAvailabilityPage.Run();
                end;
            }
        }
        addafter(Description)
        {
            // GkbLabs_Tv_24/01/26++
            field("D365 Item Description"; Rec."D365 Item Description")
            {
                ApplicationArea = All;
                MultiLine = true;
                Editable = true;

                trigger OnValidate()
                var
                    OutStr: OutStream;
                begin
                    // Sync to Blob for long text when the table field is validated
                    if Rec."D365 Item Description" <> '' then begin
                        Rec."D365 Item Description Blob".CreateOutStream(OutStr);
                        OutStr.WriteText(Rec."D365 Item Description");
                        // Do not call Rec.Modify here - the page framework will persist the record
                    end;
                end;
            }
            field("Product Type"; Rec."Product Type")
            {
                ApplicationArea = All;
            }
        }
        addafter(Item)
        {

            group("D365 Custom Fields")
            {
                field("D365 Product ID"; Rec."D365 Product ID")          //Custom
                {
                    ApplicationArea = all;
                    Caption = 'D365 Product Id';
                }
                field("Vendor 1 Catalogue Number"; Rec."Vendor 1 Catalogue Number")          //custom
                {
                    ApplicationArea = all;
                }
                field("Vendor Id"; Rec."Vendor Id")                   //custom
                {
                    Caption = 'Vendor Id';
                    ApplicationArea = all;
                }
                field(Tradetype; Rec."Trade Type")                         //custom
                {
                    ApplicationArea = all;
                    Caption = 'Trade Type';
                    // DCS::HP 11082025 ++
                    Visible = false;
                    // DCS::HP 11082025 --
                }
                field(SAPITEMID; Rec.SAPITEMID)                  //custom
                {
                    ApplicationArea = all;
                    Caption = 'Item Number';
                }
                field(OBSItemName; Rec."OBS Item Name")                    //custom
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = all;
                    Caption = 'Currency';
                }
                //Gkblabs_Tv_15/12/25 ++
                field("Foreign Currency unit cost"; Rec."Foreign Currency unit cost")
                {
                    ApplicationArea = all;
                    Caption = 'Foreign Currency unit cost';
                    ToolTip = 'Specifies the unit cost in foreign currency';
                }
                field(Row; Rec.Row)
                {
                    ApplicationArea = all;
                    Caption = 'Row';
                }
                // DCS::HP 05082025 ++
                field("Currency Id"; Rec."Currency Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Id field.', Comment = '%';

                }
                field("CRM ID"; Rec."CRM ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CRM ID field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                // DCS::HP 290925 ++
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
                }
                // DCS::HP 290925 --
                // DCS::HP 05082025 --
            }
        }
        addafter("Vendor Item No.")
        {

            field("Vendor Item Name"; Rec."Vendor Item Name")
            {
                Caption = 'Vendor Name';
                ApplicationArea = All;
            }
        }
        modify("Vendor Item No.")
        {
            ToolTip = 'SAP Vendor Item No.';
        }
        addfirst(factboxes)
        {
            part(QRFactbox; "Item QR Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
        }
        addlast("D365 Custom Fields")
        {
            field("OBS Item Name"; Rec."OBS Item Name")
            {
                ApplicationArea = All;
                ToolTip = 'OBS Item Name';
                ShowMandatory = true;
            }
        }
        addafter("Last Date Modified")
        {

            field("Not Sync Item"; Rec."Not Sync Item")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Not Sync Item field.', Comment = '%';
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            action(UpadateCRM)
            {
                Caption = 'Update To CRM';
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update this to CRM';

                trigger OnAction()
                var
                    ItemUpadateToCrm: Codeunit "Update to Crm Mngmt";
                    OutStr: OutStream;
                begin
                    // Ensure the latest table text is persisted to Blob before sending to CRM
                    if Rec."D365 Item Description" <> '' then begin
                        Rec."D365 Item Description Blob".CreateOutStream(OutStr);
                        OutStr.WriteText(Rec."D365 Item Description");
                        Rec.Modify(true);
                    end;
                    ItemUpadateToCrm.UpadateItemToCRM(Rec);
                    Message('Record Updated to CRM Successfully');
                end;
            }
        }

        addafter(ApplyTemplate)
        {
            action(CustomerCardBarCode)
            {
                Caption = 'Item QR Code';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Image = Report;

                trigger OnAction()
                var
                    RepItemQRCode: Report Item_QRCode;
                    Item: Record Item;
                begin
                    RepItemQRCode.AssignItemData(Rec."No.", Rec.Description);
                    Item.Reset();
                    Item.SetRange("No.", Rec."No.");
                    if Item.FindFirst() then
                        Report.RunModal(Report::"Item QR New", true, false, Item);
                end;
            }
            // DCS::HP 12082025 ++
            action(UpdateSalesPriceLists)
            {
                ApplicationArea = All;
                Caption = 'Update Price List Prices';
                PromotedCategory = Process;
                Promoted = true;
                Image = UpdateUnitCost;

                trigger OnAction()
                var
                    PriceListHeader: Record "Price List Header";
                    PriceListLine: Record "Price List Line";
                    LastPriceListLine: Record "Price List Line";
                    NewPriceListLine: Record "Price List Line";
                    ItemRec: Record Item;
                    GetUnitPrice: Codeunit "Create Order helper";
                    BasePrice: Decimal;
                    PlatinumPrice: Decimal;
                    GoldPrice: Decimal;
                    SilverPrice: Decimal;
                    BronzePrice: Decimal;
                    LineNo: Integer;
                begin
                    if not ItemRec.Get(Rec."No.") then
                        Error('Item not found.');

                    BasePrice := ItemRec."Unit Price";
                    PlatinumPrice := BasePrice;
                    GoldPrice := Round(PlatinumPrice * 1.05, 0.01);
                    SilverPrice := Round(GoldPrice * 1.05, 0.01);
                    BronzePrice := Round(SilverPrice * 1.05, 0.01);

                    PriceListHeader.Reset();
                    if PriceListHeader.FindSet() then begin
                        repeat
                            PriceListLine.Reset();
                            PriceListLine.SetRange("Price List Code", PriceListHeader.Code);
                            PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
                            PriceListLine.SetRange("Product No.", Rec."No.");
                            if not PriceListLine.FindFirst() then begin
                                Clear(LineNo);
                                LastPriceListLine.Reset();
                                LastPriceListLine.SetRange("Price List Code", PriceListHeader.Code);
                                if LastPriceListLine.FindLast() then
                                    LineNo := LastPriceListLine."Line No." + 10000
                                else
                                    LineNo := 10000;
                                NewPriceListLine.Init();
                                NewPriceListLine.Validate("Price List Code", PriceListHeader.Code);
                                NewPriceListLine.Validate("Line No.", LineNo);
                                NewPriceListLine.Insert(true);
                                NewPriceListLine.Validate("Asset Type", NewPriceListLine."Asset Type"::Item);
                                NewPriceListLine.Validate("Product No.", Rec."No.");
                                NewPriceListLine.Validate("Unit Price", GetUnitPrice.GetPercentageValue(PriceListHeader, Rec));
                                NewPriceListLine.Modify(true);
                            end;
                            // Update pricing logic for Platinum, Gold, Silver, Bronze
                            if PriceListLine.FindFirst() then begin
                                case UpperCase(PriceListHeader.Code) of
                                    'PLATINUM', 'PROJECT':
                                        PriceListLine."Unit Price" := PlatinumPrice;
                                    'GOLD':
                                        PriceListLine."Unit Price" := GoldPrice;
                                    'SILVER':
                                        PriceListLine."Unit Price" := SilverPrice;
                                    'BRONZE':
                                        PriceListLine."Unit Price" := BronzePrice;
                                    else
                                        PriceListLine."Unit Price" := PriceListLine."Unit Price";
                                end;
                                PriceListLine.Modify(true);
                            end;
                        until PriceListHeader.Next() = 0;
                        Message('Price List Lines created/updated for item %1.', Rec."No.");
                    end;
                end;
            }
            // DCS::HP 12082025 --

        }

        // Jathin's code starts here
        addafter(ApplyTemplate)
        {
            // DCS::HP 12082025 ++
            // action("Update Sales Price")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Update Sales Price', comment = 'NLB="YourLanguageCaption"';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     Image = UpdateXML;

            //     trigger OnAction()
            //     var
            //         PriceListHeader_lRec: Record "Price List Header";
            //         PriceListLine_lRec: Record "Price List Line";
            //         PriceListLine_lRec1: Record "Price List Line";
            //         PriceListLine_lRec2: Record "Price List Line";
            //         GetUnitPrice: Codeunit "Create Order helper";
            //         LineNo: Integer;
            //     begin
            //         PriceListHeader_lRec.Reset();
            //         if PriceListHeader_lRec.FindSet() then begin
            //             repeat
            //                 PriceListLine_lRec.Reset();
            //                 PriceListLine_lRec.SetRange("Price List Code", PriceListHeader_lRec.Code);
            //                 PriceListLine_lRec.SetRange("Asset Type", PriceListLine_lRec."Asset Type"::Item);
            //                 PriceListLine_lRec.SetRange("Product No.", Rec."No.");
            //                 if not PriceListLine_lRec.FindFirst() then begin
            //                     Clear(LineNo);
            //                     PriceListLine_lRec1.Reset();
            //                     PriceListLine_lRec1.SetRange("Price List Code", PriceListHeader_lRec.Code);
            //                     if PriceListLine_lRec1.FindLast() then
            //                         LineNo := PriceListLine_lRec1."Line No." + 10000
            //                     else
            //                         LineNo := 10000;
            //                     PriceListLine_lRec2.Reset();
            //                     PriceListLine_lRec2.Init();
            //                     PriceListLine_lRec2.Validate("Price List Code", PriceListHeader_lRec.Code);
            //                     PriceListLine_lRec2.Validate("Line No.", LineNo);
            //                     PriceListLine_lRec2.Insert(true);
            //                     PriceListLine_lRec2.Validate("Asset Type", PriceListLine_lRec2."Asset Type"::Item);
            //                     PriceListLine_lRec2.Validate("Product No.", Rec."No.");
            //                     PriceListLine_lRec2.Validate("Unit Price", GetUnitPrice.GetPercentageValue(PriceListHeader_lRec, Rec));
            //                     PriceListLine_lRec2.Modify(true);
            //                 end;
            //             until PriceListHeader_lRec.Next() = 0;
            //             Message('Price List Updated Successfully');
            //         end;
            //     end;
            // }
            // DCS::HP 12082025 --
        }
        // Jathin's code ends here
    }



    trigger OnOpenPage()
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        URL: Text;
        InS: InStream;
        OutS: OutStream;
    begin
        if Rec."No." = '' then
            exit;
        if not Rec.QRCode.HasValue then begin
            //URL := 'http://api.qrserver.com/v1/create-qr-code/?data=' + Rec."No." + ' ' + Rec.Description + '&size=200x200';

            URL := 'http://api.qrserver.com/v1/create-qr-code/?data=' + Rec."No." + '&size=200x200';
            if Client.Get(URL, Response) then begin
                if Response.IsSuccessStatusCode() then begin
                    Response.Content.ReadAs(InS);
                    Rec.QRCode.CreateOutStream(OutS);
                    CopyStream(OutS, InS);
                    Rec.Modify();
                end;
            end;
        end;
    end;

    //GkbLabs_Tv_24/01/26++
    trigger OnAfterGetRecord()
    var
        InStr: InStream;
        TempText: Text;
    begin
        // Only populate the table text with Blob content if the text field is empty.
        if (Rec."D365 Item Description" = '') and Rec."D365 Item Description Blob".HasValue then begin
            Rec."D365 Item Description Blob".CreateInStream(InStr);
            InStr.ReadText(TempText);
            Rec."D365 Item Description" := TempText;
            // Do NOT call Rec.Modify here; this keeps the page buffer intact and prevents overwrites
        end;
    end;
    //GkbLabs_Tv_24/01/26--

    // DCS::HP 14082025 ++
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // DCS::HP04122025++
        rec.TestField("Unit Price");
        // DCS::HP04122025--
        // rec.TestField("Unit Cost");
    end;
    // DCS::HP 14082025 --
}

