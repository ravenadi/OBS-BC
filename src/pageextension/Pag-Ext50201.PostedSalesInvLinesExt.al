pageextension 50201 "Posted Sales Inv Lines Ext" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addafter("Description")
        {
            // GkbLabs_Tv_15/12/25
            field("Job Task No."; Rec."Job Task No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job Task Number for the sales invoice line.';
            }
            field("G/L Account No."; Rec."G/L Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the G/L Account No.';
            }
            field("Transaction No."; Rec."Transaction No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Transaction No. from Customer Ledger Entry';
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the sell-to customer';
            }
            field("G/L Account Name"; Rec."G/L Account Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the G/L Account Name from Chart of Accounts';
            }
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the GST Amount (Amount Including VAT - Amount)';
            }
            field("Cancelled"; Rec."Cancelled")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the invoice is cancelled';
            }
        }
    }

    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        GLAccount: Record "G/L Account";
        SalesInvoiceHeader: Record "Sales Invoice Header";

    trigger OnAfterGetRecord()
    begin
        // Transaction No. from Customer Ledger Entry
        CustomerLedgerEntry.Reset();
        CustomerLedgerEntry.SetRange("Document Type", CustomerLedgerEntry."Document Type"::Invoice);
        CustomerLedgerEntry.SetRange("Document No.", Rec."Document No.");
        CustomerLedgerEntry.SetRange("Customer No.", Rec."Sell-to Customer No.");
        if CustomerLedgerEntry.FindLast() then
            Rec."Transaction No." := CustomerLedgerEntry."Transaction No.";

        // Customer Name
        if Customer.Get(Rec."Sell-to Customer No.") then
            Rec."Customer Name" := Customer.Name;

        // G/L Account Name
        if GLAccount.Get(Rec."G/L Account No.") then
            Rec."G/L Account Name" := GLAccount.Name;

        // GST Amount
        Rec."GST Amount" := Rec."Amount Including VAT" - Rec.Amount;

        // Cancelled from Sales Invoice Header
        if SalesInvoiceHeader.Get(Rec."Document No.") then
            Rec."Cancelled" := SalesInvoiceHeader.Cancelled;
    end;
}
