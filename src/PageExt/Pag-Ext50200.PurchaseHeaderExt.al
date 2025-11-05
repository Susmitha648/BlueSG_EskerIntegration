pageextension 50200 "PurchaseHeader Ext" extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Exported to Esker"; Rec."Exported to Esker")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                ToolTip = 'Specifies PO which are exported';
            }
        }
    }
}
