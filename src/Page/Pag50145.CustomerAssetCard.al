page 50145 "Customer Asset Card"
{
    Caption = 'Customer Asset Card';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "GKB Customer Asset";
    RefreshOnActivate = true;
    AboutTitle = 'Customer Asset Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = all;
                    Caption = 'No';
                    Importance = Standard;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'It specifies the customer asset name';
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = all;
                    Caption = 'Account Id';
                }
                field(Account; Rec.Account)
                {
                    ApplicationArea = all;
                    Caption = 'Account';
                }
                field("Equipment Card No."; Rec."Equipment Card No.")
                {
                    ApplicationArea = all;
                    Caption = 'Equipment Card No.';
                }
                field("Equipment Category"; Rec."Equipment Category")
                {
                    ApplicationArea = all;
                    Caption = 'Equipment Category';
                }
                field("Product Id"; Rec."Product Id")
                {
                    ApplicationArea = all;
                    Caption = 'Product Id';
                }
                field("SAP Item No."; Rec."SAP Item No.")
                {
                    ApplicationArea = all;
                    Caption = 'SAP Item No.';
                }
                field(Product; Rec.Product)
                {
                    ApplicationArea = all;
                    Caption = 'Product';
                }
                field(Agreement; Rec.Agreement)
                {
                    ApplicationArea = all;
                    Caption = 'Agreement';
                }
                field("Boiler Type"; Rec."Boiler Type")
                {
                    ApplicationArea = all;
                    Caption = 'Boiler Type';
                }
                field("Capacity(KW)"; Rec."Capacity(KW)")
                {
                    ApplicationArea = all;
                    Caption = 'Capacity';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                    Caption = 'Category';
                }
                field("Date Of Next 4 Monthly"; Rec."Date Of Next 4 Monthly")
                {
                    ApplicationArea = all;
                    Caption = 'Date Of Next 4 Monthly';
                }
                field("Date OfNext6MtlySteamTrapAudit"; Rec."Date OfNext6MtlySteamTrapAudit")
                {
                    ApplicationArea = all;
                    Caption = 'Date Of Next 6 Monthly Steam Trap Audit';
                }
                field("Date Of Next AS2593 Audit"; Rec."Date Of Next AS2593 Audit")
                {
                    ApplicationArea = all;
                    Caption = 'Date Of Next AS2593 Audit';
                }
                field("Date Of Next Biennial Service"; Rec."Date Of Next Biennial Service")
                {
                    ApplicationArea = all;
                    Caption = 'Date Of Next Biennial Service';
                }
                field("Date Of Next Steam Trap Audit"; Rec."Date Of Next Steam Trap Audit")
                {
                    ApplicationArea = all;
                    Caption = 'Date Of Next Steam Trap Audit';
                }
                field(Days; Rec.Days)
                {
                    ApplicationArea = all;
                    Caption = 'Days';
                }
                field("Equipment Man"; Rec."Equipment Man")
                {
                    ApplicationArea = all;
                    Caption = 'Equipment Man';
                }
                field("ETC Serial No"; Rec."ETC Serial No")
                {
                    ApplicationArea = all;
                    Caption = 'ETC Serial No';
                }
                field(Floor; Rec.Floor)
                {
                    ApplicationArea = all;
                    Caption = 'Floor';
                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = all;
                    Caption = 'Fuel Type';
                }
                field("Functional Location"; Rec."Functional Location")
                {
                    ApplicationArea = all;
                    Caption = 'Functional Location';
                }
                field("Installation Date"; Rec."Installation Date")
                {
                    ApplicationArea = all;
                    Caption = 'Installation Date';
                }
                field("Last active alert time"; Rec."Last active alert time")
                {
                    ApplicationArea = all;
                    Caption = 'Last Active Alert Time';
                }
                field("Last Biennal Date"; Rec."Last Biennal Date")
                {
                    ApplicationArea = all;
                    Caption = 'Last Biennal Date';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = all;
                    Caption = 'Notes';
                }
                field(NoOfTechniesForAnnualService; Rec.NoOfTechniesForAnnualService)
                {
                    ApplicationArea = all;
                    Caption = 'No. Of Technicians For Annual Service';
                }
                field("OBS Sim No"; Rec."OBS Sim No")
                {
                    ApplicationArea = all;
                    Caption = 'OBS Sim No';
                }
                field("On-Site Installed location"; Rec."On-Site Installed location")
                {
                    ApplicationArea = all;
                    Caption = 'On-Site Installed Location';
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = all;
                    Caption = 'Owner';
                }
                field("Owning business Unit"; Rec."Owning business Unit")
                {
                    ApplicationArea = all;
                    Caption = 'Owning Business Unit';
                }
                field(Pressure; Rec.Pressure)
                {
                    ApplicationArea = all;
                    Caption = 'Pressure';
                }
                field("Registration Status"; Rec."Registration Status")
                {
                    ApplicationArea = all;
                    Caption = 'Registration Status';
                }
                field("Room Location"; Rec."Room Location")
                {
                    ApplicationArea = all;
                    Caption = 'Room Location';
                }
                field("Safety Valve"; Rec."Safety Valve")
                {
                    ApplicationArea = all;
                    Caption = 'Safety Valve';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Caption = 'Status';
                }
                field("Status reason"; Rec."Status reason")
                {
                    ApplicationArea = all;
                    Caption = 'Status Reason';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = all;
                    Caption = 'Unit';
                }
                field(warrenty; Rec.warrenty)
                {
                    ApplicationArea = all;
                    Caption = 'Warrenty';
                }
            }
            group("Asset Details")
            {
                Caption = 'Asset Details';
                field("Asset Location"; Rec."Asset Location")
                {
                    ApplicationArea = all;
                    Caption = 'Asset Location';
                }
                field("Asset number"; Rec."Asset number")
                {
                    ApplicationArea = all;
                    Caption = 'Asset Location';
                }
                field("Parent Asset"; Rec."Parent Asset")
                {
                    ApplicationArea = all;
                    Caption = 'Parent Asset';
                }
                field("Top-Level Asset"; Rec."Top-Level Asset")
                {
                    ApplicationArea = all;
                    Caption = 'Asset Location';
                }
                field("Asset Tag"; Rec."Asset Tag")
                {
                    ApplicationArea = all;
                    Caption = 'Asset Tag';
                }
            }
            group("Manufacturing Details")
            {

                field(Manufacture; Rec.Manufacture)
                {
                    ApplicationArea = all;
                    Caption = 'Manufacture';
                }
                field("Manufacture Date"; Rec."Manufacture Date")
                {
                    ApplicationArea = all;
                    Caption = 'Manufacture Date';
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ApplicationArea = all;
                    Caption = 'Manufacturer';
                }
                field("Manufacture Detail"; Rec."Manufacture Detail")
                {
                    ApplicationArea = all;
                    Caption = 'Manufacture Details';
                }
                field("Manufacture Serial No."; Rec."Manufacture Serial No.")
                {
                    ApplicationArea = all;
                    Caption = 'Manufacture Serial No.';
                }
                field("Next 3 Monthly Date"; Rec."Next 3 Monthly Date")
                {
                    ApplicationArea = all;
                    Caption = 'Next 3 Monthly Date';
                }
                field("Next 5 Weekly Date"; Rec."Next 5 Weekly Date")
                {
                    ApplicationArea = all;
                    Caption = 'Next % Weekly Date';
                }
                field("Next 6 Monthly Date"; Rec."Next 6 Monthly Date")
                {
                    ApplicationArea = all;
                    Caption = 'Next 6 Monthly Date';
                }
                field("Next Annual Date"; Rec."Next Annual Date")
                {
                    ApplicationArea = all;
                    Caption = 'Next Annual Date';
                }
            }
            group(Budget)
            {
                field("Budgeted hours 3 Monthly"; Rec."Budgeted hours 3 Monthly")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours 3 Monthly';
                }
                field("Budgeted hours 4 Monthly"; Rec."Budgeted hours 4 Monthly"
                )
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours 4 Monthly';
                }
                field("Budgeted hours 5 Monthly"; Rec."Budgeted hours 5 Monthly")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours 5 Monthly';
                }
                field("Budgeted hours 6 Monthly"; Rec."Budgeted hours 6 Monthly")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours 6 Monthly';
                }
                field(Budgetedhrs6MntlyStmtrapaudit; Rec.Budgetedhrs6MntlyStmtrapaudit)
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hrs 6 Monthly Steam Trap Audit';
                }
                field("Budgeted hours AS2593"; Rec."Budgeted hours AS2593")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours AS2593';
                }
                field("Budgeted hours for annual"; Rec."Budgeted hours for annual")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours For Annual';
                }
                field(BudgetedhrsforbiennialSerice; Rec.BudgetedhrsforbiennialSerice)
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours For Biennial Service';
                }
                field("Budgeted hrs 3steam trap audit"; Rec."Budgeted hrs 3steam trap audit")
                {
                    ApplicationArea = all;
                    Caption = 'Budgeted Hours Steam Trap Audit';
                }

            }
        }
        area(FactBoxes)
        {
            part(Control149; "Customer Picture")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = field(No);
                // Visible = not IsOfficeAddin;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::Customer),
                              "No." = field(No);
            }
            part(Details; "Office Customer Details")
            {
                ApplicationArea = All;
                Caption = 'Details';
                SubPageLink = "No." = field(No);
                //Visible = IsOfficeAddin;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send E-mails")
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}