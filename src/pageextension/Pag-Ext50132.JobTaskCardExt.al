pageextension 50132 "Job Task Card Ext" extends "Job Task Card"
{
    layout
    {
        modify("Bill-to Customer No.")
        {
            ApplicationArea = All;
            Caption = 'Customer No.';
            Visible = true;
        }
        modify("Bill-to Name")
        {
            ApplicationArea = All;
            Caption = 'Customer Name';
            Visible = true;
        }
        addfirst(Posting)
        {
            field("Total Line Cost"; Rec."Total Line Cost")
            {
                ApplicationArea = all;
            }
            field("Total Line Amount"; Rec."Total Line Amount")
            {
                ApplicationArea = all;
            }
        }
        addafter(General)
        {
            group("Custom Fields")
            {
                Caption = 'Custom Fields';
                field("Billing Type"; Rec."Billing Type")
                {
                    ApplicationArea = All;
                    Caption = 'Billing Type';
                }
                field("Contact"; Rec."Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                }

                field("Fix Type"; Rec."Fix Type")
                {
                    ApplicationArea = All;
                    Caption = 'Fix Type';
                }

                field("Functional Location"; Rec."Functional Location")
                {
                    ApplicationArea = All;
                    Caption = 'Functional Location';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                }

                field("Work Order Type"; Rec."Work Order Type")
                {
                    ApplicationArea = All;
                    Caption = 'Work Order Type';
                    Visible = false;
                }

                field("Work Order Summary"; Rec."Work Order Summary")
                {
                    ApplicationArea = All;
                    Caption = 'Work Order Summary';
                    // DCS::HK 13102025 ++
                    MultiLine = true;
                    // DCS::HK 13102025 ++
                }
                field("Parent Task No."; Rec."Parent Task No.")
                {
                    ApplicationArea = all;
                    Caption = 'Parent Task No.';
                }
                field("System Status"; Rec."System Status")
                {
                    ApplicationArea = all;
                    Caption = 'System Status';
                    Visible = false;
                }
                field(Substatus; Rec.Substatus)
                {
                    ApplicationArea = all;
                    Caption = 'Substatus';
                    Visible = false;
                }
            }
        }
    }
}
