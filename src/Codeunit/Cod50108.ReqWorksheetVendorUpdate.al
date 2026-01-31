codeunit 50108 "Req. Worksheet Vendor Update"
{
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", OnAfterInsertEvent, '', false, false)]
    local procedure UpdateVendorNoOnReqLineInsert(var Rec: Record "Requisition Line")
    begin
        UpdateVendorDetails(Rec);
        Rec.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure UpdateVendorDetailsOnItemChange(var Rec: Record "Requisition Line")
    var
        ItemVendor: Record "Item Vendor";
        VendorCount: Integer;
    begin
        // DCS::HP13112025 ++ 
        if Rec.Type = Rec.Type::Item then begin
            ItemVendor.Reset();
            ItemVendor.SetRange("Item No.", Rec."No.");
            VendorCount := ItemVendor.Count;

            if VendorCount > 1 then begin
                Rec."Alternate Vendor For Item" := true;
            end;
        end;
        // DCS::HP13112025 --
        UpdateVendorDetails(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterValidateEvent', "Vendor No.", false, false)]
    local procedure UpdateVendorDetailsOnItemChange1(var Rec: Record "Requisition Line"; xRec: Record "Requisition Line")
    var
        Vendor: Record Vendor;
    begin
        if (Rec."Vendor No." <> '') or (Rec."Vendor No." <> xRec."Vendor No.") then begin
            if Vendor.Get(Rec."Vendor No.") then
                Rec."VendorName" := Vendor.Name
            else
                Rec."VendorName" := '';
        end else
            Rec."VendorName" := '';
    end;


    local procedure UpdateVendorDetails(var Rec: Record "Requisition Line")
    var
        Item: Record Item;
    begin
        if Rec.Type = Rec.Type::Item then begin
            if Item.Get(Rec."No.") then begin
                if Item.Type = Item.Type::Inventory then begin
                    Rec."Vendor No." := Item."Vendor No.";
                    GetAndUpdateVendorName(Rec);
                end else begin
                    Rec."Vendor No." := '';
                    Rec."VendorName" := '';
                end;
            end;
        end;
    end;

    local procedure GetAndUpdateVendorName(var Rec: Record "Requisition Line")
    var
        Vendor: Record Vendor;
    begin
        if Rec."Vendor No." <> '' then begin
            if Vendor.Get(Rec."Vendor No.") then
                Rec."VendorName" := Vendor.Name
            else
                Rec."VendorName" := '';
        end else
            Rec."VendorName" := '';
    end;
}
