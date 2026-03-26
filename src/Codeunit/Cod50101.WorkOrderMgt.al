codeunit 50101 "Work Order Mgt."
{
    [EventSubscriber(ObjectType::Table, Database::"Work Order Lines", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertWOLns(var Rec: Record "Work Order lines"; RunTrigger: Boolean)
    var
    begin
        CreateJobTaskLinesFromWOLs(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Work Order", 'OnAfterInsertEvent', '', false, false)]

    local procedure OnAfterInsertWOs(var Rec: Record "Work Order"; RunTrigger: Boolean)
    var
        Job: Code[20];
        JobTask: Code[20];
    begin
        if Rec."Job Created" then
            exit;
        // if (Rec."Topic" <> '') and
        //    (Rec."Work Order Type" <> '') and
        //    (Rec."Work Order No." <> '') and
        //    (Rec."Service Account" <> '') then begin
        // if JobNotExistForWO(Rec) then
        CreateJobFromWO(Rec);
        // end;
    end;

    local procedure CreateJobTaskLinesFromWOLs(var WOLn: Record "Work Order Lines")
    var
        PlanningLine: Record "Job Planning Line";
        PlanningLinePre: Record "Job Planning Line";
        JobPlanningLine: Record "Job Planning Line";
        Job: Record Job;
        JobTask: Record "Job Task";
        Rec: Record "Work Order lines";
        JobPlanningLinesToPost: Record "Job Planning Line";
        bincontent: Record "Bin Content";
        JobJnlLine: Record "Job Journal Line";
        JobTransferLine: Codeunit "Job Transfer Line";
        JobPlanningLineToPost: Record "Job Planning Line";
        JobJournalSetup: Record "Job Journal Setup";
        JobJournalSetupPag: Page "Job Journal Setup";
        Item: Record item;
        location: Record Location;
        FindRec: Boolean;
    begin
        if WOLn."Line Created" then
            exit;
        // DCS::HP02122025 ++ Production Comment
        // Clear(FindRec);

        // if WOLn."Project Task Number" <> '' then begin
        //     PlanningLinePre.Reset();
        //     PlanningLinePre.SetRange("Job No.", WOLn."Job No.");
        //     // PlanningLinePre.SetRange("Line No.", WOLn."Line No.");
        //     PlanningLinePre.SetRange("Job Task No.", WOLn."Project Task Number");
        //     if PlanningLinePre.FindFirst() then
        //         FindRec := true
        //     else begin
        //         JobTask.Reset();
        //         JobTask.SetRange("Job No.", WOLn."Job No.");
        //         JobTask.SetRange("Job Task No.", WOLn."Project Task Number");
        //         if JobTask.FindFirst() then
        //             FindRec := true
        //         else
        //             FindRec := false;
        //     end;
        // end;
        // DCS::HP02122025 --

        PlanningLine.Init();//Init
        PlanningLine."Line No." := WOLn."Line No.";
        PlanningLine."Job No." := WOLn."Job No.";
        //GkbLabs_Tv_10/02/2026 ++ changed Job Task No. to Project Task No. as per the GKB requirement
        PlanningLine."Job Task No." := ResolveJobTaskNo(WOLn);
        // Store Project Task Number in Project Sub-Task No. field for reference
        PlanningLine."Project Sub-Task No." := WOLn."Project Task Number";
        // Production Comment
        // if FindRec then
        //     PlanningLine."Job Task No." := WOLn."Project Task Number"
        // else
        //     PlanningLine."Job Task No." := WOLn."Work Order No.";
        // DCS::HP01122025++
        // PlanningLine.Validate("Project Sub-Task No.", WOLn."Project Task Number");
        // DCS::HP01122025--
        case WOLn.Type of
            WOLn.Type::Resource:
                PlanningLine.Type := PlanningLine.Type::Resource;
            WOLn.Type::Item:
                PlanningLine.Type := PlanningLine.Type::Item;
            WOLn.Type::"G/L Account":
                PlanningLine.Type := PlanningLine.Type::"G/L Account";
            else
                exit;
        end;
        PlanningLine."No." := WOLn.Code;
        // DCS:: HP 20252107 ++uncommented below line type line as per the GKB requirement
        PlanningLine."Line Type" := PlanningLine."Line Type"::"Both Budget and Billable";      // Have to Create a Description field in both Job Plaing amnd Work Order lines
        PlanningLine.Validate("Line Type");
        // DCS:: HP 20252107 --
        PlanningLine.Description := WOLn.Description;
        PlanningLine.Owner := Woln.Owner;
        // DCS:: HP 20252107 ++
        // PlanningLine.Quantity := WOLn."Quantity to Build";
        PlanningLine.validate("Usage Link", true);
        PlanningLine.validate(Quantity, WOLn."Quantity to Build");
        // DCS:: HP 20252107 --
        PlanningLine.Validate("Unit Cost", WOLn."Unit Cost");
        PlanningLine."Service Duration" := WOLn."Service Duration";
        PlanningLine."Planning Date" := WOLn."Work Start Time";
        PlanningLine."Planned Delivery Date" := WOLn."Work End Time";
        PlanningLine."Location Code" := WOLn."Location Code";
        // DCS::HP-20250723++
        if (PlanningLine.Type = PlanningLine.Type::Item) and (PlanningLine."No." <> '') and (PlanningLine."Location Code" <> '') then begin
            if Item.Get(PlanningLine."No.") then begin
                if location.Get(PlanningLine."Location Code") and location."Bin Mandatory" then begin
                    BinContent.Reset();
                    BinContent.SetRange("Item No.", PlanningLine."No.");
                    BinContent.SetRange("Location Code", PlanningLine."Location Code");
                    BinContent.SetFilter("Quantity (Base)", '>0');
                    // if not BinContent.FindFirst() then
                    //     BinContent.SetRange("Quantity (Base)");
                    if BinContent.FindFirst() then
                        PlanningLine."Bin Code" := BinContent."Bin Code"
                    else
                        Message('Bin Code is mandatory for location %1',
                                  PlanningLine."Location Code");
                end;
            end;
        end;
        // DCS::HP-20250723--

        PlanningLine.Insert(true);//Insert
        PlanningLine.validate("Unit Price", WOLn."Unit amount");
        PlanningLine.Modify(true);
        WOLn."Line Created" := true;
        WOLn.Modify();
        // DCS::HP-20250723++
        CreateProjectJournalLinesAutomatically(PlanningLine);
        // DCS::HP-20250723--
    end;

    procedure JobNotExistForWO(var WO: Record "Work Order"): Boolean
    var
        Job: Record Job;
        JobTask: Record "Job Task";
    begin
        job.Reset();
        Job.SetRange("Service Account", WO."Service Account");
        Job.SetRange("Work Order Type", WO."Work Order Type");

        if not Job.FindFirst() then
            exit(true);
        JobTask.Reset();
        JobTask.SetRange("Job No.", Job."No.");
        JobTask.SetRange("Job Task No.", JobTask."Job Task No.");
        if not JobTask.FindFirst() then begin
            JobTask.Init();
            JobTask.Validate("Job No.", Job."No.");
            JobTask.Validate("Job Task No.", WO."Work Order No.");
            JobTask.Description := WO."Topic";
            JobTask.Insert();

            if WO."Job No." = '' then
                WO."Job No." := Job."No.";
            WO."Project Task No" := JobTask."Job Task No.";
            WO."Job Created" := true;
            WO.Modify();
            Message('Job Task Updated %1 to Job %2', WO."Work Order No.", WO."Job No.");
        end;

        exit(false);
    end;

    procedure CreateJobFromWO(WO: Record "Work Order")
    var
        Job: Record Job;
        JobTask: Record "Job Task";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        Job.Init();
        //Job."No." := NoSeriesMgt.GetNextNo('JOB', 0D, true);
        //Job.Description := WO."Service Account" + ' - ' + WO."Work Order Type";
        Job."No." := WO."Work Order No.";
        Job.Description := WO."Topic";
        Job."Case Custom" := WO."Case Custom";
        Job."Service Account" := WO."Service Account";
        Job."Work Order Type" := WO."Work Order Type";
        Job.Validate("Sell-to Customer No.", WO."Service Account");
        Job."Bill-to Customer No." := WO."Service Account";
        // DCS::HP02122025 ++
        Job."CRM ID" := WO."CRM ID";
        // DCS::HP02122025 --
        job.Owner := Wo.Owner;
        case WO."System Status" of
            // WO."System Status"::" ":
            //     Job."System Status" := Job."System Status"::" ";
            WO."System Status"::Unscheduled:
                Job."System Status" := Job."System Status"::Unscheduled;
            WO."System Status"::Scheduled:
                Job."System Status" := Job."System Status"::Scheduled;
            WO."System Status"::"In Progress":
                Job."System Status" := job."System Status"::"In Progress";
            WO."System Status"::Completed:
                Job."System Status" := Job."System Status"::Completed;
            WO."System Status"::Invoiced:
                Job."System Status" := Job."System Status"::Invoiced;
            WO."System Status"::Cancelled:
                Job."System Status" := Job."System Status"::Cancelled;
            else
                exit;
        end;
        Job.Validate("System Status");
        Job."Sales Order" := WO."Sales Order";
        // HP::DCS 061025 ++
        job."Primary Incident Type" := WO."Primary Incident Type";
        job."SAP Service ID" := WO."SAP Service ID";
        job.Agreement := WO.Agreement;
        job."Parent Work Order" := WO."Parent Work Order";
        // HP::DCS 061025 --
        Job."Sales Order" := WO."Blanket Order";
        Job."Starting Date" := WO."Time Window Start";
        // DCS::HP 081025 ++
        Job."D365 Ending Date" := WO."D365 Ending Date";
        Job."Ending Date" := WO."Time Window End";
        // DCS::HP 081025 --
        case WO."Billing Type" of
            WO."Billing Type"::" ":
                Job."Billing Type" := Job."Billing Type"::" ";
            WO."Billing Type"::"Charge Up":
                Job."Billing Type" := Job."Billing Type"::"Charge Up";
            WO."Billing Type"::"Quoted":
                Job."Billing Type" := Job."Billing Type"::"Quoted";
            WO."Billing Type"::"Monthly Billing":
                Job."Billing Type" := Job."Billing Type"::"Monthly Billing";
            WO."Billing Type"::"Not Chargeable":
                Job."Billing Type" := Job."Billing Type"::"Not Chargeable";
            WO."Billing Type"::"N/A":
                Job."Billing Type" := Job."Billing Type"::"N/A";
            else
                exit;
        end;
        Job."Customer PO Number" := WO."Customer PO Number";
        Job."Case Custom" := WO."Case Custom";
        Job."Substatus" := WO.Substatus;
        // DCS::HP 09092025 HP ++
        // Job."Global Dimension 1 Code" := WO."Shortcut Dimension 1 Code";
        Job."Full Topic" := WO."Full Topic"; //pk 24OCt2025
        job."Apply Usage Link" := true; //DCS::HP 20252207 added link line
        Job.Insert(true);
        Job.validate("Global Dimension 1 Code", WO."Shortcut Dimension 1 Code");
        job.Modify(true);
        Message('Job card created with no %1', Job."No.");

        // Create Job Task for the new Job
        JobTask.Init();
        JobTask."Job No." := Job."No.";
        JobTask."Job Task No." := WO."Work Order No.";
        JobTask.Validate("Sell-to Customer No.", WO."Service Account");
        JobTask."Bill-to Customer No." := WO."Service Account";
        JobTask.Description := WO."Topic";
        JobTask."Fix Type" := WO."Fix Type";
        JobTask."Functional Location" := WO."Functional Location";
        // JobTask.validate("Global Dimension 1 Code", WO."Shortcut Dimension 1 Code");
        JobTask."Global Dimension 1 Code" := WO."Shortcut Dimension 1 Code";
        JobTask.Opportunity := WO."Opportunity";
        JobTask."Parent Task No." := WO."Parent Work Order";
        JobTask."Start Date" := WO."Time Window Start";
        JobTask."End Date" := WO."Time Window End";
        JobTask."Work Order Type" := WO."Work Order Type";
        case WO."Billing Type" of
            WO."Billing Type"::" ":
                JobTask."Billing Type" := JobTask."Billing Type"::" ";
            WO."Billing Type"::"Charge Up":
                JobTask."Billing Type" := JobTask."Billing Type"::"Charge Up";
            WO."Billing Type"::"Quoted":
                JobTask."Billing Type" := JobTask."Billing Type"::"Quoted";
            WO."Billing Type"::"Monthly Billing":
                JobTask."Billing Type" := JobTask."Billing Type"::"Monthly Billing";
            WO."Billing Type"::"Not Chargeable":
                JobTask."Billing Type" := JobTask."Billing Type"::"Not Chargeable";
            WO."Billing Type"::"N/A":
                JobTask."Billing Type" := JobTask."Billing Type"::"N/A";
            else
                exit;
        end;
        JobTask."Description 2" := WO."Description 2";
        JobTask.Substatus := WO.Substatus;
        case WO."System Status" of
            // WO."System Status"::" ":
            //     JobTask."System Status" := JobTask."System Status"::" ";
            WO."System Status"::Unscheduled:
                JobTask."System Status" := JobTask."System Status"::Unscheduled;
            WO."System Status"::Scheduled:
                JobTask."System Status" := JobTask."System Status"::Scheduled;
            WO."System Status"::"In Progress":
                JobTask."System Status" := job."System Status"::"In Progress";
            WO."System Status"::Completed:
                JobTask."System Status" := JobTask."System Status"::Completed;
            WO."System Status"::Invoiced:
                JobTask."System Status" := JobTask."System Status"::Invoiced;
            WO."System Status"::Cancelled:
                JobTask."System Status" := JobTask."System Status"::Cancelled;
            else
                exit;
        end;
        Job.Validate("System Status");
        // JobTask."Sales Order" := WO."Sales Order";
        JobTask."Customer PO Number" := WO."Customer PO Number";
        JobTask."Work Order Summary" := WO."Work Order Summary";
        JobTask.Insert(true);

        if WO."Job No." = '' then
            WO.Validate("Job No.", Job."No.");                     //Modified
        WO."Project Task No" := JobTask."Job Task No.";
        WO."Job Created" := true;
        WO.Modify(true);
    end;


    // Code for when modification occurs.
    [EventSubscriber(ObjectType::Table, Database::"Work Order", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyWO(var Rec: Record "Work Order"; var xRec: Record "Work Order"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if Rec."Job Created" and (Rec."Job No." <> '') then
            UpdateJobFromWO(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Work Order Lines", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyWOLns(var Rec: Record "Work Order Lines"; var xRec: Record "Work Order Lines"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;

        if Rec."Line Created" and (Rec."Job No." <> '') then
            UpdateJobPlanningLineFromWOLn(Rec, xRec);
    end;

    local procedure UpdateJobFromWO(var WO: Record "Work Order"; var xWO: Record "Work Order")
    var
        Job: Record Job;
        JobTask: Record "Job Task";
    begin
        // Update Job Header
        if not Job.Get(WO."Job No.") then
            exit;

        // DCS::HP02122025 ++
        if WO."CRM ID" <> xWO."CRM ID" then
            job."CRM ID" := wo."CRM ID";
        // DCS::HP02122025 --

        if WO.topic <> xWO.Topic then
            Job.Description := WO."Topic";

        if WO."Work Order Type" <> xWO."Work Order Type" then
            Job."Work Order Type" := WO."Work Order Type";

        if WO."Service Account" <> xWO."Service Account" then
            Job.Validate("Sell-to Customer No.", WO."Service Account");
        // DCS::HP 09092025 HP ++
        if (WO."Shortcut Dimension 1 Code" <> xWO."Shortcut Dimension 1 Code") then
            // Job.Validate("Global Dimension 1 Code" , WO."Shortcut Dimension 1 Code");
            Job."Global Dimension 1 Code" := WO."Shortcut Dimension 1 Code";
        // DCS::HP 09092025 HP --

        if WO."System Status" <> xWO."System Status" then
            case WO."System Status" of
                // WO."System Status"::" ":
                //     Job."System Status" := Job."System Status"::" ";
                WO."System Status"::Unscheduled:
                    Job."System Status" := Job."System Status"::Unscheduled;
                WO."System Status"::Scheduled:
                    Job."System Status" := Job."System Status"::Scheduled;
                WO."System Status"::"In Progress":
                    Job."System Status" := job."System Status"::"In Progress";
                WO."System Status"::Completed:
                    Job."System Status" := Job."System Status"::Completed;
                WO."System Status"::Invoiced:
                    Job."System Status" := Job."System Status"::Invoiced;
                WO."System Status"::Cancelled:
                    Job."System Status" := Job."System Status"::Cancelled;
            end;
        Job.Validate("System Status");

        if (WO."Sales Order" <> xWO."Sales Order") then
            Job."Sales Order" := WO."Sales Order";

        if (WO."Time Window Start" <> xWO."Time Window Start") then
            Job."Starting Date" := WO."Time Window Start";

        if (WO."Owner" <> xWO."Owner") then
            Job."Owner" := WO."Owner";

        if (WO."Time Window End" <> xWO."Time Window End") then
            // DCS::HP 081025 ++
            // Job."Ending Date" := WO."Time Window End";
            Job."D365 Ending Date" := WO."D365 Ending Date";
        // DCS::HP 081025 --

        if WO."Billing Type" <> xWO."Billing Type" then
            case WO."Billing Type" of
                WO."Billing Type"::" ":
                    Job."Billing Type" := Job."Billing Type"::" ";
                WO."Billing Type"::"Charge Up":
                    Job."Billing Type" := Job."Billing Type"::"Charge Up";
                WO."Billing Type"::"Quoted":
                    Job."Billing Type" := Job."Billing Type"::"Quoted";
                WO."Billing Type"::"Monthly Billing":
                    Job."Billing Type" := Job."Billing Type"::"Monthly Billing";
                WO."Billing Type"::"Not Chargeable":
                    Job."Billing Type" := Job."Billing Type"::"Not Chargeable";
                WO."Billing Type"::"N/A":
                    Job."Billing Type" := Job."Billing Type"::"N/A";
            end;

        if (WO."Customer PO Number" <> xWO."Customer PO Number") then
            Job."Customer PO Number" := WO."Customer PO Number";

        if (WO.Substatus <> xWO.Substatus) then
            Job."Substatus" := WO.Substatus;
        Job.validate("Sales Order", WO."Sales Order");
        Job.Validate("Sales Order", WO."Blanket Order");
        Job."Full Topic" := Wo."Full Topic";//PK 24OCT2025
        // Modify the job with updated values
        Job.Modify(true);

        // Update Job Task
        if not JobTask.Get(WO."Job No.", WO."Work Order No.") then
            exit;

        // Update Job Task fields that may have changed
        if (WO."Topic" <> xWO."Topic") then
            JobTask.Description := WO."Topic";

        if (WO."Service Account" <> xWO."Service Account") then
            JobTask.Validate("Sell-to Customer No.", WO."Service Account");

        if (WO."Fix Type" <> xWO."Fix Type") then
            JobTask."Fix Type" := WO."Fix Type";
        if (WO."Functional Location" <> xWO."Functional Location") then
            JobTask."Functional Location" := WO."Functional Location";

        if (WO."Shortcut Dimension 1 Code" <> xWO."Shortcut Dimension 1 Code") then
            JobTask."Global Dimension 1 Code" := WO."Shortcut Dimension 1 Code";

        if (WO."Opportunity" <> xWO."Opportunity") then
            JobTask.Opportunity := WO."Opportunity";

        if (WO."Parent Work Order" <> xWO."Parent Work Order") then
            JobTask."Parent Task No." := WO."Parent Work Order";

        if (WO."Time Window Start" <> xWO."Time Window Start") then
            JobTask."Start Date" := WO."Time Window Start";

        if (WO."Time Window End" <> xWO."Time Window End") then
            JobTask."End Date" := WO."Time Window End";

        if (WO."Billing Type" <> xWO."Billing Type") then
            case WO."Billing Type" of
                WO."Billing Type"::" ":
                    JobTask."Billing Type" := JobTask."Billing Type"::" ";
                WO."Billing Type"::"Charge Up":
                    JobTask."Billing Type" := JobTask."Billing Type"::"Charge Up";
                WO."Billing Type"::"Quoted":
                    JobTask."Billing Type" := JobTask."Billing Type"::"Quoted";
                WO."Billing Type"::"Monthly Billing":
                    JobTask."Billing Type" := JobTask."Billing Type"::"Monthly Billing";
                WO."Billing Type"::"Not Chargeable":
                    JobTask."Billing Type" := JobTask."Billing Type"::"Not Chargeable";
                WO."Billing Type"::"N/A":
                    JobTask."Billing Type" := JobTask."Billing Type"::"N/A";
            end;

        if (WO."Description 2" <> xWO."Description 2") then
            JobTask."Description 2" := WO."Description 2";

        if (WO.Substatus <> xWO.Substatus) then
            JobTask.Substatus := WO.Substatus;

        if (WO."System Status" <> xWO."System Status") then
            case WO."System Status" of
                // WO."System Status"::" ":
                //     JobTask."System Status" := JobTask."System Status"::" ";
                WO."System Status"::Unscheduled:
                    JobTask."System Status" := JobTask."System Status"::Unscheduled;
                WO."System Status"::Scheduled:
                    JobTask."System Status" := JobTask."System Status"::Scheduled;
                WO."System Status"::"In Progress":
                    JobTask."System Status" := JobTask."System Status"::"In Progress";
                WO."System Status"::Completed:
                    JobTask."System Status" := JobTask."System Status"::Completed;
                WO."System Status"::Invoiced:
                    JobTask."System Status" := JobTask."System Status"::Invoiced;
                WO."System Status"::Cancelled:
                    JobTask."System Status" := JobTask."System Status"::Cancelled;
            end;

        if (WO."Customer PO Number" <> xWO."Customer PO Number") then
            JobTask."Customer PO Number" := WO."Customer PO Number";

        if (WO."Work Order Summary" <> xWO."Work Order Summary") then
            JobTask."Work Order Summary" := WO."Work Order Summary";


        // Modify the job task with updated values
        JobTask.Modify(true);
    end;

    local procedure UpdateJobPlanningLineFromWOLn(var WOLn: Record "Work Order Lines"; var xWOLn: Record "Work Order Lines")
    var
        PlanningLine: Record "Job Planning Line";
    begin
        PlanningLine.Reset();
        PlanningLine.SetRange("Job No.", WOLn."Job No.");
        PlanningLine.SetRange("Job Task No.", ResolveJobTaskNo(WOLn));
        PlanningLine.SetRange("Line No.", WOLn."Line No.");

        if not PlanningLine.FindFirst() then
            exit;

        if (WOLn.Type <> xWOLn.Type) then
            case WOLn.Type of
                WOLn.Type::Resource:
                    PlanningLine.Type := PlanningLine.Type::Resource;
                WOLn.Type::Item:
                    PlanningLine.Type := PlanningLine.Type::Item;
                WOLn.Type::"G/L Account":
                    PlanningLine.Type := PlanningLine.Type::"G/L Account";
            end;

        PlanningLine.Validate("No.", WOLn.Code);
        PlanningLine.Validate(Description, WOLn.Description);
        PlanningLine.Validate("Location Code", WOLn."Location Code");
        PlanningLine.Validate(Quantity, WOLn."Quantity to Build");
        PlanningLine.Validate("Unit Cost", WOLn."Unit Cost");
        PlanningLine."Unit Price" := WOLn."Unit amount";
        PlanningLine.Validate("Planning Date", WOLn."Work Start Time");
        PlanningLine.Validate("Planned Delivery Date", WOLn."Work End Time");
        // DCS::HP01122025++ Production Comment
        PlanningLine.Validate("Project Sub-Task No.", WOLn."Project Task Number");
        // DCS::HP01122025--

        PlanningLine.Modify(true);
    end;

    // DCS::HP20250723++ added auto posting procedures

    local procedure CreateProjectJournalLinesAutomatically(var JobPlanningLine: Record "Job Planning Line")
    var
        JobJnlLine: Record "Job Journal Line";
        JobTransferLine: Codeunit "Job Transfer Line";
        JobPlanningLineToPost: Record "Job Planning Line";
        JobJournalSetup: Record "Job Journal Setup";
        JobJournalSetupPag: Page "Job Journal Setup";
        JobNo: code[10];
        SkippedLines: Text;
    begin
        if not JobJournalSetup.Get() then
            JobJournalSetup.Init();
        if JobJournalSetup."Journal Template" = '' then
            error('Job Journal Template must be specified in Job Journal Setup');
        if JobJournalSetup."Journal Batch" = '' then
            error('Job Journal Batch must be specified in Job Journal Setup');
        JobPlanningLineToPost.Copy(JobPlanningLine);
        JobNo := JobPlanningLineToPost."Job No.";
        JobPlanningLineToPost.SetRange("Job No.", JobPlanningLine."Job No.");
        JobPlanningLineToPost.SetRange("Job Task No.", JobPlanningLine."Job Task No.");
        // 🔹 ONLY auto-post Both Budget and Billable
        JobPlanningLineToPost.SetRange(
            "Line Type",
            JobPlanningLineToPost."Line Type"::"Both Budget and Billable");
        JobPlanningLineToPost.SetFilter(Type, '<>%1', JobPlanningLineToPost.Type::Text);

        //GkbLabs_Tv_17/03/2026 ++
        // Pre-check: collect Item lines with no inventory — warn user but DO NOT block other lines
        SkippedLines := '';
        if JobPlanningLineToPost.FindSet() then
            repeat
                if (JobPlanningLineToPost.Type = JobPlanningLineToPost.Type::Item) and
                   (JobPlanningLineToPost.Quantity > 0) and
                   (JobPlanningLineToPost."Qty. to Transfer to Journal" = 0) then
                    SkippedLines += '\- Line ' + Format(JobPlanningLineToPost."Line No.") +
                                    ': Item ' + JobPlanningLineToPost."No." +
                                    ' at Location ' + JobPlanningLineToPost."Location Code" +
                                    ' (Qty: ' + Format(JobPlanningLineToPost.Quantity) + ')';
            until JobPlanningLineToPost.Next() = 0;

        if SkippedLines <> '' then
            Message('Warning: The following Item lines have no inventory and will be skipped.\' +
                    'Please check stock and post manually from Project Journal:\' +
                    SkippedLines);
        //GkbLabs_Tv_17/03/2026 --

        if JobPlanningLineToPost.FindSet() then
            repeat
                if (JobPlanningLineToPost."Line Type" = JobPlanningLineToPost."Line Type"::"Both Budget and Billable") and
                   (JobPlanningLineToPost."Qty. to Transfer to Journal" <> 0) then begin
                    JobTransferLine.FromPlanningLineToJnlLine(
                        JobPlanningLineToPost,
                        WorkDate(),
                        JobJournalSetup."Journal Template",
                        JobJournalSetup."Journal Batch",
                        JobJnlLine);
                end;
            until JobPlanningLineToPost.Next() = 0;
        Commit();
        PostJobJournal(
           JobJournalSetup."Journal Template",
           JobJournalSetup."Journal Batch", JobNo);
        // Message('Successfully posted Project lines');
    end;

    local procedure PostJobJournal(JournalTemplateName: Code[10]; JournalBatchName: Code[10]; DocumentNo: Code[10])
    var
        JobJnlSetup: Record "Job Journal Setup";
        JobJnlLine: Record "Job Journal line";
        JobJnlPost: Codeunit "Job Jnl.-Post";
        LineCount: Integer;
    begin
        if not JobJnlSetup.Get() then
            Error('Job Journal Setup must be configured before posting.');
        JobJnlLine.Reset();
        JobJnlLine.SetRange("Job No.", DocumentNo);
        JobJnlLine.SetRange("Journal Template Name", JobJnlSetup."Journal Template");
        JobJnlLine.SetRange("Journal Batch Name", JobJnlSetup."Journal Batch");
        // Commit();
        if not JobJnlLine.IsEmpty() then begin
            LineCount := JobJnlLine.Count();
            if JobJnlLine.FindSet() then
                // JobJnlLine.DeleteAll();
                if not JobJnlPost.Run(JobJnlLine) then
                    Error('Posting failed: %1', GetLastErrorText());
            Message('%1 journal lines posted successfully.', LineCount);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post", OnCodeOnBeforeConfirm, '', false, false)]
    local procedure "Job Jnl.-Post_OnCodeOnBeforeConfirm"(JobJnlLine: Record "Job Journal Line"; var IsHandled: Boolean)
    var
        JobJnlSetup: Record "Job Journal Setup";
    begin
        JobJnlSetup.Get();
        if (JobJnlLine."Journal Template Name" = JobJnlSetup."Journal Template") and (JobJnlLine."Journal Batch Name" = JobJnlSetup."Journal Batch") then
            IsHandled := true;
    end;
    // DCS::HP-20250723 --
    //GkbLabs_Tv_10/02/2026 ++ new procedure to resolve job task no. from work order line
    local procedure ResolveJobTaskNo(WOLn: Record "Work Order Lines"): Code[20]
    var
        JobTask: Record "Job Task";
        IncomingTask: Code[20];
        ChildTask: Code[20];
    begin
        IncomingTask := WOLn."Project Task Number"; // e.g. S1

        if IncomingTask = '' then
            exit(WOLn."Work Order No.");

        // 1️⃣ Try EXACT match first (S1)
        JobTask.Reset();
        JobTask.SetRange("Job No.", WOLn."Job No.");
        JobTask.SetRange("Job Task No.", IncomingTask);
        if JobTask.FindFirst() then
            exit(IncomingTask);

        // 2️⃣ Try appending .01 (S1.01)
        ChildTask := IncomingTask + '.01';
        JobTask.Reset();
        JobTask.SetRange("Job No.", WOLn."Job No.");
        JobTask.SetRange("Job Task No.", ChildTask);
        if JobTask.FindFirst() then
            exit(ChildTask);

        // 3️⃣ Absolute fallback
        exit(WOLn."Work Order No.");
    end;
}