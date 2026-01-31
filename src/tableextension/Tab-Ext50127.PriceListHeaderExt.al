// Jathin's Code starts here
tableextension 50127 "Price List Header Ext" extends "Price List Header"
{
    fields
    {
        field(50100; "D01 Percentage"; Integer)
        {
            Caption = 'Percentage';
            DataClassification = CustomerContent;
            MaxValue = 100;
        }
    }
}
// Jathin's Code ends here
