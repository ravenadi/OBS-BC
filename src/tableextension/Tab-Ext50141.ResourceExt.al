tableextension 50141 "Resource Ext" extends Resource
{
    fields
    {
        field(50100; Comments2; Text[100])
        {
            Caption = 'Comments2';
            DataClassification = ToBeClassified;
        }
        field(50101; "CRM ID"; Text[200])
        {
            Caption = 'CRM ID';
            DataClassification = ToBeClassified;
        }
        // DCS::HP 11082025 ++
        field(50102; "Trade Type"; enum "Apprentice Level Extended")
        {
            // OptionMembers = "Service Engineer Dual Trade","First-Year Apprentice","Second-Year Apprentice","Third-Year Apprentice","Fourth-Year Apprentice","All Trade";
            // OptionCaption = 'Service Engineer Dual Trade,First-Year Apprentice,Second-Year Apprentice,Third-Year Apprentice,Fourth-Year Apprentice,All Trade';
        }
        // DCS::HP 11082025 --
    }
}
