codeunit 50103 "Create Customer From Vendor"
{
    procedure HandleVendorModification(var Rec: Record Vendor; var xRec: Record Vendor)
    var
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        Customer: Record Customer;
        CustomerTemplate: Record "Customer Templ.";
        CustomerTemplMgt: Codeunit "Customer Templ. Mgt.";
        CompanyContact: Record Contact;
        IsHandled: Boolean;
    begin
        if not FindCompanyContact(Rec."No.", CompanyContact) then begin
            CreateCompanyContact(Rec, CompanyContact);
        end;
        if not CustomerExistsForVendor(Rec."No.", Customer) then begin
            if CustomerTemplMgt.SelectCustomerTemplate(CustomerTemplate) then begin
                Clear(Customer);
                CustomerTemplMgt.CreateCustomerFromTemplate(Customer, IsHandled, CustomerTemplate.Code);
                if Customer."No." <> '' then begin

                    TransferVendorDataToCustomer(Rec, Customer);
                    LinkCustomerToVendor(Customer."No.", Rec."No.");
                    Message('Customer %1 has been created and linked to Vendor %2', Customer."No.", Rec."No.");
                end;
            end else
                Error('No customer template selected.');
        end else
            Message('A customer already exists for this vendor.');
    end;



    local procedure FindCompanyContact(VendorNo: Code[20]; var CompanyContact: Record Contact): Boolean
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);
        ContactBusinessRelation.SetRange("No.", VendorNo);
        if ContactBusinessRelation.FindFirst() then begin
            CompanyContact.Get(ContactBusinessRelation."Contact No.");
            exit(true);
        end;
        exit(false);
    end;

    local procedure CreateCompanyContact(Vendor: Record Vendor; var CompanyContact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        CompanyContact.Init();
        CompanyContact.Type := CompanyContact.Type::Company;
        CompanyContact."Company No." := '';
        CompanyContact.Name := Vendor.Name;
        CompanyContact.Address := Vendor.Address;
        CompanyContact."Address 2" := Vendor."Address 2";
        CompanyContact.City := Vendor.City;
        CompanyContact."Post Code" := Vendor."Post Code";
        CompanyContact."Country/Region Code" := Vendor."Country/Region Code";
        CompanyContact."Phone No." := Vendor."Phone No.";
        CompanyContact."E-Mail" := Vendor."E-Mail";
        CompanyContact.Insert(true);

        // Create business relation
        ContactBusinessRelation.Init();
        ContactBusinessRelation."Contact No." := CompanyContact."No.";
        ContactBusinessRelation."Business Relation Code" := 'Vendor';  // Make sure this code exists
        ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Vendor;
        ContactBusinessRelation."No." := Vendor."No.";
        ContactBusinessRelation.Insert(true);
    end;

    local procedure CustomerExistsForVendor(VendorNo: Code[20]; var Customer: Record Customer): Boolean
    begin
        Customer.SetRange("Vendor No.", VendorNo);
        exit(Customer.FindFirst());
    end;

    local procedure LinkCustomerToVendor(CustomerNo: Code[20]; VendorNo: Code[20])
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        if Customer.Get(CustomerNo) then begin
            Customer.Validate("Vendor No.", VendorNo);
            Customer.Modify(true);
        end;
    end;

    local procedure TransferVendorDataToCustomer(var Vendor: Record Vendor; var Customer: Record Customer)
    begin
        Customer.Validate(Name, Vendor.Name);
        Customer.Validate(Address, Vendor.Address);
        Customer.Validate("Address 2", Vendor."Address 2");
        Customer.Validate("D365 City", Vendor."D365 City");
        Customer.Validate("D365 State", Vendor."D365 State");
        Customer.Validate("D365 Post Code", Vendor."D365 Postal Code");
        Customer.Validate("D365 Country", Vendor."D365 Country");
        Customer.Validate("Phone No.", Vendor."Phone No.");
        Customer.Validate("E-Mail", Vendor."E-Mail");
        Customer.Validate("VAT Registration No.", Vendor."VAT Registration No.");
        Customer.Validate("Gen. Bus. Posting Group", Vendor."Gen. Bus. Posting Group");
        Customer.Validate("VAT Bus. Posting Group", Vendor."VAT Bus. Posting Group");
        Customer.Validate("Payment Terms Code", Vendor."Payment Terms Code");
        Customer.Validate("Currency Code", Vendor."Currency Code");
        Customer.Validate("Language Code", Vendor."Language Code");
        Customer.Modify(true);
    end;
}
