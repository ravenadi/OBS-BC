page 50214 "PurchaseOrderStatusAPICust"
{
    //GKBLabs_Tv_29/06/24 ++
    PageType = API;
    Caption = 'PurchaseOrderStatusAPICust';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v1.0';
    EntityName = 'PurchaseOrderStatusAPICust';
    EntitySetName = 'PurchaseOrderStatusAPICustSet';
    SourceTable = "Purchase Header";
    DelayedInsert = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(purchaseOrderNo; Rec."No.")
                {
                    Caption = 'Purchase Order No.';
                }
                field(crmId; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(status; GetDecodedStatus())
                {
                    Caption = 'Status';
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date Time';
                }
                //GKBLabs_Tv_29/06/24 ++
                field(vendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                    Caption = 'Vendor Invoice No.';
                }
            }
        }
    }
    var
    // JobCrmId: Text; // Removed - job info comes from lines, not header

    local procedure GetDecodedStatus(): Text
    begin
        exit(Format(Rec.Status).Replace('_x0020_', ' '));
    end;
}