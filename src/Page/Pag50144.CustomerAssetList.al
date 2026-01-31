page 50144 "Customer Asset List"
{
    PageType = list;
    ApplicationArea = all;
    UsageCategory = Lists;
    CardPageId = "Customer Asset Card";
    Editable = false;
    AboutTitle = 'About Customer Asset';
    SourceTable = "GKB Customer Asset";
    QueryCategory = 'Customer Asset List';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(No; Rec.No)
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = all;
                }
                field(Account; Rec.Account)
                {
                    ApplicationArea = all;
                }
                field("Equipment Card No."; Rec."Equipment Card No.")
                {
                    ApplicationArea = all;
                    Caption = 'Equipment Card No.';
                }
                field("Asset Location"; Rec."Asset Location")
                {
                    ApplicationArea = all;
                }
                field("Equipment Category"; Rec."Equipment Category")
                {
                    ApplicationArea = all;
                }
                field("Product Id"; Rec."Product Id")
                {
                    ApplicationArea = all;
                }
                field("SAP Item No."; Rec."SAP Item No.")
                {
                    ApplicationArea = all;
                }
                field(Product; Rec.Product)
                {
                    ApplicationArea = all;
                }
                field("Parent Asset"; Rec."Parent Asset")
                {
                    ApplicationArea = all;
                }
                field("Top-Level Asset"; Rec."Top-Level Asset")
                {
                    ApplicationArea = all;
                }
                field(Agreement; Rec.Agreement)
                {
                    ApplicationArea = all;
                }
                field("Boiler Type"; Rec."Boiler Type")
                {
                    ApplicationArea = all;
                }
                field("Asset Tag"; Rec."Asset Tag")
                {
                    ApplicationArea = all;
                }
                field("Building No. Name"; Rec."Building No. Name")
                {
                    ApplicationArea = all;
                }
                field("Burner Brand"; Rec."Burner Brand")
                {
                    ApplicationArea = all;
                }
                field("Burner Type"; Rec."Burner Type")
                {
                    ApplicationArea = all;
                }
                field("Capacity(KW)"; Rec."Capacity(KW)")
                {
                    ApplicationArea = all;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                }
                field("Date Of Next 4 Monthly"; Rec."Date Of Next 4 Monthly")
                {
                    ApplicationArea = all;
                }
                field("Date OfNext6MtlySteamTrapAudit"; Rec."Date OfNext6MtlySteamTrapAudit")
                {
                    ApplicationArea = all;
                }
                field("Date Of Next Biennial Service"; Rec."Date Of Next Biennial Service")
                {
                    ApplicationArea = all;
                }
                field("Date Of Next Steam Trap Audit"; Rec."Date Of Next Steam Trap Audit")
                {
                    ApplicationArea = all;
                }
                field("Date Of Next AS2593 Audit"; Rec."Date Of Next AS2593 Audit")
                {
                    ApplicationArea = all;
                }
                field(Days; Rec.Days)
                {
                    ApplicationArea = all;
                }
                field("Equipment Man"; Rec."Equipment Man")
                {
                    ApplicationArea = all;
                }
                field("ETC Serial No"; Rec."ETC Serial No")
                {
                    ApplicationArea = all;
                }
                field(Floor; Rec.Floor)
                {
                    ApplicationArea = all;
                }
                field("Fuel Type"; Rec."Fuel Type")
                {
                    ApplicationArea = all;
                }
                field("Functional Location"; Rec."Functional Location")
                {
                    ApplicationArea = all;
                }
                field("Installation Date"; Rec."Installation Date")
                {
                    ApplicationArea = all;
                }
                field("Last active alert time"; Rec."Last active alert time")
                {
                    ApplicationArea = all;
                }
                field("Last Biennal Date"; Rec."Last Biennal Date")
                {
                    ApplicationArea = all;
                }
                field(Manufacturer; Rec.Manufacturer)
                {
                    ApplicationArea = all;
                }
                field("Manufacture Date"; Rec."Manufacture Date")
                {
                    ApplicationArea = all;
                }
                field(Manufacture; Rec.Manufacture)
                {
                    ApplicationArea = all;
                }
                field("Manufacture Detail"; Rec."Manufacture Detail")
                {
                    ApplicationArea = all;
                }
                field("Next 3 Monthly Date"; Rec."Next 3 Monthly Date")
                {
                    ApplicationArea = all;
                }
                field("Next 5 Weekly Date"; Rec."Next 5 Weekly Date")
                {
                    ApplicationArea = all;
                }
                field("Next 6 Monthly Date"; Rec."Next 6 Monthly Date")
                {
                    ApplicationArea = all;
                }
                field("Next Annual Date"; Rec."Next Annual Date")
                {
                    ApplicationArea = all;
                }
                field("OBS Sim No"; Rec."OBS Sim No")
                {
                    ApplicationArea = all;
                }
                field("On-Site Installed location"; Rec."On-Site Installed location")
                {
                    ApplicationArea = all;
                }
                field("Owning business Unit"; Rec."Owning business Unit")
                {
                    ApplicationArea = all;
                }
                field(Pressure; Rec.Pressure)
                {
                    ApplicationArea = all;
                }
                field("Registration Status"; Rec."Registration Status")
                {
                    ApplicationArea = all;
                }
                field("Room Location"; Rec."Room Location")
                {
                    ApplicationArea = all;
                }
                field("Safety Valve"; Rec."Safety Valve")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Status reason"; Rec."Status reason")
                {
                    ApplicationArea = all;
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = all;
                }
                field("Budgeted hours 3 Monthly"; Rec."Budgeted hours 3 Monthly")
                {
                    ApplicationArea = all;
                }
                field("Budgeted hours 4 Monthly"; Rec."Budgeted hours 4 Monthly")
                {
                    ApplicationArea = all;
                }
                field("Budgeted hours 5 Monthly"; Rec."Budgeted hours 5 Monthly")
                {
                    ApplicationArea = all;
                }
                field("Budgeted hours 6 Monthly"; Rec."Budgeted hours 6 Monthly")
                {
                    ApplicationArea = all;
                }
                field(Budgetedhrs6MntlyStmtrapaudit; Rec.Budgetedhrs6MntlyStmtrapaudit)
                {
                    ApplicationArea = all;
                }
                field("Budgeted hours AS2593"; Rec."Budgeted hours AS2593")
                {
                    ApplicationArea = all;
                }
                field("Budgeted hours for annual"; Rec."Budgeted hours for annual")
                {
                    ApplicationArea = all;
                }
                field(BudgetedhrsforbiennialSerice; Rec.BudgetedhrsforbiennialSerice)
                {
                    ApplicationArea = all;
                }
                field("Budgeted hrs 3steam trap audit"; Rec."Budgeted hrs 3steam trap audit")
                {
                    ApplicationArea = all;
                }
                field(Owner; Rec.Owner)
                {
                    ApplicationArea = all;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
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