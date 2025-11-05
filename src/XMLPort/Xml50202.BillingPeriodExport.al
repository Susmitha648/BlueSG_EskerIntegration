xmlport 50202 "Billing Period Export"
{
    Caption = 'Billing Period Export';
    FileName = 'BLUESGESKER__BillingPeriod.csv';
    Format = VariableText;
    Direction = Export;
    TextEncoding = UTF8;
    FieldSeparator = ';';
    FieldDelimiter = '';
    TableSeparator = '<CR><LF>';
    UseRequestPage = false;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(CompanyCode)
                {

                }
                textelement(BillingPeriod)
                {

                }
                textelement(Description)
                {

                }
                textelement(Manager)
                {

                }
            }
            tableelement(DimensionValue; "Dimension Value")
            {
                SourceTableView = where("Dimension Code" = CONST('BILLING PERIOD'));
                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                fieldelement(DimensionCode; DimensionValue."Code")
                {
                }
                fieldelement(Name; DimensionValue.Name)
                {
                }
                textelement(ManagerValue)
                {
                }
            }
        }

    }
    trigger OnInitXmlPort();
    begin
        CompanyCode := 'CompanyCode__';
        BillingPeriod := 'BillingPeriod__';
        Description := 'Description__';
        Manager := 'Manager__';
        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
}
