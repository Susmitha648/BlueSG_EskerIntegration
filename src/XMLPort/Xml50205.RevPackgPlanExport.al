xmlport 50205 "Rev Packg Plan Export"
{
    Caption = 'Rev Packg Plan Export';
    FileName = 'BLUESGESKER__RevPackgPlan.csv';
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
                textelement(RevPackgPlan)
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
                SourceTableView = where("Dimension Code" = filter('REV PACKG PLAN'));
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
        RevPackgPlan := 'RevPackgPlan__';
        Description := 'Description__';
        Manager := 'Manager__';

        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
}
