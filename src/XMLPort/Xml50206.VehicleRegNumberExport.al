xmlport 50206 "Vehicle Reg Number Export"
{
    Caption = 'Vehicle Reg Number Export';
    FileName = 'BLUESGESKER__VehicleRegNumber.csv';
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
                textelement(VehicleRegNumber)
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
                SourceTableView = where("Dimension Code" = filter('VEH REG NUMBER'));
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
        VehicleRegNumber := 'VehicleRegNumber__';
        Description := 'Description__';
        Manager := 'Manager__';

        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
}
