pageextension 50203 "Purch Recpt Line Ext" extends "Posted Purchase Rcpt. Subform"
{
    layout{
        addafter("Quantity Invoiced")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
