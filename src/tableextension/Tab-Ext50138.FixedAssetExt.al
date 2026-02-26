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
    begin
        // Scenario 1: User selected FA No. Series and No. is blank - generate next number
        if (Rec."FA No. Series" <> '') and (Rec."No." = '') then begin
            Rec."No." := NoSeriesMgt.GetNextNo(Rec."FA No. Series", Today, true);
            Rec.Modify(false);
            exit;
        end;

        // Scenario 2: FA No. Series was manually changed by user
        if (Rec."FA No. Series" <> xRec."FA No. Series") and (Rec."No." = xRec."No.") then begin
            if (Rec."FA No. Series" <> '') and NoSeriesRec.Get(Rec."FA No. Series") then begin
                Message('Debug(Table): Manually changed FA No. Series to "%1" - applying mapping', Rec."FA No. Series");
                if NoSeriesRec."FA Class Code" <> '' then
                    Rec.Validate("FA Class Code", NoSeriesRec."FA Class Code");
                if NoSeriesRec."Default FA Posting Group" <> '' then
                    Rec.Validate("FA Posting Group", NoSeriesRec."Default FA Posting Group");
                if NoSeriesRec."FA Subclass Code" <> '' then
                    Rec.Validate("FA Subclass Code", NoSeriesRec."FA Subclass Code");
                // Note: Depreciation Books will be updated automatically by the 
                // Event Subscriber when FA Subclass Code validation completes
                Rec.Modify(false);
            end;
        end;
    end;
}
