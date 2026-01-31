page 60100 "BSO Invoice Records"
{
    PageType = ListPart;
    SourceTable = "BSO Invoice Records";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No."; rec."Invoice No.") { ApplicationArea = All; }
                field("Invoice Date"; rec."Invoice Date") { ApplicationArea = All; }
                field("Invoiced %"; rec."Invoiced %") { ApplicationArea = All; }
                field(Amount; rec.Amount) { ApplicationArea = All; }
            }
        }
    }
}
