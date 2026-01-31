page 50123 "API Work Order"
{
    PageType = API;
    SourceTable = "Work Order";
    ApplicationArea = All;
    Caption = 'Work Order API';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v1.0', 'v2.0';
    EntityName = 'WorkOrder';
    EntitySetName = 'WorkOrders';
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("workordernumber"; rec."Work Order No.") { }
                field(crmid; Rec."CRM ID") { }
                field("serviceaccount"; rec."Service Account CRM") { }
                field("systemstatus"; rec."System Status") { }
                field(substatus; rec."Substatus CRM") { }
                field("agreement"; rec."Agreement") { }
                field("billingaccount"; rec."Billing Account CRM") { }
                field("billingtype"; rec."Billing Type") { }
                field("contact"; rec."Contact CRM") { }
                field("currency"; rec."Currency CRM") { }
                field("fixtype"; rec."Fix Type") { }
                field("customerponumber"; Rec."Customer PO Number") { }
                field("functionallocation"; rec."Functional Location CRM") { }
                field("opportunity"; rec."Opportunity") { }
                field("salesorder"; rec."Sales Order") { }

                field(blanketOrder; Rec."Blanket Order CRM") { }
                field("owningbusinessunit"; rec."Shortcut Dimension 1 Code CRM") { }
                field("parentworkorder"; rec."Parent Work Order") { }
                field("timewindowstart"; rec."Time Window Start") { }
                // DCS::HP 081025 ++
                field("timewindowend"; rec."D365 Ending Date") { }
                field("closedondate"; rec."Time Window End") { }
                // DCS::HP 081025 --
                field("topic"; rec."Topic") { }
                field("workdescription"; rec."Work Description") { }
                field("workordertype"; rec."Work Order Type CRM") { }
                field("workordersummary"; rec."Work Order Summary") { }
                field("status"; rec."Status") { }
                field(paymentTerms; Rec."Payment Terms")
                {
                }
                field(casecustom; rec."Case Custom")
                {
                }
                field(owner; Rec."Owner CRM")
                {
                    Caption = 'Owner';
                }
                // HK::DCS 061025 ++
                field(primaryIncidentType; Rec."Primary Incident Type")
                {
                    Caption = 'Primary Incident Type';
                }
                field(sapServiceID; Rec."SAP Service ID")
                {
                    Caption = 'SAP Service ID';
                }
                // HK::DCS 061025 --
                field(workordersummaryml; WorkDescription)
                {
                    Caption = 'Work Order Summary ML';
                    trigger OnValidate()
                    begin
                        Rec.SetWorkDescription1(WorkDescription);
                    end;
                }
                field(fulltopic; Rec."Full Topic")
                {
                    Caption = 'Full Topic';
                }

            }
        }
    }
    // trigger OnAfterGetCurrRecord()
    // var
    //     myInt: Integer;
    // begin
    //     rec.SetWorkDescription1()
    // end;
    var
        WorkDescription: Text;

}
