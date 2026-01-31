namespace GKBCustomizationsept.GKBCustomizationsept;

enum 50108 "Task Status1"
{
    Extensible = true;
    value(0; Unscheduled) { Caption = 'Unscheduled'; }
    value(1; Scheduled) { Caption = 'Scheduled'; }
    value(2; "In Progress") { Caption = 'In Progress'; }
    value(3; Completed) { Caption = 'Completed'; }
    value(4; Invoiced) { Caption = 'Invoiced'; }
    value(5; Cancelled) { Caption = 'Cancelled'; }
}