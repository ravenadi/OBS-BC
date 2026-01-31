namespace GKBCustomizationsept.GKBCustomizationsept;

using Microsoft.Projects.Project.Job;
//This PAge is use for WEbservices please do not change without asking to rahul// comment by pankaj
page 50156 ProjectBI
{
    ApplicationArea = All;
    Caption = 'ProjectBI';
    PageType = List;
    SourceTable = Job;

    layout
    {
        area(Content)
        {

            repeater(Control1)
            {
                Caption = 'General';

                field("Allow Schedule/Contract Lines"; Rec."Allow Schedule/Contract Lines")
                {
                    ToolTip = 'Specifies if you can add planning lines of both type Budget and type Billable to the project.';
                }
                field("Applied Costs G/L Amount"; Rec."Applied Costs G/L Amount")
                {
                    ToolTip = 'Specifies the sum of all applied costs that is based on to the selected project in the general ledger.';
                }
                field("Applied Sales G/L Amount"; Rec."Applied Sales G/L Amount")
                {
                    ToolTip = 'Specifies the sum of all applied sales in the general ledger that are related to the project.';
                }
                field("Apply Usage Link"; Rec."Apply Usage Link")
                {
                    ToolTip = 'Specifies whether usage entries, from the project journal or purchase line, for example, are linked to project planning lines. Select this check box if you want to be able to track the quantities and amounts of the remaining work needed to complete a project and to create a relationship between demand planning, usage, and sales. On a project card, you can select this check box if there are no existing project planning lines that include type Budget that have been posted. The usage link only applies to project planning lines that include type Budget.';
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ToolTip = 'Specifies the address of the customer to whom you will send the invoice.';
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ToolTip = 'Specifies the city of the address.';
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    ToolTip = 'Specifies the name of the contact person at the customer who pays for the project.';
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    ToolTip = 'Specifies the number of the contact person at the customer''s billing address.';
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region code of the customer''s billing address.';
                }
                field("Bill-to County"; Rec."Bill-to County")
                {
                    ToolTip = 'Specifies the county code of the customer''s billing address.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer who pays for the project.';
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    ToolTip = 'Specifies the name of the customer that you send or sent the invoice or credit memo to.';
                }
                field("Bill-to Name 2"; Rec."Bill-to Name 2")
                {
                    ToolTip = 'Specifies the value of the Bill-to Name 2 field.', Comment = '%';
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ToolTip = 'Specifies the postal code of the customer who pays for the project.';
                }
                field("Billing Type"; Rec."Billing Type")
                {
                    ToolTip = 'Specifies the value of the Billing Type field.', Comment = '%';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ToolTip = 'Specifies a bin code for specific location of the project.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("Calc. Recog. Costs Amount"; Rec."Calc. Recog. Costs Amount")
                {
                    ToolTip = 'Specifies the sum of the recognized costs amount that is associated with project tasks for the project.';
                }
                field("Calc. Recog. Costs G/L Amount"; Rec."Calc. Recog. Costs G/L Amount")
                {
                    ToolTip = 'Specifies the sum of the recognized costs general ledger amount that is associated with project tasks for the project.';
                }
                field("Calc. Recog. Sales Amount"; Rec."Calc. Recog. Sales Amount")
                {
                    ToolTip = 'Specifies the sum of the recognized sales amount that is associated with project tasks for the project.';
                }
                field("Calc. Recog. Sales G/L Amount"; Rec."Calc. Recog. Sales G/L Amount")
                {
                    ToolTip = 'Specifies the sum of the recognized sales general ledger amount that is associated with project tasks for the project.';
                }
                field("Case Custom"; Rec."Case Custom")
                {
                    ToolTip = 'Specifies the value of the Case Custom field.', Comment = '%';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                field(Comments2; Rec.Comments2)
                {
                    ToolTip = 'Specifies the value of the Comments2 field.', Comment = '%';
                }
                field(Complete; Rec.Complete)
                {
                    ToolTip = 'Specifies the value of the Complete field.', Comment = '%';
                }
                field("Completely Picked"; Rec."Completely Picked")
                {
                    ToolTip = 'Specifies the value of the Completely Picked field.', Comment = '%';
                }
                field("Cost Calculation Method"; Rec."Cost Calculation Method")
                {
                    ToolTip = 'Specifies the default method of the unit cost calculation.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the date on which you set up the project.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the currency code for the project. By default, the currency code is empty. If you enter a foreign currency code, it results in the project being planned and invoiced in that currency.';
                }
                field("Customer Disc. Group"; Rec."Customer Disc. Group")
                {
                    ToolTip = 'Specifies the value of the Customer Disc. Group field.', Comment = '%';
                }
                field("Customer PO Number"; Rec."Customer PO Number")
                {
                    ToolTip = 'Specifies the value of the Customer PO Number field.', Comment = '%';
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ToolTip = 'Specifies the value of the Customer Price Group field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a short description of the project.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.', Comment = '%';
                }
                // DCS::HP24112025 ++ changed field caption from ending date to Closed on date
                field("Closed On Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the date on which the project is expected to be completed.';
                }
                // DCS::HP24112025 --
                // DCS::HP08122025 ++
                field("D365 Ending Date"; Rec."D365 Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.', Comment = '%';
                }
                // DCS::HP08122025 ++
                field("Exch. Calculation (Cost)"; Rec."Exch. Calculation (Cost)")
                {
                    ToolTip = 'Specifies how project costs are calculated if you change the Currency Date or the Currency Code fields on a project planning Line or run the Change Project Planning Line Dates batch job. Fixed LCY option: The project costs in the local currency are fixed. Any change in the currency exchange rate will change the value of project costs in a foreign currency. Fixed FCY option: The project costs in a foreign currency are fixed. Any change in the currency exchange rate will change the value of project costs in the local currency.';
                }
                field("Exch. Calculation (Price)"; Rec."Exch. Calculation (Price)")
                {
                    ToolTip = 'Specifies how project sales prices are calculated if you change the Currency Date or the Currency Code fields on a project planning Line or run the Change Project Planning Line Dates batch job. Fixed LCY option: The project prices in the local currency are fixed. Any change in the currency exchange rate will change the value of project prices in a foreign currency. Fixed FCY option: The project prices in a foreign currency are fixed. Any change in the currency exchange rate will change the value of project prices in the local currency.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.', Comment = '%';
                }
                field(Image; Rec.Image)
                {
                    ToolTip = 'Specifies the value of the Image field.', Comment = '%';
                }
                field("Invoice Created"; Rec."Invoice Created")
                {
                    ToolTip = 'Specifies the value of the Invoice Created field.', Comment = '%';
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    ToolTip = 'Specifies the currency code you want to apply when creating invoices for a project. By default, the invoice currency code for a project is based on what currency code is defined on the customer card.';
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    ToolTip = 'Specifies the posting group that links transactions made for the project with the appropriate general ledger accounts according to the general posting setup.';
                }
                field("Language Code"; Rec."Language Code")
                {
                    ToolTip = 'Specifies the language to be used on printouts for this project.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ToolTip = 'Specifies when the project card was last modified.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the location code of the project.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Next Invoice Date"; Rec."Next Invoice Date")
                {
                    ToolTip = 'Specifies the next invoice date for the project.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ToolTip = 'Specifies the value of the No. Series field.', Comment = '%';
                }
                field("No. of Archived Versions"; Rec."No. of Archived Versions")
                {
                    ToolTip = 'Specifies the number of archived versions of this project.';
                }
                field("Over Budget"; Rec."Over Budget")
                {
                    ToolTip = 'Specifies the value of the Over Budget field.', Comment = '%';
                }
                field(Owner; Rec.Owner)
                {
                    ToolTip = 'Specifies the value of the Owner field.', Comment = '%';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    ToolTip = 'Specifies the person at your company who is responsible for the project.';
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    ToolTip = 'Specifies the default method of the unit price calculation.';
                }
                field("Project Manager"; Rec."Project Manager")
                {
                    ToolTip = 'Specifies the person who is assigned to manage the project.';
                }
                field("Recog. Costs Amount"; Rec."Recog. Costs Amount")
                {
                    ToolTip = 'Specifies the recognized cost amount that was last calculated for the project. The value is the sum of the entries in the Recognized Cost Project WIP Entries window.';
                }
                field("Recog. Costs G/L Amount"; Rec."Recog. Costs G/L Amount")
                {
                    ToolTip = 'Specifies the total Recognized Cost amount that was last posted to the general ledger for the project. The Recognized Cost G/L amount for the project is the sum of the Recognized Cost Project WIP G/L Entries.';
                }
                field("Recog. Sales Amount"; Rec."Recog. Sales Amount")
                {
                    ToolTip = 'Specifies the recognized sales amount that was last calculated for the project, which is the sum of the Recognized Sales Project WIP Entries.';
                }
                field("Recog. Sales G/L Amount"; Rec."Recog. Sales G/L Amount")
                {
                    ToolTip = 'Specifies the total recognized sales amount that was last posted to the general ledger for the project. The recognized sales G/L amount for the project is the sum of the entries in the Recognized Sales Project WIP G/L Entries window.';
                }
                field(Reserve; Rec.Reserve)
                {
                    ToolTip = 'Specifies the value of the Reserve field.', Comment = '%';
                }
                field("Sales Order"; Rec."Sales Order")
                {
                    ToolTip = 'Specifies the value of the Blanket Order No. field.', Comment = '%';
                }
                field("Scheduled Res. Gr. Qty."; Rec."Scheduled Res. Gr. Qty.")
                {
                    ToolTip = 'Specifies the value of the Scheduled Res. Gr. Qty. field.', Comment = '%';
                }
                field("Scheduled Res. Qty."; Rec."Scheduled Res. Qty.")
                {
                    ToolTip = 'Specifies the value of the Scheduled Res. Qty. field.', Comment = '%';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ToolTip = 'Specifies an additional description of the project for searching purposes.';
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ToolTip = 'Specifies the address where the customer is located.';
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ToolTip = 'Specifies the name of the person to contact at the customer.';
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    ToolTip = 'Specifies the number of the contact person that the sales document will be sent to.';
                }
                field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                {
                    ToolTip = 'Specifies the country or region of the address.';
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ToolTip = 'Specifies the state, province or county of the address.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    ToolTip = 'Specifies the value of the Sell-to Customer Name 2 field.', Comment = '%';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    ToolTip = 'Specifies the value of the Email field.', Comment = '%';
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    ToolTip = 'Specifies the value of the Sell-to Phone No. field.', Comment = '%';
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    ToolTip = 'Specifies the postal code.';
                }
                field("Service Account"; Rec."Service Account")
                {
                    ToolTip = 'Specifies the value of the Service Account field.', Comment = '%';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ToolTip = 'Specifies the address that products on the sales document will be shipped to.';
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the code for another shipment address than the customer''s own address, which is entered by default.';
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ToolTip = 'Specifies the name of the contact person at the address that products on the sales document will be shipped to.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ToolTip = 'Specifies the customer''s country/region.';
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ToolTip = 'Specifies the state, province or county of the address.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the name that products on the sales document will be shipped to.';
                }
                field("Ship-to Name 2"; Rec."Ship-to Name 2")
                {
                    ToolTip = 'Specifies an additional part of the name that products on the sales document will be shipped to.';
                }
                field("Ship-to Phone No."; Rec."Ship-to Phone No.")
                {
                    ToolTip = 'Specifies the telephone number of the company''s shipping address.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ToolTip = 'Specifies the postal code.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the date on which the project actually starts.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies a current status of the project. You can change the status for the project as it progresses. Final calculations can be made on completed projects.';
                }
                field(Substatus; Rec.Substatus)
                {
                    ToolTip = 'Specifies the value of the Substatus field.', Comment = '%';
                }
                field("Task Billing Method"; Rec."Task Billing Method")
                {
                    ToolTip = 'Specify whether to use the customer specified for the project for all tasks or allow people to specify different customers. One customer lets you invoice only the customer specified for the project. Multiple customers lets you invoice customers specified on each task, which can be different customers.';
                }
                field("Total WIP Cost Amount"; Rec."Total WIP Cost Amount")
                {
                    ToolTip = 'Specifies the total WIP cost amount that was last calculated for the project. The WIP cost amount is the value in the WIP Cost Project WIP Entries window minus the value of the Recognized Cost Project WIP Entries window. For projects with Sales Value or Percentage of Completion WIP methods, the WIP cost amount is normally 0.';
                }
                field("Total WIP Cost G/L Amount"; Rec."Total WIP Cost G/L Amount")
                {
                    ToolTip = 'Specifies the total WIP Cost amount that was last posted to the G/L for the project. The WIP Cost Amount for the project is the value WIP Cost Project WIP G/L Entries less the value of the Recognized Cost Project WIP G/L Entries. For projects with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.';
                }
                field("Total WIP Sales Amount"; Rec."Total WIP Sales Amount")
                {
                    ToolTip = 'Specifies the total WIP sales amount that was last calculated for the project. The WIP sales amount is the value in the WIP Sales Project WIP Entries window minus the value of the Recognized Sales Project WIP Entries window. For projects with the Cost Value or Cost of Sales WIP methods, the WIP sales amount is normally 0.';
                }
                field("Total WIP Sales G/L Amount"; Rec."Total WIP Sales G/L Amount")
                {
                    ToolTip = 'Specifies the total WIP sales amount that was last posted to the general ledger for the project. The WIP sales amount is the value in the WIP Sales Project WIP G/L Entries window minus the value in the Recognized Sales Project WIP G/L Entries window. For projects with the Cost Value or Cost of Sales WIP methods, the WIP sales amount is normally 0.';
                }
                field("WIP Completion Calculated"; Rec."WIP Completion Calculated")
                {
                    ToolTip = 'Specifies the value of the WIP Completion Calculated field.', Comment = '%';
                }
                field("WIP Completion Posted"; Rec."WIP Completion Posted")
                {
                    ToolTip = 'Specifies the value of the WIP Completion Posted field.', Comment = '%';
                }
                field("WIP Entries Exist"; Rec."WIP Entries Exist")
                {
                    ToolTip = 'Specifies the value of the WIP Entries Exist field.', Comment = '%';
                }
                field("WIP G/L Posting Date"; Rec."WIP G/L Posting Date")
                {
                    ToolTip = 'Specifies the posting date that was entered when the Project Post WIP to General Ledger batch job was last run.';
                }
                field("WIP Method"; Rec."WIP Method")
                {
                    ToolTip = 'Specifies the method that is used to calculate the value of work in process for the project.';
                }
                field("WIP Posting Date"; Rec."WIP Posting Date")
                {
                    ToolTip = 'Specifies the posting date that was entered when the Project Calculate WIP batch job was last run.';
                }
                field("WIP Posting Method"; Rec."WIP Posting Method")
                {
                    ToolTip = 'Specifies how WIP posting is performed. Per Project: The total WIP costs and the sales value is used to calculate WIP. Per Project Ledger Entry: The accumulated values of WIP costs and sales are used to calculate WIP.';
                }
                field("WIP Warnings"; Rec."WIP Warnings")
                {
                    ToolTip = 'Specifies whether or not there are WIP warnings associated with a project.';
                }
                field("Work Order Type"; Rec."Work Order Type")
                {
                    ToolTip = 'Specifies the value of the Work Order Type field.', Comment = '%';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ToolTip = 'Specifies the customer''s reference. The content will be printed on sales documents.';
                }
                field("System Status"; Rec."System Status")
                { ToolTip = 'Specifies the'; }
            }
        }
    }
}
