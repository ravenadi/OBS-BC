pageextension 50106 "Item List Ext" extends "Item List"
{
    layout
    {
        modify("Item Category Code")
        {
            ApplicationArea = all;
            ShowMandatory = true;
        }
        addafter("Vendor No.")
        {
            field(VendorName; Rec.VendorName)
            {
                Caption = 'Vendor Name';
                ApplicationArea = All;
            }
            field("CRM ID"; Rec."CRM ID")
            {
                ApplicationArea = all;
            }
        }
        // DCS::HP-20250723++
        addafter("Base Unit of Measure")
        {
            field("Customer Product Name"; rec."OBS Item Name")
            {
                Caption = 'Customer Product Name';
                ApplicationArea = all;
            }
        }
        modify(Description)
        {
            Caption = 'OBS Product Name';
        }
        // DCS::HP-20250723--

        //DCS::HJ 20250611 ++
        addafter("Last Date Modified")
        {

            field("Not Sync Item"; Rec."Not Sync Item")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Not Sync Item field.', Comment = '%';
            }
        }
        //DCS::HJ 20250611 --
    }
    // DCS ::HJ20250611 ++
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
                    ItemUpdateToCrm: Codeunit "Update to Crm Mngmt";
                    ItemRec: Record Item;
                begin
                    ItemRec.Reset();
                    ItemRec.SetFilter("Not Sync Item", '%1', true);
                    if ItemRec.FindSet() then begin
                        repeat
                            ItemUpdateToCrm.UpadateItemToCRM(ItemRec);
                        until ItemRec.Next() = 0;
                        Message('Record Updated to CRM Successfully');
                    end else
                        Message('No items found with Not Sync = true.');
                    ItemRec.Reset();
                    ItemRec.SetFilter("Not Sync Item", '%1', true);
                    if ItemRec.FindSet() then begin
                        repeat
                            ItemRec."Not Sync Item" := false;
                            itemRec.Modify(true);
                        until ItemRec.Next() = 0;
                    end;
                end;

            }
        }

    }
    // DCS ::HJ20250611 --
}