
xmlport 50212 ExportGLAccountCsv
{
    Caption = 'ExportGLAccountCsv';
    Format = VariableText;
    Direction = Export;
    FileName = 'BlueSGEsker_GLAccounts.csv';
    TextEncoding = UTF8;
    TableSeparator = '<CR><LF>';
    FieldSeparator = ';';
    FieldDelimiter = '';

    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(CompanyCode)
                {

                }

                textelement(Group__)
                {

                }
                textelement(Account__)
                {

                }
                textelement(Description__)
                {

                }
                textelement(Manager__)
                {

                }
                textelement(Allocable1__)
                {

                }
                textelement(Allocable2__)
                {

                }
                textelement(Allocable3__)
                {

                }
                textelement(Allocable4__)
                {

                }
                textelement(Allocable5__)
                {

                }


            }
            tableelement(GLAccount; "G/L Account")
            {
                SourceTableView = sorting("No.") where ("Direct Posting" = CONST(True) , "Account Type" = filter(Posting));
                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                textelement(GroupValue)
                {
                }
                fieldelement(Account; GLAccount."No.")
                {
                    trigger OnBeforePassField()
                    begin
                        if GLAccount."No." = '' then
                            Account__ := ';';
                    end;
                }
                fieldelement(Description; GLAccount."Name")
                {
                    trigger OnBeforePassField()
                    begin
                        if GLAccount.Name = '' then Description__ := ';';
                    end;
                }
                textelement(ManagerValue)
                {
                }
                textelement(Allocable1Value)
                {
                }
                textelement(Allocable2Value)
                {
                }
                textelement(Allocable3Value)
                {
                }
                textelement(Allocable4Value)
                {
                }
                textelement(Allocable5Value)
                {
                }


            }

        }
    }
    trigger OnInitXmlPort();
    begin
        CompanyCode := 'CompanyCode__';
        Group__ := 'Group__';
        Description__ := 'Description__';
        Account__ := 'Account__';
        Allocable1__ := 'Allocable1__';
        Allocable2__ := 'Allocable2__';
        Allocable3__ := 'Allocable3__';
        Allocable4__ := 'Allocable4__';
        Allocable5__ := 'Allocable5__';
        Manager__ := 'Manager__';
        CompanyInfo.Get();
        // TaxRate := 'TaxRate__';
        // TaxAccount := 'TaxAccount__';
        // TaxAccountForCollection := 'TaxAccountForCollection__';
        // TaxType := 'TaxType__';
    end;

    var
        CompanyInfo: Record "Company Information";
}
