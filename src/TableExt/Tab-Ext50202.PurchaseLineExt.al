tableextension 50202 "Purchase Line Ext" extends "Purchase Line"
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
        field(50202; "PO Exported"; Boolean)
        {
            Caption = 'PO Exported';
            DataClassification = ToBeClassified;
        }
       
    }
}
