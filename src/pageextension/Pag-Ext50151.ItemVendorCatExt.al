
pageextension 50151 "Item Vendor Cat Ext" extends "Item Vendor Catalog"
{
    layout
    {
        addafter("Vendor Item No.")
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                Caption = 'Vendor Name';
                ApplicationArea = All;
            }
            field("current cost"; Rec."current cost")
            {
                Caption = 'Unit Cost';
                ApplicationArea = All;
            }
        }
    }
    var
        PriceListLine: Record "Price List Line";

    trigger OnAfterGetRecord()
    begin
        UpdateUnitCost();
    end;

    procedure UpdateUnitCost()
    begin
        if (Rec."Vendor No." <> '') and (Rec."Item No." <> '') then begin
            PriceListLine.Reset();
            PriceListLine.SetRange("Source No.", Rec."Vendor No.");
            PriceListLine.SetRange("Product No.", Rec."Item No.");

            if PriceListLine.FindFirst() then
                Rec.Validate("Current Cost", PriceListLine."Direct Unit Cost")
            else
                Rec.Validate("Current Cost", 0);
        end;
    end;
}