table 50200 "Esker Azure Parameters"
{
    Caption = 'Esker Azure Parameters';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Azure Storage Account"; Text[50])
        {
            Caption = 'Azure Storage Account';
        }
        field(3; "Access Key"; Text[100])
        {
            Caption = 'Access Key';
        }
        field(4; "Master Data"; Text[100])
        {
            Caption = 'Master Data';
        }
        field(5; "Archive"; Text[100])
        {
            Caption = 'Archive';
        }
        field(6; "Paid Invoices"; Text[100])
        {
            Caption = 'Paid Invoices';
        }
        field(7; "PO Invoices"; Text[100])
        {
            Caption = 'PO Invoices';
        }
        field(8; "Non PO Invoices"; Text[100])
        {
            Caption = 'Non PO Invoices';
        }
        field(9; "File Share"; Text[100])
        {
            Caption = 'File Share';
        }
        field(12; "Vendor Template"; Code[20])
        {
            Caption = 'Vendor Template';
        }
         field(13; "Acknowledgement"; Text[100])
        {
            Caption = 'Acknowledgement';
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
