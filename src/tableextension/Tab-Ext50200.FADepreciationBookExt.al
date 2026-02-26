tableextension 50200 "FA Depreciation Book Ext" extends "FA Depreciation Book"
{
    // Gkblabs_Tv_24/06/04 .....full code 
    trigger OnAfterInsert()
    var
        FixedAsset: Record "Fixed Asset";
        NoSeriesRec: Record "No. Series";
        FAPrefixMgt: Codeunit "FA Prefix Management";
        Prefix: Code[10];
    begin
        // When a new depreciation book is added, automatically set the posting group
        if FixedAsset.Get(Rec."FA No.") then begin
            // Extract prefix from FA No. and get the posting group from No. Series
            Prefix := FAPrefixMgt.ExtractPrefix(FixedAsset."No.");
            if (Prefix <> '') and NoSeriesRec.Get(Prefix) then begin
                if NoSeriesRec."Default FA Posting Group" <> '' then begin
                    Message('Debug(DepBook): Auto-setting Depreciation Book "%1" Posting Group to "%2" for FA "%3"',
                        Rec."Depreciation Book Code", NoSeriesRec."Default FA Posting Group", FixedAsset."No.");
                    Rec.Validate("FA Posting Group", NoSeriesRec."Default FA Posting Group");
                    Rec.Modify(true);
                end;
            end else if FixedAsset."FA Posting Group" <> '' then begin
                // Fallback: use FA's posting group if no prefix mapping found
                Message('Debug(DepBook): Setting Depreciation Book Posting Group from FA Posting Group "%1"', FixedAsset."FA Posting Group");
                Rec.Validate("FA Posting Group", FixedAsset."FA Posting Group");
                Rec.Modify(true);
            end;
        end;
    end;
}
