tableextension 50201 "Purchase Header Ext" extends "Purchase Header"
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
        field(50202; "Invoice Received Amount"; Decimal)
        {
            Caption = 'Invoice Received Amount';
            DataClassification = ToBeClassified;
        }
         field(50203; "Invoice Received Partially"; Boolean)
        {
            Caption = 'Invoice Received Partially';
            DataClassification = ToBeClassified;
        }
         field(50204; "Last Invoice No."; Text[20])
        {
            Caption = 'Last Invoice No.';
            DataClassification = ToBeClassified;
        }
          field(50205; "RUID"; Text[100])
        {
            Caption = 'RUID';
            DataClassification = ToBeClassified;
        }
    }
}
