namespace GKBCustomization.GKBCustomization;

using Microsoft.FixedAssets.FixedAsset;

pageextension 50183 "Fixed Asset Ext" extends "Fixed Asset Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                FAPrefixManagement: Codeunit "FA Prefix Management";
            begin
                Message('Debug(Page): OnAfterValidate fired for No="%1"', Rec."No.");
                // Force update in buffer and refresh UI; persistence will be handled safely by the table OnAfterModify
                FAPrefixManagement.UpdateFAClassAndSubclassForce(Rec);
                Message('Debug(Page): After applying prefix mapping for No="%1" => Class="%2", Subclass="%3"', Rec."No.", Rec."FA Class Code", Rec."FA Subclass Code");
                CurrPage.Update();
            end;
        }

        addafter("No.")
        {
            field("FA No. Series"; Rec."FA No. Series")
            {
                ApplicationArea = All;
            }
        }
        addafter("FA Class Code")
        {

            //Gkblabs_Tv_03/12/25

            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
                Caption = 'Global Dimension 1 Code';
            }
            // field("FA Posting Group"; Rec."FA Posting Group")
            // {
            //     ApplicationArea = All;
            //     Caption = 'FA Posting Group';
            //     Visible = True;
            // }
        }
        // modify(FAPostingGroup)
        // {
        //     Visible = false;
        // }
    }
}
