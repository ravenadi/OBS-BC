pageextension 50122 "Purch Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the name of the person who ordered the item.';
                Editable = true;
            }
            // DCS::HP13112025++
            field("Vendor Item No."; Rec."Vendor Item No.")
            {
                ApplicationArea = all;
            }
            // DCS::HP13112025++

        }

        addafter("Ordered By")
        {
            field("Name Ordered By"; Rec."Name Ordered By")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the full name of the person who ordered the item.';
            }
            field("Car Registration No."; Rec."Car Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Car Registration No. field.', Comment = '%';
            }

        }

        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
        }

        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                FixedAssetRec: Record "Fixed Asset";
                GLAccountRec: Record "G/L Account";
                ResourceRec: Record Resource;
                ItemChargeRec: Record "Item Charge";
                AllocationAccountRec: Record "Allocation Account";
                FixedAssetListPage: Page "Fixed Asset List";
                GLAccountListPage: Page "G/L Account List";
                ResourceListPage: Page "Resource List";
                ItemChargeListPage: Page "Item Charges";
                AllocationAccountListPage: Page "Allocation Account List";
                ItemRec: Record Item;
                ItemList: Page "Item List";
                ItemVendor: Record "Item Vendor";
                ItemFilter: Text;
                MaxLength: Integer;
            begin
                case Rec.Type of
                    Rec.Type::"Fixed Asset":
                        begin
                            FixedAssetRec.Reset();
                            FixedAssetRec.SetRange(Blocked, false);

                            FixedAssetListPage.SetTableView(FixedAssetRec);
                            FixedAssetListPage.LookupMode(true);

                            if FixedAssetListPage.RunModal = Action::LookupOK then begin
                                FixedAssetListPage.GetRecord(FixedAssetRec);
                                Text := FixedAssetRec."No.";
                                Rec.Validate("No.", FixedAssetRec."No.");
                                exit(true);
                            end;
                        end;

                    Rec.Type::"G/L Account":
                        begin
                            GLAccountRec.Reset();
                            GLAccountRec.SetRange(Blocked, false);

                            GLAccountListPage.SetTableView(GLAccountRec);
                            GLAccountListPage.LookupMode(true);

                            if GLAccountListPage.RunModal = Action::LookupOK then begin
                                GLAccountListPage.GetRecord(GLAccountRec);
                                Text := GLAccountRec."No.";
                                Rec.Validate("No.", GLAccountRec."No.");
                                exit(true);
                            end;
                        end;

                    Rec.Type::Resource:
                        begin
                            ResourceRec.Reset();
                            ResourceRec.SetRange(Blocked, false);

                            ResourceListPage.SetTableView(ResourceRec);
                            ResourceListPage.LookupMode(true);

                            if ResourceListPage.RunModal = Action::LookupOK then begin
                                ResourceListPage.GetRecord(ResourceRec);
                                Text := ResourceRec."No.";
                                Rec.Validate("No.", ResourceRec."No.");
                                exit(true);
                            end;
                        end;

                    Rec.Type::"Charge (Item)":
                        begin
                            ItemChargeRec.Reset();

                            ItemChargeListPage.SetTableView(ItemChargeRec);
                            ItemChargeListPage.LookupMode(true);

                            if ItemChargeListPage.RunModal = Action::LookupOK then begin
                                ItemChargeListPage.GetRecord(ItemChargeRec);
                                Text := ItemChargeRec."No.";
                                Rec.Validate("No.", ItemChargeRec."No.");
                                exit(true);
                            end;
                        end;
                    Rec.Type::Item:
                        begin
                            // ItemRec.Reset();
                            // ItemRec.SetRange(Blocked, false);
                            // if PurchaseHeader."Buy-from Vendor No." <> '' then begin
                            //     ItemRec.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                            // end;
                            PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                            ItemRec.SetRange(Blocked, false);

                            if PurchaseHeader."Buy-from Vendor No." <> '' then begin
                                ItemVendor.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                                MaxLength := 250;
                                if ItemVendor.FindSet() then begin
                                    // ItemRec.SetRange("No."); // Clear previous filters
                                    repeat
                                        // ItemRec.SetRange("No.", ItemVendor."Item No.");
                                        if StrLen(ItemFilter) + StrLen(ItemVendor."Item No.") + 1 <= MaxLength then begin
                                            if ItemFilter = '' then
                                                ItemFilter := Format(ItemVendor."Item No.")
                                            else
                                                ItemFilter := ItemFilter + '|' + Format(ItemVendor."Item No.");
                                        end;
                                    until ItemVendor.Next() = 0;

                                    if ItemFilter <> '' then
                                        ItemRec.SetFilter("No.", ItemFilter);
                                end;
                            end;
                            ItemList.SetTableView(ItemRec);
                            ItemList.LookupMode(true);

                            if ItemList.RunModal = Action::LookupOK then begin
                                ItemList.GetRecord(ItemRec);
                                Text := ItemRec."No.";
                                Rec.Validate("No.", ItemRec."No.");
                                exit(true);
                            end;
                        end;
                    Rec.Type::"Allocation Account":
                        begin
                            AllocationAccountRec.Reset();

                            AllocationAccountListPage.SetTableView(AllocationAccountRec);
                            AllocationAccountListPage.LookupMode(true);

                            if AllocationAccountListPage.RunModal = Action::LookupOK then begin
                                AllocationAccountListPage.GetRecord(AllocationAccountRec);
                                Text := AllocationAccountRec."No.";
                                Rec.Validate("No.", AllocationAccountRec."No.");
                                exit(true);
                            end;
                        end;

                end;

                exit(false);
            end;


        }

        modify("Job Task No.")
        {
            Visible = false;
        }

        addlast(Control1)
        {
            field(VendorCatalogueNo; Rec.VendorCatalogueNo)
            {
                Caption = 'Vendor Catologue No';
                ApplicationArea = all;
            }
        }
    }
    var
        PurchaseHeader: Record "Purchase Header";

}
