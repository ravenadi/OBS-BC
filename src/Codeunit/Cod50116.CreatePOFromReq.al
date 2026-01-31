// codeunit 50116 "Create PO From Req"
// {
//     Subtype = Normal;
//     // DCS::HP 12082025 ++
//     trigger OnRun()
//     var
//         ReqLine: Record "Requisition Line";
//     begin
//         ReqLine.Reset();
//         ReqLine.SetRange("PO Created", false);
//         ReqLine.SetRange(StatusReq, ReqLine.StatusReq::Released);
//         if ReqLine.Findset() then
//             repeat
//                 CreatePOFromReq(ReqLine);
//             until ReqLine.Next() = 0;
//     end;

//     // DCS::HP 12082025 --
//     procedure CreatePOFromReq(Rec: Record "Requisition Line")
//     var
//         ReqLine: Record "Requisition Line";
//         PurchaseHeader: Record "Purchase Header";
//         PurchLine: Record "Purchase Line";
//         NewPurchNo: Code[20];
//         FromDocumentAttachment: Record "Document Attachment";
//         FromDocumentAttachment2: Record "Document Attachment";
//         ToDocumentAttachment: Record "Document Attachment";
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//     begin
//         ReqLine.Reset();
//         ReqLine.SetRange("Vendor No.", Rec."Vendor No.");
//         ReqLine.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
//         ReqLine.SetRange("PO Created", false);
//         ReqLine.SetRange(StatusReq, ReqLine.StatusReq::Released);
//         if ReqLine.FindSet() then begin
//             PurchaseHeader.Init();
//             PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
//             PurchaseHeader.Insert(true);
//             PurchaseHeader.Validate("Buy-from Vendor No.", ReqLine."Vendor No.");
//             PurchaseHeader.Validate("Posting Date", Today);
//             PurchaseHeader.Validate("Gen. Bus. Posting Group", ReqLine."Gen. Business Posting Group");
//             PurchaseHeader.Validate("Location Code", ReqLine."Location Code");
//             PurchaseHeader.validate("Shortcut Dimension 1 Code", ReqLine."Shortcut Dimension 1 Code");
//             PurchaseHeader.Modify(true);
//             NewPurchNo := PurchaseHeader."No.";
//         end;
//         repeat
//             PurchLine.Init();
//             PurchLine."Document Type" := PurchLine."Document Type"::Order;
//             PurchLine."Document No." := NewPurchNo;
//             PurchLine.Type := PurchLine.Type::Item;
//             PurchLine."Line No." := GetNextPurchLineNo(PurchaseHeader);
//             PurchLine.Validate("No.", ReqLine."No."); // Item No.
//             PurchLine.Validate(Quantity, ReqLine.Quantity);
//             PurchLine.Validate("Unit of Measure Code", ReqLine."Unit of Measure Code");
//             PurchLine.Validate("Direct Unit Cost", ReqLine."Direct Unit Cost");
//             PurchLine.Validate("Shortcut Dimension 1 Code", ReqLine."Shortcut Dimension 1 Code");
//             PurchLine.Validate("Job No.", ReqLine."ProjectNo");
//             PurchLine.Validate("Job Task No.", ReqLine."Project Task No");
//             if PurchLine."Shortcut Dimension 1 Code" <> '' then
//                 PurchaseHeader.Validate("Shortcut Dimension 1 Code", ReqLine."Shortcut Dimension 1 Code");
//             PurchLine.Insert(true);

//             // Copy Attachments (Req Line → Purchase Header)
//             FromDocumentAttachment.SetRange("Table ID", Database::"Requisition Line");
//             FromDocumentAttachment.SetRange("No.", ReqLine."No.");
//             if FromDocumentAttachment.FindSet() then
//                 repeat
//                     Clear(ToDocumentAttachment);
//                     ToDocumentAttachment.Init();
//                     ToDocumentAttachment.TransferFields(FromDocumentAttachment);
//                     ToDocumentAttachment.Validate("Table ID", Database::"Purchase Header");
//                     ToDocumentAttachment.Validate("No.", NewPurchNo);
//                     ToDocumentAttachment.Validate("Document Type", Enum::"Attachment Document Type"::Order);
//                     if not ToDocumentAttachment.Insert(true) then;
//                     ToDocumentAttachment."Attached Date" := FromDocumentAttachment."Attached Date";
//                     ToDocumentAttachment.Modify();
//                 until FromDocumentAttachment.Next() = 0;
//             // Delete attachments from Requisition Line once copied
//             FromDocumentAttachment2.SetRange("Table ID", Database::"Requisition Line");
//             FromDocumentAttachment2.SetRange("No.", ReqLine."No.");
//             if FromDocumentAttachment2.FindSet() then
//                 FromDocumentAttachment2.DeleteAll();
//             ReqLine."PO Created" := true;
//             ReqLine.Modify(true);
//             ReqLine.Delete();
//             Commit();
//         until ReqLine.Next() = 0;

