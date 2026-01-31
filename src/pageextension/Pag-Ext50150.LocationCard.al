pageextension 50150 "Location Card" extends "Location Card"
{
    layout
    {
        modify(City)
        {
            Visible = false;
        }
        modify(County)
        {
            visible = false;
        }
        modify("Country/Region Code")
        {
            visible = false;
        }
        modify("Post Code")
        {
            visible = false;
        }
        modify("Address 2")
        {
            Visible = true;
            ApplicationArea = all;
        }
        addbefore(Address)
        {
            field("Address Name"; Rec."Address Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = all;
            }
            field("D365 City"; Rec."D365 City")
            {
                ApplicationArea = all;
            }
            field("D365 Country"; Rec."D365 Country")
            {
                ApplicationArea = all;
            }
            field("D365 State"; Rec."D365 State")
            {
                ApplicationArea = all;
            }
            field("D365 Post Code"; Rec."D365 Postal Code")
            {
                ApplicationArea = all;
            }
            field("Crm Id"; Rec."Crm Id")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Crm Id field.', Comment = '%';
            }
            field(Owner; Rec.Owner)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
            }

        }
    }
    actions
    {
        addlast(navigation)
        {
            action(UpadateCRM)
            {
                Caption = 'Update To CRM';
                ApplicationArea = All;
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update this to CRM';

                trigger OnAction()
                var
                    CustomerCRM: Codeunit "Location Crm Management";
                begin
                    CustomerCRM.UpdateLocationToCRM(Rec);
                    Message('Successfully updated in CRM.');
                end;
            }
        }
    }
    trigger OnOpenPage();
    var
        UserSetupRec: Record "User Setup";
        IsUserAllowed: Boolean;
    begin
        if UserSetupRec.Get(UserId()) then begin
            IsUserAllowed := UserSetupRec.Location;
        end else begin
            IsUserAllowed := false;
        end;

        if not IsUserAllowed then
            CurrPage.Editable(false);
    end;
}

