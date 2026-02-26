page 50207 "API Update Item From CRM"
{
    PageType = API;
    Caption = 'API Update Item From CRM';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0';
    EntityName = 'UpdateItemFromCRM';
    EntitySetName = 'UpdateItemFromCRM';
    SourceTable = "CRM Sync Buffer";
    SourceTableTemporary = true;
    DelayedInsert = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(bcid; Rec."BC Item No.")
                {
                    Caption = 'BC Item No.';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(d365productid; Rec."D365 Product ID")
                {
                    Caption = 'D365 Product ID';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemRec: Record Item;
        Modified: Boolean;
    begin
        if Rec."BC Item No." = '' then
            Error('BC Item No. cannot be empty.');

        if Rec."CRM ID" = '' then
            Error('CRM ID cannot be empty.');

        if not ItemRec.Get(Rec."BC Item No.") then
            Error('Item %1 not found.', Rec."BC Item No.");

        Modified := false;

        if ItemRec."CRM ID" <> Rec."CRM ID" then begin
            ItemRec.Validate("CRM ID", Rec."CRM ID");
            Modified := true;
        end;

        if (Rec."D365 Product ID" <> '') and
           (ItemRec."D365 Product ID" <> Rec."D365 Product ID") then begin
            ItemRec.Validate("D365 Product ID", Rec."D365 Product ID");
            Modified := true;
        end;

        if Modified then
            ItemRec.Modify(true);

        exit(false); // Don't actually insert, we just updated
    end;
}
