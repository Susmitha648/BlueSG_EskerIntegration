xmlport 50204 "Conso Group Code Export"
{
    Caption = 'Conso Group Code Export';
    FileName = 'BLUESGESKER__ConsoGroupCode.csv';
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
                textelement(ConsoGroupCode)
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
                SourceTableView = where("Dimension Code" = filter('CONSO GROUP CODE'));
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
        ConsoGroupCode := 'ConsoGroupCode__';
        Description := 'Description__';
        Manager := 'Manager__';

        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
}
