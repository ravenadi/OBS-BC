page 50111 "API Sales Lines"
{
    PageType = API;
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'SalesLines';
    EntitySetName = 'SalesLines';
    SourceTable = "Sales Line";
    DelayedInsert = true;

    //ODataKeyFields = "Document No.", "Document Type";

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
                field(SystemId; Rec.SystemId) { }
                field("LineNo"; Rec."Line No.") { }
                field("ItemNo"; Rec."No.") { }
                field("ItemDescription"; Rec."Description") { }
                field("DocumentType"; Rec."Document Type") { }
                field(Type; Rec.Type) { }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field("UnitofMeasure"; Rec."Unit of Measure")
                {
                    Caption = 'Unit Of Measure';
                }
                field(product; Rec.Product)
                {
                    Caption = 'Product';
                }
                field(Amount; Rec."Unit Price")
                {
                    Caption = 'Amount';
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