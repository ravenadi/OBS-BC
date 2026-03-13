namespace GKBCustomizationOCT.GKBCustomizationOCT;

page 50157 "URL Setup"
{
    ApplicationArea = All;
    Caption = 'URL Setup';
    PageType = Card;
    SourceTable = "URL Setup";
    UsageCategory = Administration;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Vendor URL"; Rec."Vendor URL")
                {
                    ToolTip = 'Specifies the value of the Vendor URL field.', Comment = '%';
                }
                field("Customer URL"; Rec."Customer URL")
                {
                    ToolTip = 'Specifies the value of the Customer URL field.', Comment = '%';
                }
                field("Functional Location URL"; Rec."Functional Location URL")
                {
                    ToolTip = 'Specifies the value of the Functional Location URL field.', Comment = '%';
                }
                field("Contact URL"; Rec."Contact URL")
                {
                    ToolTip = 'Specifies the value of the Contact URL field.', Comment = '%';
                }
                field("Item URL"; Rec."Item URL")
                {
                    ToolTip = 'Specifies the value of the Item URL field.', Comment = '%';
                }
                field("Projects URL"; Rec."Projects URL")
                {
                    ToolTip = 'Specifies the value of the Projects URL field.', Comment = '%';
                }
                field("Location URL"; Rec."Location URL")
                {
                    ToolTip = 'Specifies the value of the Location URL field.', Comment = '%';
                }
                field("Inventory Transfer URL"; Rec."Inventory Transfer URL")
                {
                    ToolTip = 'Specifies the value of the Inventory Transfer URL field.', Comment = '%';
                }
                field("Inventory Adjustment URL"; Rec."Inventory Adjustment URL")
                {
                    ToolTip = 'Specifies the value of the Inventory Adjustment URL field.', Comment = '%';
                }
                field("Bin URL"; Rec."Bin URL")
                {
                    ToolTip = 'Specifies the value of the Bin URL field.', Comment = '%';
                }
                field("Inventory URL"; Rec."Inventory URL")
                {
                    ToolTip = 'Specifies the value of the Inventory URL field.', Comment = '%';
                }
                // DCS::02122025 ++
                field("Sales Price List URL"; Rec."Sales Price List URL")
                {
                    ToolTip = 'Specifies the value of the Sales Price List URL field.', Comment = '%';
                }
                // DCS::02122025 --
                field("Purchase Order URL"; Rec."Purchase Order URL")
                {
                    ToolTip = 'Specifies the value of the Purchase Order URL field.', Comment = '%';
                }
            }
        }
    }
}
