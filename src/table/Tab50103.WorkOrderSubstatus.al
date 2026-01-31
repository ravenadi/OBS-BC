table 50103 "Work Order Substatus"
{
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "System Substatus"; enum "Task Status1")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = Unscheduled, Scheduled, "In Progress", Completed, Invoiced, Cancelled;
            // OptionCaption = ' ,Unscheduled, Scheduled, "In Progress", Completed, Invoiced, Canceled';
        }
        field(3; Status; enum "Activity Status")
        {
            DataClassification = ToBeClassified;
            // OptionMembers = " ",Active,InActive;
            // OptionCaption = 'Active,InActive';
        }
        field(4; "CRM ID"; Text[100])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, "System Substatus", Status)
        {
        }
    }
}