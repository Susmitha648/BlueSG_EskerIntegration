tableextension 50203 "Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
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
