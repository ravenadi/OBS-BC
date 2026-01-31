// DCS::HP24112025 ++
namespace GKBCustomizationnov.GKBCustomizationnov;
using Microsoft.Warehouse.Structure;

page 50159 "D01 Location API"
{
    ApplicationArea = All;
    Caption = 'D01 Location API';
    PageType = List;
    SourceTable = Bin;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the location from which you opened the Bins window.';
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a code that uniquely describes the bin.';
                }
            }
        }
    }
}
// DCS::HP24112025 --