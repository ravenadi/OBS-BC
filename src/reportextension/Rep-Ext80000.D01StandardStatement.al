reportextension 80000 "D01 Standard Statement" extends "Standard Statement"
{
    dataset
    {
        // Add changes to dataitems and columns here
        modify(Customer)
        {
            trigger OnAfterPreDataItem()
            var
                myInt: Integer;
            begin
                Customer.SetFilter("No.", CustomerSelection);
                if Customer.FindSet() then;
            end;
        }

    }

    requestpage
    {
        layout
        {
            addafter(ShowOverdueEntries)
            {
                field("Customer"; CustomerSelection)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Customer.SetFilter("No.", CustomerSelection);
                        Customer.SetRecFilter();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        myInt: Integer;
                    begin
                        CustomerSelection := GetSelectedCustomers();
                        Customer.SetFilter("No.", CustomerSelection);
                        Customer.SetRecFilter();
                    end;

                }
            }
        }

    }

    rendering
    {
        layout(LayoutName)
        {
            Type = RDLC;
            LayoutFile = 'mylayout.rdl';
        }
    }

    var
        CustomerSelection, G_CustomerSelection : Code[200];

    procedure GetSelectedCustomers(): Text
    var
        Customer: Record Customer;
        TempCustomer: Record Customer;
        CustomerList: Text;
        CustomerPage: Page "Customer List";
    begin
        // Open Customer List Page
        CustomerPage.LookupMode(true);
        CustomerPage.SetTableView(Customer);
        if CustomerPage.RunModal() = Action::LookupOK then begin
            // Capture the selected records into a temporary table
            CustomerPage.SetSelectionFilter(TempCustomer);

            if TempCustomer.FindSet() then begin
                repeat
                    if CustomerList = '' then
                        CustomerList := TempCustomer."No."
                    else
                        CustomerList += '|' + TempCustomer."No.";
                until TempCustomer.Next() = 0;
            end;
        end;
        exit(CustomerList);
    end;

}