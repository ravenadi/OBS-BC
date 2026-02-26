pageextension 50233 BankRecExt extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        modify("Document No.")
        {
            Visible = false;
        }

        addafter("Document No.")
        {
            field("Document No. Link"; Rec."Document No.")
            {
                ApplicationArea = All;

                trigger OnDrillDown()
                var
                    VendLedgEntry: Record "Vendor Ledger Entry";
                    CustLedgEntry: Record "Cust. Ledger Entry";
                begin
                    // Try Vendor Ledger Entry using Transaction No.
                    VendLedgEntry.SetRange("Transaction No.", Rec."Transaction No.");

                    if VendLedgEntry.FindFirst() then begin
                        Page.Run(Page::"Vendor Ledger Entries", VendLedgEntry);
                        exit;
                    end;

                    // Try Customer Ledger Entry using Transaction No.
                    CustLedgEntry.SetRange("Transaction No.", Rec."Transaction No.");

                    if CustLedgEntry.FindFirst() then begin
                        Page.Run(Page::"Customer Ledger Entries", CustLedgEntry);
                        exit;
                    end;

                    Message('No related vendor or customer ledger entry found.');
                end;
            }
        }
    }
}