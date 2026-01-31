reportextension 50100 "Aged Acc Rec. Excel Custom" extends "EXR Aged Accounts Rec Excel"
{

    dataset
    {
        // Add changes to dataitems and columns here
        add(AgingData)
        {
            column(CustomerPONo; CustomerPONo)
            {
            }
            column(workOrder; workOrdNo)
            {
            }
            column(PreAss; PreAssNo)
            {
            }
            column(NoOfDays; NoOfDays)
            {
            }
            column(Bucket_1_30; Bucket_1_30)
            {
            }
            column(Bucket_31_60; Bucket_31_60)
            {
            }
            column(Bucket_61_90; Bucket_61_90)
            {
            }

            column(Bucket_91_120; Bucket_91_120)
            {
            }
            column(Bucket_Over120; Bucket_Over120)
            {
            }

        }
        modify(agingData)
        {
            trigger OnAfterPreDataItem()
            var
                myInt: Integer;
            begin
                Clear(G_PreAssNo);
            end;

            trigger OnAfterAfterGetRecord()
            var
                SalesInvoiceHeader: Record "Sales Invoice Header";
                SalesInvoiceHeader1: Record "Sales Invoice Header";
                CustLedEntry: Record "Cust. Ledger Entry";
            begin
                Clear(workOrdNo);
                Clear(PreAssNo);
                Clear(SalesInvoiceHeader);
                Clear(SalesInvoiceHeader1);
                Clear(CustLedEntry);

                // DCS::HP24112025 ++
                G_PreAssNo := "Document No.";
                PreAssNo := "Document No.";
                if "Document No." = '' then
                    PreAssNo := G_PreAssNo;
                if SalesInvoiceHeader.get("Document No.") then begin
                    CustomerPONo := SalesInvoiceHeader."Customer PO Number";
                    // PreAssNo := SalesInvoiceHeader."Pre-Assigned No.";
                    // SalesInvoiceHeader.CalcFields("Job No.");
                    //DCS::HK 14112025 ++
                    workOrdNo := SalesInvoiceHeader."Blanket Sales Order No.";
                    //DCS::HK 14112025 --
                    // DCS::HP24112025 --
                end else begin
                    CustomerPONo := '';
                end;
                Clear(NoOfDays);
                if EndingDate > "Due Date" then
                    NoOfDays := EndingDate - "Due Date";
                Bucket_1_30 := 0;
                Bucket_31_60 := 0;
                Bucket_61_90 := 0;
                Bucket_91_120 := 0;
                Bucket_Over120 := 0;

                if NoOfDays > 0 then begin
                    if NoOfDays <= 30 then
                        Bucket_1_30 := "Remaining Amount (LCY)"
                    else if NoOfDays <= 60 then
                        Bucket_31_60 := "Remaining Amount (LCY)"
                    else if NoOfDays <= 90 then
                        Bucket_61_90 := "Remaining Amount (LCY)"
                    else if NoOfDays <= 120 then
                        Bucket_91_120 := "Remaining Amount (LCY)"
                    else
                        Bucket_Over120 := "Remaining Amount (LCY)";
                end;
            end;
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout("Aged Acc Rec. Excel Custom")

        {
            Type = Excel;
            LayoutFile = 'src/Layout/AgedAccountsReceivableExcel.xlsx';

        }
    }
    var
        // CustomerPONo: Code[20];
        CustomerPONo: Text[100];
        NoOfDays: Integer;
        Bucket_1_30: Decimal;
        Bucket_31_60: Decimal;
        Bucket_61_90: Decimal;
        Bucket_91_120: Decimal;
        Bucket_Over120: Decimal;
        workOrdNo: Text[100];
        PreAssNo: Text[100];
        G_PreAssNo: Text[100];
}
// reportextension 50100 "Aged Acc Rec. Excel Custom" extends "EXR Aged Accounts Rec Excel"
// {
//     dataset
//     {
//         add(AgingData)
//         {
//             column(CustomerPONo; CustomerPONo) { }
//             column(NoOfDays; NoOfDays) { }
//             column(Bucket_1_30; Bucket_1_30) { }
//             column(Bucket_31_60; Bucket_31_60) { }
//             column(Bucket_61_90; Bucket_61_90) { }
//             column(Bucket_91_120; Bucket_91_120) { }
//             column(Bucket_Over120; Bucket_Over120) { }
//         }

//         modify(AgingData)
//         {
//             trigger OnAfterAfterGetRecord()
//             var
//                 SalesInvoiceHeader: Record "Sales Invoice Header";
//             begin
//                 Clear(SalesInvoiceHeader);
//                 if SalesInvoiceHeader.Get("Document No.") then
//                     CustomerPONo := SalesInvoiceHeader."Customer PO Number"
//                 else
//                     CustomerPONo := '';

//                 Clear(NoOfDays);
//                 if EndingDate > "Due Date" then
//                     NoOfDays := EndingDate - "Due Date";

//                 Bucket_1_30 := 0;
//                 Bucket_31_60 := 0;
//                 Bucket_61_90 := 0;
//                 Bucket_91_120 := 0;
//                 Bucket_Over120 := 0;

//                 if NoOfDays > 0 then begin
//                     if NoOfDays <= 30 then
//                         Bucket_1_30 := "Remaining Amount (LCY)"
//                     else if NoOfDays <= 60 then
//                         Bucket_31_60 := "Remaining Amount (LCY)"
//                     else if NoOfDays <= 90 then
//                         Bucket_61_90 := "Remaining Amount (LCY)"
//                     else if NoOfDays <= 120 then
//                         Bucket_91_120 := "Remaining Amount (LCY)"
//                     else
//                         Bucket_Over120 := "Remaining Amount (LCY)";
//                 end;
//             end;
//         }
//     }

//     rendering
//     {
//         layout("Aged Acc Rec. Excel Custom")
//         {
//             Type = Excel;
//             LayoutFile = 'src/Layout/AgedAccountsReceivableExcel.xlsx';
//         }
//     }

//     var
//         CustomerPONo: Code[20];
//         NoOfDays: Integer;
//         Bucket_1_30: Decimal;
//         Bucket_31_60: Decimal;
//         Bucket_61_90: Decimal;
//         Bucket_91_120: Decimal;
//         Bucket_Over120: Decimal;
// }
