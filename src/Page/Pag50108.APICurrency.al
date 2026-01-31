page 50108 "API Currency"
{
    PageType = API;
    Caption = 'API Currency';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'currency';
    EntitySetName = 'currency';
    SourceTable = "Currency";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(code; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(exchangerate; Rec."Custom Exchange Amount")
                {
                    Caption = 'Exchange Rate';
                }
            }
        }
    }
}

