namespace GKBCustomization.GKBCustomization;

using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Foundation.NoSeries;

codeunit 50250 "FA Prefix Management"
{
    procedure ExtractPrefix(FANo: Code[20]): Code[10]
    var
        i: Integer;
        PrefixText: Text[10];
    begin
        // Extract leading alphabetic characters (before digits), max 10 chars
        PrefixText := '';
        for i := 1 to StrLen(FANo) do begin
            if i > 10 then
                exit(PrefixText);

            if FANo[i] in ['A' .. 'Z', 'a' .. 'z'] then
                PrefixText := PrefixText + Format(FANo[i])
            else
                exit(PrefixText); // Stop at first non-alphabetic character
        end;
        exit(PrefixText);
    end;

    procedure GetFAClassAndSubclass(FANo: Code[20]; var FAClassCode: Code[10]; var FASubclassCode: Code[10]; var FAPostingGroup: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        Prefix: Code[10];
    begin
        // Extract prefix from FA No.
        Prefix := ExtractPrefix(FANo);
        Message('Debug: Extracted Prefix="%1" from No="%2"', Prefix, FANo);
        if Prefix = '' then
            exit(false);

        // Lookup mapping
        if NoSeries.Get(Prefix) then begin
            FAClassCode := NoSeries."FA Class Code";
            FASubclassCode := NoSeries."FA Subclass Code";
            FAPostingGroup := NoSeries."Default FA Posting Group";
            Message('Debug: Found No. Series "%1" -> Class="%2", Subclass="%3", PostingGroup="%4"', Prefix, FAClassCode, FASubclassCode, FAPostingGroup);
            exit(true);
        end;

        Message('Debug: No. Series for Prefix "%1" not found', Prefix);
        exit(false);
    end;

    procedure UpdateFAClassAndSubclass(var FixedAsset: Record "Fixed Asset")
    var
        FAClassCode: Code[10];
        FASubclassCode: Code[10];
        FAPostingGroup: Code[20];
    begin
        if FixedAsset."No." = '' then
            exit;

        if GetFAClassAndSubclass(FixedAsset."No.", FAClassCode, FASubclassCode, FAPostingGroup) then begin
            if FixedAsset."FA Class Code" = '' then
                FixedAsset."FA Class Code" := FAClassCode;
            if FixedAsset."FA Subclass Code" = '' then
                FixedAsset."FA Subclass Code" := FASubclassCode;
            if (FixedAsset."FA Posting Group" = '') and (FAPostingGroup <> '') then
                FixedAsset."FA Posting Group" := FAPostingGroup;
        end;
    end;

    procedure UpdateFAClassAndSubclassForce(var FixedAsset: Record "Fixed Asset")
    var
        FAClassCode: Code[10];
        FASubclassCode: Code[10];
        FAPostingGroup: Code[20];
    begin
        if FixedAsset."No." = '' then
            exit;

        if GetFAClassAndSubclass(FixedAsset."No.", FAClassCode, FASubclassCode, FAPostingGroup) then begin
            // Debug and use Validate so standard TableRelation and validation logic runs
            Message('Debug: Updating FA No="%1" => Class="%2", Subclass="%3", PostingGroup="%4"', FixedAsset."No.", FAClassCode, FASubclassCode, FAPostingGroup);
            
            FixedAsset.Validate("FA Class Code", FAClassCode);
            FixedAsset.Validate("FA Subclass Code", FASubclassCode);
            
            if FAPostingGroup <> '' then begin
                Message('Debug: Setting FA Posting Group to "%1"', FAPostingGroup);
                FixedAsset.Validate("FA Posting Group", FAPostingGroup);
            end else begin
                Message('Debug: FA Posting Group is empty in No. Series mapping');
            end;
        end else begin
            Message('Debug: No mapping found for FA No="%1"', FixedAsset."No.");
        end;
    end;
}
