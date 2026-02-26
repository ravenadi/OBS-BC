codeunit 50252 "FA Prefix Event Subs"
{
    // REMOVED: All event subscribers moved to Page Extension
    // The Page Extension (Pag-Ext50183) now handles:
    // 1. No. field validation -> Sets FA Class, Posting Group, Subclass
    // 2. Directly updates Depreciation Books in the same trigger
    //
    // This prevents timing issues and ensures all updates happen together
    // in the UI context where the user can see immediate results.
    //
    // The Table Extension (Tab-Ext50200) handles new Depreciation Book inserts.
}