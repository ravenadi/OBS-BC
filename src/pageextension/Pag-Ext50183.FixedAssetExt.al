namespace GKBCustomization.GKBCustomization;

using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Foundation.NoSeries;
using Microsoft.FixedAssets.Depreciation;

pageextension 50183 "Fixed Asset Ext" extends "Fixed Asset Card"
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                NoSeriesRec: Record "No. Series";
                FADepreciationBook: Record "FA Depreciation Book";
                FAPrefixMgt: Codeunit "FA Prefix Management";
                Prefix: Code[10];
            begin
                if Rec."No." = '' then
                    exit;

                Message('Debug(Page): OnAfterValidate for No="%1"', Rec."No.");

                // Extract prefix from FA No.
                Prefix := FAPrefixMgt.ExtractPrefix(Rec."No.");
                Message('Debug(Page): Extracted Prefix="%1"', Prefix);

                if (Prefix = '') then begin
                    Message('Debug(Page): No prefix found');
                    exit;
                end;

                // Lookup No. Series mapping
                if not NoSeriesRec.Get(Prefix) then begin
                    Message('Debug(Page): No. Series "%1" not found', Prefix);
                    exit;
                end;

                Message('Debug(Page): Found mapping -> Class="%1", Subclass="%2", PostingGroup="%3"',
                    NoSeriesRec."FA Class Code", NoSeriesRec."FA Subclass Code", NoSeriesRec."Default FA Posting Group");

                // Set FA No. Series field to match prefix (prevents OnAfterModify conflict)
                Rec."FA No. Series" := Prefix;

                // Apply mapping in correct order: Class -> Posting Group -> Subclass
                // This order prevents validation conflicts
                if NoSeriesRec."FA Class Code" <> '' then begin
                    Message('Debug(Page): Applying FA Class="%1"', NoSeriesRec."FA Class Code");
                    Rec.Validate("FA Class Code", NoSeriesRec."FA Class Code");
                end;

                if NoSeriesRec."Default FA Posting Group" <> '' then begin
                    Message('Debug(Page): Applying FA Posting Group="%1"', NoSeriesRec."Default FA Posting Group");
                    Rec.Validate("FA Posting Group", NoSeriesRec."Default FA Posting Group");
                end;

                if NoSeriesRec."FA Subclass Code" <> '' then begin
                    Message('Debug(Page): Applying FA Subclass="%1"', NoSeriesRec."FA Subclass Code");
                    Rec.Validate("FA Subclass Code", NoSeriesRec."FA Subclass Code");
                end;

                Message('Debug(Page): COMPLETE - Class="%1", Subclass="%2", PostingGroup="%3"',
                    Rec."FA Class Code", Rec."FA Subclass Code", Rec."FA Posting Group");

                // DIRECTLY UPDATE Depreciation Books for this FA
                if NoSeriesRec."Default FA Posting Group" <> '' then begin
                    FADepreciationBook.Reset();
                    FADepreciationBook.SetRange("FA No.", Rec."No.");
                    if FADepreciationBook.FindSet(true) then begin
                        repeat
                            if FADepreciationBook."FA Posting Group" <> NoSeriesRec."Default FA Posting Group" then begin
                                Message('Debug(Page): Updating Dep Book "%1" Posting Group from "%2" to "%3"',
                                    FADepreciationBook."Depreciation Book Code",
                                    FADepreciationBook."FA Posting Group",
                                    NoSeriesRec."Default FA Posting Group");
                                FADepreciationBook.Validate("FA Posting Group", NoSeriesRec."Default FA Posting Group");
                                FADepreciationBook.Modify(false);
                            end;
                        until FADepreciationBook.Next() = 0;
                    end else
                        Message('Debug(Page): No Depreciation Books found for FA "%1"', Rec."No.");
                end;
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
            field("FA Posting Group"; Rec."FA Posting Group")
            {
                ApplicationArea = All;
                Caption = 'FA Posting Group';
                Visible = True;
            }
        }
    }
}
