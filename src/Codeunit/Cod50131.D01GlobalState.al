namespace GKBCustomization.GKBCustomization;

// DCS::HP 27082025 ++
codeunit 50131 "D01 Global State"
{
    SingleInstance = true;

    var
        IsHandledFlag: Boolean;

    procedure SetIsHandled(Value: Boolean)
    begin
        IsHandledFlag := Value;
    end;

    procedure GetIsHandled(): Boolean
    begin
        exit(IsHandledFlag);
    end;
}
// DCS::HP 27082025 --

