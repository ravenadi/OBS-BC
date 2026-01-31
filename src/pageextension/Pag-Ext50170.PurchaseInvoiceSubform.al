pageextension 50170 "Purchase Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Ordered By"; Rec."Ordered By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the person who ordered the item.';
                Editable = true;
            }
            field("Name Ordered By"; Rec."Name Ordered By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the full name of the person who ordered the item.';
            }

            field("Car Registration No."; Rec."Car Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Car Registration No. field.', Comment = '%';
            }
        }
        modify("No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            var
                ItemRec: Record Item;
                ItemList: Page "Item List";
                ItemVendor: Record "Item Vendor";
                PurchaseHeader: Record "Purchase Header";
                ItemFilter: Text;
                MaxLength: Integer;
            begin
                case Rec.Type of
                    Rec.Type::Item:
                        begin
                            PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                            ItemRec.SetRange(Blocked, false);
                            if PurchaseHeader."Buy-from Vendor No." <> '' then begin
                                ItemVendor.SetRange("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                                MaxLength := 250;
                                if ItemVendor.FindSet() then begin
                                    repeat
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
                end;
                exit(false);
            end;
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No.";
            Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
        }
    }

    // DCS::HP 10092025 ++
    // trigger OnNewRecord(Belowx: Boolean)
    // var
    //     userRec:
    //         Record "User Setup";
    // begin
    //     IF userRec.GET(userID) THEN begin
    //         Rec."Ordered By" := userRec."User ID";
    //         // rec.Modify(true);
    //     end;
    // end;
    // DCS::HP 10092025 --    
}