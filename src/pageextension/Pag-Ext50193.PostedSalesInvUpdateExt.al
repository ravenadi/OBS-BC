namespace GKBCustomizationOCT.GKBCustomizationOCT;

using Microsoft.Sales.History;

pageextension 50193 "Posted Sales Inv. - Update Ext" extends "Posted Sales Inv. - Update"
{
    layout
    {
        addafter("Promised Pay Date")
        {

            field(Description; WorkDescription1)
            {
                ApplicationArea = Basic, Suite;
                Importance = Additional;
                MultiLine = true;
                // visible = false;
                // ShowCaption = false;
                Caption = 'Description';
                ToolTip = 'Specifies the products or service being offered';

                trigger OnValidate()
                var
                    CodeunitWork: Codeunit MyCodeunit;
                begin
                    // Rec.SetWorkDescription1(WorkDescription1);
                    CodeunitWork.SetWorkDescription1(Rec, WorkDescription1);
                end;
            }
            //DCS::HK 28102025++
            // field("Customer PO Number"; Rec."Customer PO Number")
            field("Customer PO Number"; CustPONum)//DCS::HK 28102025--
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer PO Number field.', Comment = '%';
                // DCS::HK 28102025++
                trigger OnValidate()
                var
                    CodeunitWork: Codeunit MyCodeunit;
                begin
                    CodeunitWork.SetCustPONum(Rec."No.", CustPONum);
                end;
                // DCS::HK 28102025++
            }
        }
    }
    // DCS::HK 13102025 ++
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        WorkDescription1 := Rec.GetWorkDescription1();
        //DCS::HK 28102025++
        CustPONum := rec."Customer PO Number";
        //DCS::HK 28102025--
    end;

    var
        //DCS::HK 28102025++
        CustPONum: text;
        //DCS::HK 28102025-
        WorkDescription1: Text;

    // DCS::HK 13102025 --
}
