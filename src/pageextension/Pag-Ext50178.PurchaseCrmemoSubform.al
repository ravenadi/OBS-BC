namespace GKBCustomization.GKBCustomization;

using Microsoft.Purchases.Document;
using Microsoft.Finance.GeneralLedger.Setup;
using System.Security.User;

pageextension 50178 "Purchase Cr memo Subform" extends "Purch. Cr. Memo Subform"
{
    layout
    {
        // modify("No.")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         GenPosSetup: Record "General Posting Setup";
        //     begin

        //         if GenPosSetup.get(Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group") then begin
        //             Rec."G/L Account No." := GenPosSetup."Purch. Account";
        //             Rec.Modify();
        //         end;
        //     end;
        // }
        addafter("Gen. Prod. Posting Group")
        {
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
            }
        }
         addbefore("Shortcut Dimension 1 Code")
        {
            field(orderedBy; Rec."Ordered By")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the name of the person who ordered the item.';
                Editable = true;
                Caption = 'Ordered By';
            }
        }
    }
     // DCS::HP 10092025 ++
    // trigger OnNewRecord(Belowx: Boolean)
    // var
    //     userRec: Record "User Setup";
    // begin
    //     IF userRec.GET(userID) THEN begin
    //         Rec."Ordered By" := userRec."User ID";
    //     end;
    // end;
    // DCS::HP 10092025 --    
}