//         // Send Purchase Order for Approval
//         PurchaseHeader.Reset();
//         PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
//         PurchaseHeader.SetRange("No.", NewPurchNo);
//         if PurchaseHeader.FindFirst() then begin
//             if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchaseHeader) then
//                 ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchaseHeader);
//         end;
//         // if Dialog.Confirm('Purchase Order Created. Do you want to open the Purchase Order?', true, NewPurchNo) then begin
//         //     PurchaseHeader.Reset();
//         //     PurchaseHeader.SetRange("No.", NewPurchNo);
//         //     if PurchaseHeader.FindFirst() then
//         //         Page.RunModal(Page::"Purchase Order", PurchaseHeader);
//         // end;
//     end;

//     local procedure GetNextPurchLineNo(var PurchHeader: Record "Purchase Header"): Integer
//     var
//         PurchLine: Record "Purchase Line";
//     begin
//         PurchLine.SetRange("Document Type", PurchHeader."Document Type"::Order);
//         PurchLine.SetRange("Document No.", PurchHeader."No.");
//         if PurchLine.FindLast() then
//             exit(PurchLine."Line No." + 10000)
//         else
//             exit(10000);
//     end;
// }

// DCS:: HP 05042025 ++
codeunit 50116 "Create PO From Req"
{
    Subtype = Normal;
    trigger OnRun()
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.Reset();
        ReqLine.SetRange("PO Created", false);
        ReqLine.SetRange(StatusReq, ReqLine.StatusReq::Released);
        if ReqLine.FindSet() then
            CreatePOFromReq(ReqLine);
    end;

    procedure CreatePOFromReq(var Rec: Record "Requisition Line")
    var
        ReqLine: Record "Requisition Line";
        ReqLineGroup: Record "Requisition Line";
        PurchaseHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        NewPurchNo: Code[20];
        FromDocumentAttachment: Record "Document Attachment";
        FromDocumentAttachment2: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        VendorNo: Code[20];
        LocationCode: Code[10];
        DimensionCode: Code[20];
        PurchaseHeaderNoList: List of [Code[20]];
        Part: Code[20];
        MessageText: Text;
        Index: Integer;
    begin
        Clear(PurchaseHeaderNoList);
        // DCS::HP 10092025 ++
        if (rec.Quantity = 0) OR (rec."Location Code" = '') OR (rec."Shortcut Dimension 1 Code" = '') then
            Error('Cannot create a Purchase Order Line because Quantity, Warehouse or Obrien Business unit code for item %1 cannot be empty.', rec."No.");
        // DCS::HP 10092025 --

        // Group by Vendor, Location, and Dimension
        ReqLine.Reset();
        ReqLine.SetCurrentKey("Vendor No.", "Location Code", "Shortcut Dimension 1 Code");
        ReqLine.SetRange("PO Created", false);
        ReqLine.SetRange(StatusReq, ReqLine.StatusReq::Released);

        if ReqLine.FindSet() then begin
            repeat
                if ReqLine."Default PO" then begin
                    NewPurchNo := CreatePurchaseHeaderForGroup(ReqLine);
                    PurchaseHeaderNoList.Add(NewPurchNo);
                end else begin
                    if (ReqLine."Vendor No." <> VendorNo) or
                       (ReqLine."Location Code" <> LocationCode) or
                       (ReqLine."Shortcut Dimension 1 Code" <> DimensionCode) then begin
                        NewPurchNo := CreatePurchaseHeaderForGroup(ReqLine);
                        VendorNo := ReqLine."Vendor No.";
                        LocationCode := ReqLine."Location Code";
                        DimensionCode := ReqLine."Shortcut Dimension 1 Code";
                        PurchaseHeaderNoList.Add(NewPurchNo);
                    end;
                end;
                CreatePurchaseLineForGroup(NewPurchNo, ReqLine);
                ReqLine."PO Created" := true;
                ReqLine.Modify();
                ReqLine.Delete();
            until ReqLine.Next() = 0;
            // Process approvals for all created purchase orders
            foreach Part in PurchaseHeaderNoList do begin
                PurchaseHeader.Reset();
                PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
                PurchaseHeader.SetRange("No.", Part);
                if PurchaseHeader.FindFirst() then begin
                    if ApprovalsMgmt.CheckPurchaseApprovalPossible(PurchaseHeader) then
                        ApprovalsMgmt.OnSendPurchaseDocForApproval(PurchaseHeader);
                end;
            end;
            if PurchaseHeaderNoList.Count > 0 then begin
                MessageText := 'Purchase Order(s) created with No.: ';
                Index := 1;
                foreach Part in PurchaseHeaderNoList do begin
                    if StrLen(MessageText) > 100 then begin
                        MessageText += '...';
                        break;
                    end;
                    MessageText += Part;
                    if Index < PurchaseHeaderNoList.Count then
                        MessageText += ', ';
                    Index += 1;
                end;
                Message(MessageText);
            end;
        end;
    end;

    local procedure CreatePurchaseHeaderForGroup(ReqLine: Record "Requisition Line"): Code[20]
    var
        PurchaseHeader: Record "Purchase Header";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();
        PurchaseHeader.Init();
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.Insert(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", ReqLine."Vendor No.");
        PurchaseHeader.Validate("Posting Date", Today);
        PurchaseHeader.Validate("Gen. Bus. Posting Group", ReqLine."Gen. Business Posting Group");
        PurchaseHeader.Validate("Location Code", ReqLine."Location Code");
        PurchaseHeader.Validate("Shortcut Dimension 1 Code", ReqLine."Shortcut Dimension 1 Code");
        PurchaseHeader.validate("Ordered By", ReqLine."Requested By Name");
        PurchaseHeader.Modify(true);
        exit(PurchaseHeader."No.");
    end;

    local procedure CreatePurchaseLineForGroup(PurchaseHeaderNo: Code[20]; var ReqLine: Record "Requisition Line")
    var
        PurchLine: Record "Purchase Line";
        FromDocumentAttachment: Record "Document Attachment";
        FromDocumentAttachment2: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
    begin
        PurchLine.Init();
        PurchLine."Document Type" := PurchLine."Document Type"::Order;
        PurchLine."Document No." := PurchaseHeaderNo;
        PurchLine."Line No." := GetNextPurchLineNo(PurchaseHeaderNo);
        PurchLine.Type := PurchLine.Type::Item;
        PurchLine.Validate("No.", ReqLine."No."); // Item No.
        PurchLine.Validate(Quantity, ReqLine.Quantity);
        PurchLine.Validate("Unit of Measure Code", ReqLine."Unit of Measure Code");
        PurchLine.Validate("Direct Unit Cost", ReqLine."Direct Unit Cost");
        PurchLine.Validate("Shortcut Dimension 1 Code", ReqLine."Shortcut Dimension 1 Code");
        PurchLine.Validate("Job No.", ReqLine."ProjectNo");
        // DCS::HP 031025 ++
        PurchLine.validate("Job Line Type", PurchLine."Job Line Type"::"Both Budget and Billable");
        // DCS::HP 031025 --
        PurchLine.Validate("Job Task No.", ReqLine."Project Task No");
        // DCS::HP13112025 ++
        PurchLine.Validate("Ordered By", ReqLine."Requested By Name");
        PurchLine.Validate("Gen. Bus. Posting Group", ReqLine."Gen. Business Posting Group");
        // DCS::HP13112025 ++
        PurchLine.Insert(true);
        PurchLine.Modify(true);
        // Copy Attachments (Req Line → Purchase Header)
        FromDocumentAttachment.Reset();
        FromDocumentAttachment.SetRange("Table ID", Database::"Requisition Line");
        if FromDocumentAttachment.IsEmpty() then
            exit;
        FromDocumentAttachment.SetRange("No.", ReqLine."No.");
        FromDocumentAttachment.SetRange("Line No.", ReqLine."Line No.");
        if FromDocumentAttachment.FindSet() then
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init();
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", Database::"Purchase Line");
                ToDocumentAttachment.Validate("Document Type", Enum::"Attachment Document Type"::Order);
                ToDocumentAttachment.Validate("No.", PurchaseHeaderNo);
                ToDocumentAttachment.Validate("Line No.", PurchLine."Line No.");
                if not ToDocumentAttachment.Insert(true) then;
                ToDocumentAttachment."Attached Date" := FromDocumentAttachment."Attached Date";
                ToDocumentAttachment.Modify();
            until FromDocumentAttachment.Next() = 0;
        FromDocumentAttachment2.reset();
        FromDocumentAttachment2.SetRange("Table ID", Database::"Requisition Line");
        FromDocumentAttachment2.SetRange("No.", ReqLine."No.");
        FromDocumentAttachment2.SetRange("Line No.", ReqLine."Line No.");
        if FromDocumentAttachment2.FindSet() then
            FromDocumentAttachment2.DeleteAll();
    end;

    local procedure GetNextPurchLineNo(PurchaseHeaderNo: Code[20]): Integer
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchaseHeaderNo);
        if PurchLine.FindLast() then
            exit(PurchLine."Line No." + 10000)
        else
            exit(10000);
    end;
}
// DCS:: HP 05042025 --