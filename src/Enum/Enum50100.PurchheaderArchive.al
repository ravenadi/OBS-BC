enum 50100 "Purch header Archive"
//enum 3812 "Purchase Document Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Deleted) { Caption = 'Deleted'; }
    value(1; Archived) { Caption = 'Archived'; }
    value(2; "Pending Approval") { Caption = 'Pending Approval'; }

}