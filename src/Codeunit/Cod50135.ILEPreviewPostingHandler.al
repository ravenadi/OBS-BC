// DCS::HP 16102025 ++
codeunit 50135 "ILE Preview Posting Handler"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnAfterBindSubscription', '', false, false)]
    local procedure OnStartPreview(var PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler")
    begin
        IsPreview := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnAfterUnbindSubscription', '', false, false)]
    local procedure OnEndPreview()
    begin
        IsPreview := false;
    end;

    procedure GetIsPreview(): Boolean
    begin
        exit(IsPreview);
    end;

    var
        IsPreview: Boolean;
}
// DCS::HP 16102025 --