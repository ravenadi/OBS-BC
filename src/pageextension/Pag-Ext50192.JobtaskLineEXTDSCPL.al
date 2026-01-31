namespace GKBCustomizationOCT.GKBCustomizationOCT;

using Microsoft.Projects.Project.Job;

pageextension 50192 "Job task Line EXT DSCPL" extends "Job Task Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Work Order Summary"; Rec."Work Order Summary")
            {
                ApplicationArea = all;
            }
        }
    }
}
