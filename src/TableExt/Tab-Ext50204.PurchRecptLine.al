tableextension 50204 PurchRecptLine extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50200; "Exported to Esker"; Boolean)
        {
            Caption = 'Export to Esker';
            DataClassification = ToBeClassified;
        }
        field(50201; "XML Created"; Boolean)
        {
            Caption = 'XML Created';
            DataClassification = ToBeClassified;
        }
         
    }
}
