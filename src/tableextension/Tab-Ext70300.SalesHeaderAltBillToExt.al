tableextension 70300 "Sales Header Alt BillTo Ext" extends "Sales Header"
{
    fields
    {
        // The Ship-to Code the user selects as the Bill-to address source
        field(70300; "Alt. Bill-to Ship-to Code"; Code[10])
        {
            Caption = 'Bill-to Ship-to Code';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            begin
                if Rec."Alt. Bill-to Ship-to Code" = '' then begin
                    ResetBillToFromCustomer();
                    exit;
                end;
                ApplyShipToAsBillTo(Rec."Alt. Bill-to Ship-to Code");
            end;
        }
    }

    // Copy all address fields from the selected Ship-to Address → Bill-to fields
    procedure ApplyShipToAsBillTo(ShipToCode: Code[10])
    var
        ShipToAddr: Record "Ship-to Address";
    begin
        if not ShipToAddr.Get(Rec."Sell-to Customer No.", ShipToCode) then
            exit;

        Rec."Bill-to Name" := ShipToAddr.Name;
        Rec."Bill-to Name 2" := ShipToAddr."Name 2";
        Rec."Bill-to Address" := ShipToAddr.Address;
        Rec."Bill-to Address 2" := ShipToAddr."Address 2";
        Rec."Bill-to Post Code" := ShipToAddr."Post Code";
        Rec."Bill-to City" := ShipToAddr.City;
        Rec."Bill-to County" := ShipToAddr.County;
        Rec."Bill-to Country/Region Code" := ShipToAddr."Country/Region Code";
        Rec."Bill-to Contact" := ShipToAddr.Contact;
    end;

    // Reset Bill-to address back to the Bill-to Customer defaults
    procedure ResetBillToFromCustomer()
    var
        Cust: Record Customer;
    begin
        if not Cust.Get(Rec."Bill-to Customer No.") then
            exit;

        Rec."Bill-to Name" := Cust.Name;
        Rec."Bill-to Name 2" := Cust."Name 2";
        Rec."Bill-to Address" := Cust.Address;
        Rec."Bill-to Address 2" := Cust."Address 2";
        Rec."Bill-to Post Code" := Cust."Post Code";
        Rec."Bill-to City" := Cust.City;
        Rec."Bill-to County" := Cust.County;
        Rec."Bill-to Country/Region Code" := Cust."Country/Region Code";
        Rec."Bill-to Contact" := Cust.Contact;
    end;
}