codeunit 50206 "Update Item From CRM"
{
    [ServiceEnabled]
    procedure UpdateItemFromCRM(bcid: Code[20]; crmid: Text; d365productid: Text)
    var
        ItemRec: Record Item;
        Modified: Boolean;
    begin
        if not ItemRec.Get(bcid) then
            Error('Item %1 not found.', bcid);

        if crmid = '' then
            Error('CRM ID cannot be empty.');

        Modified := false;

        if ItemRec."CRM ID" <> crmid then begin
            ItemRec.Validate("CRM ID", crmid);
            Modified := true;
        end;

        if (d365productid <> '') and
           (ItemRec."D365 Product ID" <> d365productid) then begin
            ItemRec.Validate("D365 Product ID", d365productid);
            Modified := true;
        end;

        if Modified then
            ItemRec.Modify(true);
    end;
}