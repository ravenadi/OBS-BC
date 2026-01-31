namespace GKBCustomization.GKBCustomization;
// YK
page 50154 StandardStatementDialog
{
     PageType = StandardDialog;
    SourceTable = StandardStatementDialogBuffer;
    Caption = 'Statement Date Range';
    Editable = true;
    SaveValues = true;
    layout
    {
        area(content)
        {
            group(Group)
            {
                field(StartDate; GStartDate)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
                field(EndDate; Rec.EndDate)
                {
                    Editable = true;
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CurrPage.Editable(true);
    end;

    trigger OnClosePage()
    var
        myInt: Integer;
    begin
        GStartDate := Rec.StartDate;
        GEndDate := Rec.EndDate;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        // GStartDate := Rec.StartDate;
        GEndDate := Rec.EndDate;
        GetFilterDate();
    end;

    var
        GStartDate: Date;
        GEndDate: Date;

    procedure GetFilterDate()
    var
        DialogPage: Record StandardStatementDialogBuffer;
    begin
        DialogPage.Reset();
        if DialogPage.Findset() then begin
            DialogPage.DeleteAll();
        end;
        DialogPage.Init();
        DialogPage.StartDate := GStartDate;
        DialogPage.EndDate := GEndDate;
        DialogPage.Insert();

    end;
}
