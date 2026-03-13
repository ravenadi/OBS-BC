namespace GKBCustomization.GKBCustomization;

using Microsoft.Warehouse.Structure;

//GkbLabs_Tv_04/12/25
/// <summary>
/// Codeunit 50141 "Bin Event Subscriber"
/// Automatically syncs Bin changes to CRM on insert, modify, and delete
/// </summary>
codeunit 50141 "Bin Event Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::Bin, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertBin(var Rec: Record Bin; RunTrigger: Boolean)
    var
        BinCRM: Codeunit "Bin Crm Management";
    begin
        if Rec.IsTemporary() then
            exit;

        if not RunTrigger then
            exit;

        // Sync to CRM after insert
        BinCRM.UpdateToCrm(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Bin, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyBin(var Rec: Record Bin; var xRec: Record Bin; RunTrigger: Boolean)
    var
        BinCRM: Codeunit "Bin Crm Management";
    begin
        if Rec.IsTemporary() then
            exit;

        if not RunTrigger then
            exit;

        // if the only thing that changed was the CRM ID, skip the sync
        // (user is pasting/adjusting the key; CRM will already have the record)
        if Rec."CRM ID" <> xRec."CRM ID" then
            exit;

        // Sync to CRM after modify
        BinCRM.UpdateToCrm(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Bin, 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteBin(var Rec: Record Bin; RunTrigger: Boolean)
    var
        BinCRM: Codeunit "Bin Crm Management";
    begin
        if Rec.IsTemporary() then
            exit;

        if not RunTrigger then
            exit;

        // Delete from CRM after delete
        if Rec."CRM ID" <> '' then
            BinCRM.DeleteFromCrm(Rec.Code, Rec."CRM ID");
    end;
}
//GkbLabs_Tv_04/12/25