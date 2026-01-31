page 50115 "API Blanket Lines"
{
    PageType = API;
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'BlanketOrderLine';
    EntitySetName = 'BlanketOrderLines';
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter("Blanket Order"));
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("CRMID"; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field("DocumentNo"; Rec."Document No.") { }
                field(Type; Rec.Type) { }
                field("LineNo"; Rec."Line No.") { }
                field("ItemNo"; Rec."No.") { }
                field("ItemDescription"; Rec."Description") { }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field("UnitPrice"; Rec."Unit Price") { }
                field("UnitofMeasure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit Of Measure';
                }
                field(product; Rec.Product)
                {
                    Caption = 'Product';
                }
                field("ShipmentDate"; Rec."Shipment Date") { }
                field("Dimension"; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Dimension';
                }
            }
        }
    }
}
