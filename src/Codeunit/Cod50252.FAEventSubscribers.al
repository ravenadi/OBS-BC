codeunit 50252 "FA Prefix Event Subs"
{
    [EventSubscriber(ObjectType::Table, Database::"Fixed Asset", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure FA_OnAfterValidate_No(var Rec: Record "Fixed Asset")
    var
        FAPrefixMgt: Codeunit "FA Prefix Management";
    begin
        // Subscriber runs when the No. field is validated (after user confirms PK changes)
        Message('Debug(Subscriber): OnAfterValidateEvent for No="%1"', Rec."No.");
        FAPrefixMgt.UpdateFAClassAndSubclassForce(Rec);
        Message('Debug(Subscriber): After applying mapping => Class="%1", Subclass="%2"', Rec."FA Class Code", Rec."FA Subclass Code");
        // Do not call Rec.Modify here; OnAfterModify will persist changes
    end;
}