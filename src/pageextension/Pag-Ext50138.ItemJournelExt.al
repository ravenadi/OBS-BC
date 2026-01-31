pageextension 50138 "Item Journel Ext" extends "Item Journal"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
                Caption = 'Comment';
            }
        }
        modify("Location Code")
        {
            ShowMandatory = true;

        }
        addafter("Location Code")
        {
            field("Item Availability By Location"; Rec."Item Availability By Location")
            {
                ApplicationArea = all;
                ToolTip = 'Shows the Item availibilty by Location Code';
            }
        }
    }

    // DCS:: HP 20250718 Action disabled
    // actions
    // {
    //     modify(Post)
    //     {
    //         trigger OnBeforeAction()           // If the Location is QLD, NSW, VIC and WA then Obrien Business Unit Code is Mandatory. If any other value no need
    //         var
    //             Location: Record Location;
    //         begin
    //             if Rec.IsTemporary then
    //                 exit;

    //             Location.SetRange(Code, rec."Location Code");
    //             if Location.FindFirst then begin
    //                 if (Location.Name.Contains('NSW') or Location.Name.Contains('QLD') or Location.Name.Contains('VIC') or Location.Name.Contains('WA')) then begin
    //                     if Rec."Shortcut Dimension 1 Code" = '' then
    //                         Error('Obrien Business Unit Code is mandatory for the Location: %1', Location.Name);
    //                 end;
    //             end;
    //         end;
    //     }
    // }
}