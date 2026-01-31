// DCS::HP18112025 ++
pageextension 50196 "Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Shortcut Dimension 1 Code" = '' then begin
                    Error('The Obrien Business Unit Code must have a value');
                    exit
                end;
            end;
        }
    }
}
// DCS::HP18112025 --