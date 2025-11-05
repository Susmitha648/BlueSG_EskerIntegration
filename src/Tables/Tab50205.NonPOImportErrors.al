table 50205 "Non PO Import Errors"
{
    Caption = 'Non PO Import Errors';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Import Error"; Text[2048])
        {
            Caption = 'Import Error';
            
        }
        field(3; "File Name"; Text[150])
        {
            Caption = 'File Name';
            
        }
        field(4; "RUID"; Text[100])
        {
            Caption = 'RUID';
            
        }
         field(5; "Acknowledgement Sent"; Boolean)
        {
            Caption = 'Acknowledgement Sent';
            
        }
         field(6; "Line Error"; Boolean)
        {
            Caption = 'Line Error';
            
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
