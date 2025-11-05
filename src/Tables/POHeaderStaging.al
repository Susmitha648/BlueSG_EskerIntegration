// Header Staging Table
table 50201 "PO Header Staging"
{
    DataClassification = ToBeClassified;
    Caption = 'PO  Header Staging';
    DataPerCompany = false;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "RUID"; Text[100])
        {
            Caption = 'RUID';
        }
        field(3; "Company Code"; Text[50])
        {
            Caption = 'Company Code';
        }
        field(4; "ERP Linking Date"; Date)
        {
            Caption = 'ERP Linking Date';
        }
        field(5; "ERP Posting Date"; Date)
        {
            Caption = 'ERP Posting Date';
        }
        field(6; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
            DecimalPlaces = 2;
        }
        field(7; "Invoice Currency"; Text[50])
        {
            Caption = 'Invoice Currency';
        }
        field(8; "Invoice Date"; Date)
        {
            Caption = 'Invoice Date';
        }
        field(9; "Invoice No."; Code[50])
        {
            Caption = 'Invoice No.';
        }
        field(10; "Invoice Type"; Text[50])
        {
            Caption = 'Invoice Type';
        }
        field(11; "Order No."; Text[50])
        {
            Caption = 'Order No.';
        }
        field(12; "Vendor No."; Text[50])
        {
            Caption = 'Vendor No.';
        }
        field(13; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(14; "Processing Status"; Option)
        {
            Caption = 'Processing Status';
            OptionMembers = Pending,Processing,Completed,Error;
        }
        field(15; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(16; "Created DateTime"; DateTime)
        {
            Caption = 'Created DateTime';
        }

        field(17; "ERP System"; Text[50])
        {
            Caption = 'ERP System';
        }
        field(18; "ERP Payment Blocked"; Boolean)
        {
            Caption = 'ERP Payment Blocked';
        }
        field(19; "ERP MM Invoice Number"; Text[50])
        {
            Caption = 'ERP MM Invoice Number';
        }
        field(20; "Exchange Rate"; Text[20])
        {
            Caption = 'Exchange Rate';
        }
        field(21; "Goods Receipt"; Decimal)
        {
            Caption = 'Goods Receipt ';
            DecimalPlaces = 2;
        }
        field(22; "Header Text"; Text[250])
        {
            Caption = 'Header Text';
        }
        field(23; "Invoice Reference No."; Text[50])
        {
            Caption = 'Invoice Reference Number';
        }
        field(24; "Local Currency"; Text[50])
        {
            Caption = 'Local Currency';
        }
        field(25; "Local Invoice Amount"; Decimal)
        {
            Caption = 'Local Invoice Amount';
            DecimalPlaces = 2;
        }
        field(26; "Payment Approval Status"; Text[50])
        {
            Caption = 'Payment Approval Status';
        }
        field(27; "Payment Terms"; Text[100])
        {
            Caption = 'Payment Terms';
        }
        field(28; "Reception Method"; Text[50])
        {
            Caption = 'Reception Method';
        }
        field(29; "Vendor City"; Text[100])
        {
            Caption = 'Vendor City';
        }
        field(30; "Vendor Country"; Text[100])
        {
            Caption = 'Vendor Country';
        }
        field(31; "Vendor Street"; Text[250])
        {
            Caption = 'Vendor Street';
        }
        field(32; "Vendor Postal BOX"; Text[50])
        {
            Caption = 'Vendor Postal BOX';
        }
        field(33; "Touchless Done"; Boolean)
        {
            Caption = 'Touchless Processing';
        }
        field(34; "Calculate Tax"; Boolean)
        {
            Caption = 'Calculate Tax';
        }

        field(35; "Local Tax Amount"; Decimal)
        {
            Caption = 'Local Tax Amount';
        }

        field(36; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(37; "Generic"; Text[100])
        {
            Caption = 'Generic';
        }
        field(38; "GRIV"; Boolean)
        {
            Caption = 'GRIV';
        }
        field(39; "Invoice Description"; Text[100])
        {
            Caption = 'Invoice Description';
        }
        field(41; "Local Net Amount"; Decimal)
        {
            Caption = 'Local Net Amount';
            DecimalPlaces = 2;
        }
        field(42; "Manual Link"; Boolean)
        {
            Caption = 'Manual Link';

        }
        field(43; "Net Amount"; Decimal)
        {
            Caption = 'Net Amount';
            DecimalPlaces = 2;
        }
        field(44; "Posting Date"; Date)
        {
            Caption = ' Posting Date';
        }
        field(45; "SAP Payment Method"; Decimal)
        {
            Caption = 'SAP Payment Method';
            DecimalPlaces = 2;
        }


        field(46; "Touchless Enabled"; Boolean)
        {
            Caption = 'Touchless Enabled';
        }

        field(47; "Unplanned Delivery Cost"; Boolean)
        {
            Caption = 'Unplanned Delivery Cost';
        }

        field(48; "Vendor Region"; Text[50])
        {
            Caption = 'Vendor Region';
        }

        field(49; "Vendor Zip code"; Text[50])
        {
            Caption = 'Vendor Zip code';
        }
        field(50; "Verifacation Date"; Date)
        {
            Caption = 'Verifacation Date';
        }
        field(51; "Z_BU "; Text[50])
        {
            Caption = 'BU';
        }
        field(52; "Z_CompanyName"; Text[50])
        {
            Caption = 'Company Name';
        }
        field(53; "Z_Data_Before_WSCall"; Text[50])
        {
            Caption = 'Data Before WSCall';
        }

        field(54; "Z_PO_OpenAmount"; Decimal)
        {
            Caption = 'PO Open Amount';
        }

        field(55; "Z_VendorExchangeRate"; Boolean)
        {
            Caption = 'Vendor ExchangeRate';
        }

        field(56; "Z_WorkshopInvoice"; Boolean)
        {
            Caption = 'Workshop Invoice';
        }


        field(57; "Z_WS_Call_Response"; Boolean)
        {
            Caption = 'Call Response';
        }
        field(58; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';
        }
        field(59; "Verification Date"; Date)
        {
            Caption = 'Verification Date';
        }
        field(60; "Status"; Enum "Invoice Process Status")
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Process Error"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Posted Invoice No."; Text[200])
        {
            DataClassification = ToBeClassified;
        }
         field(63; "Esker Exch. Rate Amount"; Decimal)
        {
            Caption = 'Esker Exch. Rate Amount';
            DecimalPlaces = 1 : 6;
        }

    }

    keys
    {
        key(PK; "Entry No.", "Order No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        
    end;

}

