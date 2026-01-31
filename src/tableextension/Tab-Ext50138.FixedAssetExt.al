tableextension 50138 "Fixed Asset Ext" extends "Fixed Asset"
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "FA No. Series"; Code[20])
        {
            Caption = 'FA No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }


    }

    trigger OnAfterInsert()
    var
        FAPrefixManagement: Codeunit "FA Prefix Management";
    begin
        FAPrefixManagement.UpdateFAClassAndSubclass(Rec);
        // Persist without showing confirmation message (safe during insert)
        Rec.Modify(false);
    end;

    trigger OnAfterModify()
    var
        NoSeriesMgt: Codeunit "No. Series";
        NoSeriesRec: Record "No. Series";
        FAPrefixManagement: Codeunit "FA Prefix Management";
        Prefix: Code[10];
        i: Integer;
        NeedModify: Boolean;
    begin
        Message('Debug: OnAfterModify called for No: old="%1" new="%2"', xRec."No.", Rec."No.");

        // If user selected a series and No. is blank, generate the next No.
        if (STRLEN(Rec."FA No. Series") <> 0) and (STRLEN(Rec."No.") = 0) then begin
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."FA No. Series", Today, true);
            NeedModify := true;
        end;

        // If FA No. Series was changed (user selected a different series), apply mapping from the No. Series record
        if Rec."FA No. Series" <> xRec."FA No. Series" then begin
            if Rec."FA No. Series" <> '' then begin
                if NoSeriesRec.Get(Rec."FA No. Series") then begin
                    Rec.Validate("FA Class Code", NoSeriesRec."FA Class Code");
                    Rec.Validate("FA Subclass Code", NoSeriesRec."FA Subclass Code");
                    // Default posting group from series
                    if NoSeriesRec."Default FA Posting Group" <> '' then begin
                        Rec.Validate("FA Posting Group", NoSeriesRec."Default FA Posting Group");
                    end;
                end else begin
                    Rec.Validate("FA Class Code", '');
                    Rec.Validate("FA Subclass Code", '');
                    Rec.Validate("FA Posting Group", '');
                end;
            end else begin
                // Series cleared -> clear mapping
                Rec.Validate("FA Class Code", '');
                Rec.Validate("FA Subclass Code", '');
                Rec.Validate("FA Posting Group", '');
            end;
            NeedModify := true;
        end;

        // If FA Subclass changed directly, update posting group from No. Series mapping (if available)
        if Rec."FA Subclass Code" <> xRec."FA Subclass Code" then begin
            if Rec."FA Subclass Code" <> '' then begin
                NoSeriesRec.Reset();
                NoSeriesRec.SetRange("FA Subclass Code", Rec."FA Subclass Code");
                if NoSeriesRec.FindFirst() then begin
                    Message('Debug: Updated FA Posting Group to %1 based on FA Subclass %2', NoSeriesRec."Default FA Posting Group", Rec."FA Subclass Code");
                    Rec.Validate("FA Posting Group", NoSeriesRec."Default FA Posting Group");
                    NeedModify := true;
                end;
            end;
        end else begin
            // Otherwise, ensure class/subclass are correct (non-destructive OR update if mismatch)
            if STRLEN(Rec."No.") <> 0 then begin
                Prefix := '';
                for i := 1 to StrLen(Rec."No.") do begin
                    if Rec."No."[i] in ['A'..'Z', 'a'..'z'] then
                        Prefix := Prefix + Format(Rec."No."[i])
                    else
                        break;
                end;

                if (Prefix <> '') and NoSeriesRec.Get(Prefix) then begin
                    // If blank -> fill; if mismatch -> overwrite to keep mapping consistent
                    if (Rec."FA Class Code" = '') or (Rec."FA Class Code" <> NoSeriesRec."FA Class Code") then begin
                        Rec.Validate("FA Class Code", NoSeriesRec."FA Class Code");
                        NeedModify := true;
                    end;
                    if (Rec."FA Subclass Code" = '') or (Rec."FA Subclass Code" <> NoSeriesRec."FA Subclass Code") then begin
                        Rec.Validate("FA Subclass Code", NoSeriesRec."FA Subclass Code");
                        NeedModify := true;
                    end;
                end;

                if (Rec."FA Class Code" <> xRec."FA Class Code") or (Rec."FA Subclass Code" <> xRec."FA Subclass Code") then
                    NeedModify := true;
            end;
        end;

        if NeedModify then
            Rec.Modify(false);
    end;
}
