page 50128 "API Employees"
{
    PageType = API;
    Caption = 'API Employee';
    APIPublisher = 'integration';
    APIGroup = 'api';
    APIVersion = 'v2.0', 'v1.0';
    EntityName = 'employees';
    EntitySetName = 'employees';
    SourceTable = Employee;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(crmid; Rec."CRM ID")
                {
                    Caption = 'CRM ID';
                }
                field(firstname; Rec."First Name")
                {
                    Caption = 'First Name';
                }
                field(lastname; Rec."Last Name")
                {
                    Caption = 'Last Name';
                }
                field(jobtitle; Rec."Job Title")
                {
                    Caption = 'Job Title';
                }
                field(phone; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(companyemail; Rec."Company E-Mail")
                {
                    Caption = 'Company E-Mail';
                }
                field(email; Rec."E-Mail")
                {
                    Caption = 'E-Mail';
                }
                field(privatephone; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }
            }
        }
    }
}


