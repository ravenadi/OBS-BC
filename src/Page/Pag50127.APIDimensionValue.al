page 50127 "API Dimension Value"
{
    PageType = API;
    Caption = 'Dimension Value API';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'dimensionvalues';
    EntitySetName = 'dimensionvalues';
    SourceTable = "Dimension Value";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(dimensioncode; Rec."Dimension Code")
                {
                    Caption = 'Dimension Code';
                }
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM Id';
                }
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(dimensiontype; Rec."Dimension Value Type")
                {
                    Caption = 'Dimension Value Type';
                }
                field(totaling; Rec.Totaling)
                {
                    Caption = 'Totaling';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(consolidationCode; Rec."Consolidation Code")
                {
                    Caption = 'Consolidation Code';
                }
                field(indentation; Rec.Indentation)
                {
                    Caption = 'Indentation';
                }
                field(globalDimensionNo; Rec."Global Dimension No.")
                {
                    Caption = 'Global Dimension No.';
                }
                field(mapToICDimensionCode; Rec."Map-to IC Dimension Code")
                {
                    Caption = 'Map-to IC Dimension Code';
                }
                field(mapToICDimensionValueCode; Rec."Map-to IC Dimension Value Code")
                {
                    Caption = 'Map-to IC Dimension Value Code';
                }
                field(dimensionValueID; Rec."Dimension Value ID")
                {
                    Caption = 'Dimension Value ID';
                }
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'Last Modified Date Time';
                }
                field(dimensionId; Rec."Dimension Id")
                {
                    Caption = 'Dimension Id';
                }
            }
        }
    }
}

