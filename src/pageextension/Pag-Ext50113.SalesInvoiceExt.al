pageextension 50113 "Sales Invoice Ext" extends "Sales Invoice"
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
            field("Sales Order No."; Rec."Sales Order No.")
            {
                ApplicationArea = All;
                Caption = 'Sales Order No.';
            }
            // DCS :: HJ20251028++
            // field("Job No."; Rec."Job No.")
            // {
            //     ApplicationArea = All;
            // }
            field("Blanket Sales Order No."; Rec."Blanket Sales Order No.")
            {
                ApplicationArea = All;
                TableRelation = "Sales Header"."No.";
                Editable = false;

                // trigger OnLookup("Blanket Sales Order No.")
                // var
                //     Job: Record Job;
                //     JobPageID: Integer;
                // begin
                //     JobPageID := Page::"Job Card"; 
                //     if Job.Get() then 
                //         PAGE.Run(JobPageID, Job);
                // end;
                trigger OnLookup(var Text: Text): Boolean
                var
                    Job: Record Job;
                begin
                    if PAGE.RunModal(Page::"Job List", Job) = ACTION::LookupOK then
                        PAGE.Run(Page::"Job Card", Job);
                    exit(true);
                end;


            }
            field("Full Topic"; Rec."Full Topic")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Full Topic field.', Comment = '%';
            }
            // DCS :: HJ20251028--

            field("Job Task No."; Rec."Job Task No")
            {
                ApplicationArea = All;
            }
            field("Customer PO Number"; Rec."Customer PO Number")
            {
                ApplicationArea = All;
            }

            field(Owner; Rec.Owner)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
            }
            // DCS::HK 13102025 ++


            group("Work Description 1")
            {
                Caption = 'Description';
                field(Description; WorkDescription1)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered';

                    trigger OnValidate()
                    begin
                        Rec.SetWorkDescription1(WorkDescription1);
                    end;
                }
            }
            // DCS::HK 13102025 --
        }
    }
    // DCS::HK 13102025 ++
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        item: Record Item;
    begin
        WorkDescription1 := Rec.GetWorkDescription1();
       
    end;

    var
        WorkDescription1: Text;

    // DCS::HK 13102025 --
}