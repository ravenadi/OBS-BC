pageextension 50152 "G/L Account Card Ext" extends "G/L Account Card"
{

    trigger OnOpenPage();
    var
        UserSetupRec: Record "User Setup";
        IsUserAllowed: Boolean;
    begin
        if UserSetupRec.Get(UserId()) then begin
            IsUserAllowed := UserSetupRec."G\L Account";
        end else begin
            IsUserAllowed := false;
        end;

        if not IsUserAllowed then
            CurrPage.Editable(false);
    end;

    var
        myInt: Integer;
}