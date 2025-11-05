xmlport 50210 "Payment Terms Export"
{
    Caption = 'Payment Terms Export';
    FileName = 'BLUESGESKER__Paymentterms.csv';
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
                textelement(PaymentTermCode)
                {

                }
                textelement(Description)
                {

                }
                textelement(DiscountPeriod)
                {

                }
                textelement(DayLimit)
                {
                }
                textelement(DiscountRate)
                {

                }
                textelement(LatePaymentFeeRate)
                {

                }
                textelement(ReferenceDate)
                {

                }
                textelement(EndOfMonth)
                {

                }
                 textelement(GBPaymentMethod)
                {

                }
                 textelement(GBCashPayment)
                {

                }
            }
            tableelement(PaymentTerms; "Payment Terms")
            {
                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                fieldelement(Code; PaymentTerms."Code")
                {
                }
                fieldelement(Description; PaymentTerms.Description)
                {
                }
                textelement(DiscountPeriodValue)
                {
                }
                textelement(DayLimitValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Evaluate(DayLimitTxt,Format(PaymentTerms."Due Date Calculation"));
                        DayLimitValue := CopyStr(DayLimitTxt,1,StrLen(DayLimitTxt)-1);
                    end;
                }
                fieldelement(Discount; PaymentTerms."Discount %")
                {
                }
                 textelement(LatePaymentFeeRateValue)
                {
                }
                textelement(ReferenceDateValue)
                {
                }
                textelement(EndOfMonthValue)
                {
                }
                textelement(GBPaymentMethodValue)
                {
                }
                textelement(GBCashPaymentValue)
                {
                }
            }
        }
    }
    trigger OnInitXmlPort();
    begin
        CompanyCode := 'CompanyCode__';
        PaymentTermCode := 'PaymentTermCode__';
        Description := 'Description__';
        DiscountPeriod := 'DiscountPeriod__';
        DayLimit := 'DayLimit__';
        DiscountRate := 'DiscountRate__';
        LatePaymentFeeRate := 'LatePaymentFeeRate__';
        ReferenceDate := 'ReferenceDate__';
        EndOfMonth := 'EndOfMonth__';
        GBPaymentMethod := 'GBPaymentMethod__';
        GBCashPayment := 'GBCashPayment__';
        CompanyInfo.Get();
    end;
    var
        CompanyInfo: Record "Company Information";
        DayLimitTxt : Text;
}
