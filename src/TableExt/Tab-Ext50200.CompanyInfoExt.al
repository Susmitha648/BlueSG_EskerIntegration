tableextension 50200 "Company Info Ext" extends "Company Information"
{
    fields
    {
        field(50200; "Company Code"; Text[20])
        {
            Caption = 'Company Code';
            DataClassification = ToBeClassified;
        }
    }
}
