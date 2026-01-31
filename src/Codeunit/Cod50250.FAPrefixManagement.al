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

    procedure GetFAClassAndSubclass(FANo: Code[20]; var FAClassCode: Code[10]; var FASubclassCode: Code[10]): Boolean
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
            Message('Debug: Found No. Series "%1" -> Class="%2", Subclass="%3"', Prefix, FAClassCode, FASubclassCode);
            exit(true);
        end;

        Message('Debug: No. Series for Prefix "%1" not found', Prefix);
        exit(false);
    end;

    procedure UpdateFAClassAndSubclass(var FixedAsset: Record "Fixed Asset")
    var
        FAClassCode: Code[10];
        FASubclassCode: Code[10];
    begin
        if FixedAsset."No." = '' then
            exit;

        if GetFAClassAndSubclass(FixedAsset."No.", FAClassCode, FASubclassCode) then begin
            if FixedAsset."FA Class Code" = '' then
                FixedAsset."FA Class Code" := FAClassCode;
            if FixedAsset."FA Subclass Code" = '' then
                FixedAsset."FA Subclass Code" := FASubclassCode;
        end;
    end;

    procedure UpdateFAClassAndSubclassForce(var FixedAsset: Record "Fixed Asset")
    var
        FAClassCode: Code[10];
        FASubclassCode: Code[10];
        Prefix: Code[10];
        NoSeries: Record "No. Series";
    begin
        if FixedAsset."No." = '' then
            exit;

        Prefix := ExtractPrefix(FixedAsset."No.");
        if GetFAClassAndSubclass(FixedAsset."No.", FAClassCode, FASubclassCode) then begin
            // Debug and use Validate so standard TableRelation and validation logic runs
            Message('Debug: Updating Fixed Asset No="%1" => Class="%2", Subclass="%3"', FixedAsset."No.", FAClassCode, FASubclassCode);
            FixedAsset.Validate("FA Class Code", FAClassCode);
            FixedAsset.Validate("FA Subclass Code", FASubclassCode);

            // Also set Default FA Posting Group if configured on No. Series matching the prefix
            if (Prefix <> '') and NoSeries.Get(Prefix) and (NoSeries."Default FA Posting Group" <> '') then begin
                Message('Debug: Also setting FA Posting Group to "%1" based on No. Series "%2"', NoSeries."Default FA Posting Group", Prefix);
                FixedAsset.Validate("FA Posting Group", NoSeries."Default FA Posting Group");
            end;
        end else begin
            Message('Debug: Clearing FA Class/Subclass for Fixed Asset No="%1" (no mapping found)', FixedAsset."No.");
            // Clear if no mapping found (validate to ensure UI consistency)
            FixedAsset.Validate("FA Class Code", '');
            FixedAsset.Validate("FA Subclass Code", '');
            FixedAsset.Validate("FA Posting Group", '');
        end;
    end;
}
