//  Line Staging Table
table 50202 "PO Line Staging"
{
    DataClassification = CustomerContent;
    Caption = 'PO  Line Staging';
    DataPerCompany = false;
    fields
    {

        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Order No."; Text[50])
        {
            Caption = 'Order No.';
        }
        field(4; "Item No."; Integer)
        {
            Caption = 'Item No.';
        }
        field(5; CCDescription; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 2;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 2;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2;
        }
        field(9; "Tax Amount"; Decimal)
        {
            Caption = 'Tax Amount';

        }
        field(10; "Tax Code"; Text[50])
        {
            Caption = 'Tax Code';
        }
        field(11; "Department Code"; Text[50])
        {
            Caption = 'Department Code';
        }
        field(12; "Franchise Code"; Text[50])
        {
            Caption = 'Franchise Code';
        }
        field(13; "UOM Code"; Text[50])
        {
            Caption = 'UOM Code';
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

        field(16; "Account Assignment Category"; Text[50])
        {
            Caption = 'Account Assignment Category';
        }
        field(17; "Delivery Note"; Text[50])
        {
            Caption = 'Delivery Note';
        }
        field(18; "Goods Receipt No."; Text[50])
        {
            Caption = 'Goods Receipt Number';
        }
        field(19; "Internal Order "; Integer)
        {
            Caption = 'Internal Order ';
        }
        field(20; "GL Account"; Text[50])
        {
            Caption = 'General Ledger Account';
        }
        field(21; "GL Description"; Text[100])
        {
            Caption = 'GL Account Description';
        }
        field(22; "Tax Jurisdiction"; Text[50])
        {
            Caption = 'Tax Jurisdiction';
        }
        field(23; "Tax Rate"; Boolean)
        {
            Caption = 'Tax Rate';

        }
        field(24; "Cost Center"; Text[50])
        {
            Caption = 'Cost Center';
        }
        field(25; "Billing Period"; Text[50])
        {
            Caption = 'Billing Period';
        }
        field(26; "Chassis Number"; Text[50])
        {
            Caption = 'Chassis Number';
        }
        field(27; "Vehicle Number"; Text[50])
        {
            Caption = 'Vehicle Number';
        }
        field(28; "Work Order"; Text[50])
        {
            Caption = 'Work Order';
        }
        field(29; "Conso Group Code"; Text[50])
        {
            Caption = 'Consolidated Group Code';
        }
        field(30; "Family Code"; Text[50])
        {
            Caption = 'Family Code';
        }
        field(31; "Item Tax Group"; Text[50])
        {
            Caption = 'Item Tax Group';
        }
        field(32; "Different Invoicing Party"; Text[50])
        {
            Caption = 'Different Invoicing Party';
        }
        field(33; "Line Type"; Text[50])
        {
            Caption = 'Line Type';
        }
        field(34; "Part No."; Text[50])
        {
            Caption = 'Party No.';
        }

        field(35; "Z_CalculatedUnitPriceDiscount"; Decimal)
        {
            Caption = 'Z Calculated Unit Price Before Discount';
        }

        field(36; "Z_CalculatedUnitPrice"; Decimal)
        {
            Caption = 'Z Calculated Unit Price';
        }


        field(37; "Z_DiscountedUnitPrice"; Integer)
        {
            Caption = 'Z Discounted Unit Price';
        }
        field(38; "Z_DiscountPercentage"; Decimal)
        {
            Caption = 'Discount Percentage';
        }
        field(39; "Z_RevPackgPlanCode"; Text[200])
        {
            Caption = 'Rev Packing Plan Code';
        }

        field(40; "Tax Group"; Text[200])
        {
            Caption = 'Rev Packing Plan Code';
        }
        field(41; "Vehicle Number Code"; Text[50])
        {
            Caption = 'Vehicle Number code';
        }

        field(42; "Work Date"; Date)
        {
            Caption = 'Work Date';
        }
        field(43; "Description"; Text[100])
        {
            Caption = 'GL Account Description';
        }



    }

    keys
    {
        key(PK; "Entry No.", "Line No.", "Order No.")
        {
            Clustered = true;
        }
    }
}