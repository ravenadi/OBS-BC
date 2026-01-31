pageextension 50115 "Posted Sales Inv Ext" extends "Posted Sales Invoice"
{
    layout
    {
        // DCS::HK 13102025 ++
        modify("Work Description")
        {
            Visible = false;
        }
        // DCS::HK 13102025 --
        addlast(General)
        {
            field("Customer PO Number"; Rec."Customer PO Number")
            {
                ApplicationArea = All;
            }

            // DCS :: HJ20251028++
            // field("Job No."; Rec."Job No.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the value of the Work Order No. field.', Comment = '%';
            // }
            field("Blanket Sales Order No."; Rec."Blanket Sales Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Blanket Sales Order No. field.', Comment = '%';
            }
            // DCS :: HJ20251028--
            field(Owner; Rec.Owner)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
            }

            // DCS:: aaj
            field("Full Topic"; Rec."Full Topic")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Topic field.', Comment = '%';
            }
            //YK
            field("Cust. Ledger Entry No."; Rec."Cust. Ledger Entry No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cust. Ledger Entry No. field.', Comment = '%';
            }

            field("Delivery Docket No."; Rec."Delivery Docket No.")
            {
                ApplicationArea = All;
            }
            // DCS::HK 13102025 ++
            group("Description Group")
            {
                Caption = 'Description';
                field(Description; WorkDescription1)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered';
                    Editable = false;

                }
            }
            // DCS::HK 13102025 --
        }
        addafter("Bill-to Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = All;
            }
        }
    }
    // GkbLabs_Tv_29/12/25
    actions
    {
        modify(CorrectInvoice)
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        WorkDescription1 := Rec.GetWorkDescription1();
    end;


    var
        WorkDescription1: Text;
}