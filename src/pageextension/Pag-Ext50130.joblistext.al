

pageextension 50130 "job List Ext" extends "Job List"
{
    trigger OnOpenPage()
    begin
        Rec.SetCurrentKey("No.");
        rec.Ascending(false);
    end;
}


