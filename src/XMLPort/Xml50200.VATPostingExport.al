xmlport 50200 "VAT Posting Export"
{
    Caption = 'VAT Posting Export';
    FileName = 'BLUESGESKER__Taxcodes.csv';
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
                textelement(BussTaxCode)
                {

                }
                textelement(TaxCode)
                {

                }
                textelement(Description)
                {

                }
                textelement(TaxRate)
                {

                }
                textelement(TaxAccount)
                {
                }
                textelement(TaxAccountForCollection)
                {

                }
                textelement(TaxType)
                {

                }
            }
            tableelement(VATPostingGroup; "VAT Posting Setup")
            {

                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                fieldelement(BusPostingGroup; VATPostingGroup."VAT Bus. Posting Group")
                {
                }
                fieldelement(ProdPostingGroup; VATPostingGroup."VAT Prod. Posting Group")
                {
                }
                fieldelement(Description; VATPostingGroup.Description)
                {
                }
                fieldelement(TaxRateValue; VATPostingGroup."VAT %")
                {
                }
                textelement(TaxAcccountValue)
                {
                }
                textelement(TaxAccountForCollectionValue)
                {
                }
                textelement(TaxTypeVale)
                {
                }
            }
        }
    }
    trigger OnInitXmlPort();
    begin
        CompanyCode := 'CompanyCode__';
        TaxCode := 'TaxCode__';
        BussTaxCode := 'BusTaxCode__';
        Description := 'Description__';
        TaxRate := 'TaxRate__';
        TaxAccount := 'TaxAccount__';
        TaxAccountForCollection := 'TaxAccountForCollection__';
        TaxType := 'TaxType__';
        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
}
