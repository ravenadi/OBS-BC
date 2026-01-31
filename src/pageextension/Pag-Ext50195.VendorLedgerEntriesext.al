//DCS::HK 13112025 ++
pageextension 50195 "Vendor Ledger Entries ext" extends "Vendor Ledger Entries"
{
    layout
    {
        addafter("vendor No.")
        {
            field("name"; rec.name)
            {
                applicationarea = all;
                caption = 'Name';
            }
        }
    }
}
//DCS::HK 13112025 --