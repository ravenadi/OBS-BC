namespace GKBCustomization.GKBCustomization;

using Microsoft.Foundation.NoSeries;

pageextension 50203 "No. Series Ext" extends "No. Series"
{
    layout
    {
        addafter(Description)
        {
            field("FA Class Code"; Rec."FA Class Code")
            {
                ApplicationArea = All;
            }
            field("FA Subclass Code"; Rec."FA Subclass Code")
            {
                ApplicationArea = All;
            }
            field("Default FA Posting Group"; Rec."Default FA Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the default FA Posting Group to assign when this No. Series is used.';
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("Populate FA Mappings")
            {
                ApplicationArea = All;
                Caption = 'Populate FA Mappings';
                ToolTip = 'Populate FA Class, Subclass, and Default Posting Group for all FA No. Series codes.';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FASetup: Codeunit "FA Prefix Setup";
                begin
                    if Confirm('This will populate FA mappings for all No. Series codes (FASC, FAFF, FAIE, etc.). Continue?', true) then begin
                        FASetup.PopulateNoSeriesMappings();
                    end;
                end;
            }
        }
    }
}