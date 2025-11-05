xmlport 50207 "Purchase Header Items Export"
{
    Caption = 'Purchase Header Items Export';
    FileName = 'BLUESGESKER__PurchaseorderHeaders.csv';
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
                textelement(OrderNumber)
                {

                }
                textelement(VendorNumber)
                {

                }
                textelement(OrderDate)
                {

                }
                textelement(OrderedAmount)
                {

                }
                textelement(DeliveredAmount)
                {
                }
                textelement(InvoicedAmount)
                {

                }
                textelement(CompanyCode)
                {

                }
                textelement(GBCurrency)
                {

                }
                textelement(GBConsoGroupCode)
                {

                }
                textelement(GBCostCenter)
                {

                }
                textelement(GBVehRegNumber)
                {

                }
                textelement(GBBillingPeriod)
                {

                }
                textelement(GBRevPackgPlan)
                {

                }
            }
            tableelement(PurchaseHeader; "Purchase Header")
            {
                SourceTableView = sorting("No.") where(Status = Filter(Released));
                fieldelement(No; PurchaseHeader."No.")
                {
                }
                fieldelement(PayToVendorNo; PurchaseHeader."Pay-to Vendor No.")
                {
                }
                fieldelement(OrderDate; PurchaseHeader."Order Date")
                {
                }
                fieldelement(AmountIncludingVAT; PurchaseHeader."Amount")
                {
                }
                textelement(DeliveredAmountValue)
                {
                    trigger OnBeforePassVariable()
                    var
                        PurchaseLineDA: Record "Purchase Line";
                        DeliveredAmount: Decimal;
                    begin
                        PurchaseLineDA.Reset();
                        PurchaseLineDA.SetRange("Document Type", PurchaseLineDA."Document Type"::Order);
                        PurchaseLineDA.SetRange("Document No.", PurchaseHeader."No.");
                        If PurchaseLineDA.Findset() then
                            repeat
                                DeliveredAmount += Round((PurchaseLineDA."Unit Cost" * PurchaseLineDA."Quantity Received"), Currency."Amount Rounding Precision");
                            until PurchaseLineDA.Next() = 0;
                        DeliveredAmountValue := Format(DeliveredAmount, 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');
                    end;
                }
                textelement(InvoicedAmountValue)
                {
                    trigger OnBeforePassVariable()
                    var
                        PurchaseLineIA: Record "Purchase Line";
                        InvoicedAmount: Decimal;
                    begin
                        PurchaseLineIA.Reset();
                        PurchaseLineIA.SetRange("Document Type", PurchaseLineIA."Document Type"::Order);
                        PurchaseLineIA.SetRange("Document No.", PurchaseHeader."No.");
                        If PurchaseLineIA.Findset() then
                            repeat
                                InvoicedAmount += Round((PurchaseLineIA."Unit Cost" * PurchaseLineIA."Quantity Invoiced"), Currency."Amount Rounding Precision");
                            until PurchaseLineIA.Next() = 0;
                        InvoicedAmountValue := Format(InvoicedAmount, 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');
                    end;
                }
                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                fieldelement(CurrencyCode; PurchaseHeader."Currency Code")
                {
                }
                textelement(ConsoGroupCode)
                {
                    trigger OnBeforePassVariable()
                    var
                        DimSetEntryCGC: Record "Dimension Set Entry";
                    begin
                        DimSetEntryCGC.Reset();
                        If DimSetEntryCGC.Get(PurchaseHeader."Dimension Set ID", 'CONSO GROUP CODE') then
                            ConsoGroupCode := DimSetEntryCGC."Dimension Value Code";
                    end;
                }
                textelement(CostCenter)
                {
                    trigger OnBeforePassVariable()
                    var
                        DimSetEntryCC: Record "Dimension Set Entry";
                    begin
                        DimSetEntryCC.Reset();
                        If DimSetEntryCC.Get(PurchaseHeader."Dimension Set ID", 'COST CENTRE') then
                            CostCenter := DimSetEntryCC."Dimension Value Code";
                    end;
                }
                textelement(VehRegNumber)
                {
                    trigger OnBeforePassVariable()
                    var
                        DimSetEntryVRN: Record "Dimension Set Entry";
                    begin
                        DimSetEntryVRN.Reset();
                        If DimSetEntryVRN.Get(PurchaseHeader."Dimension Set ID", 'VEH REG NUMBER') then
                            VehRegNumber := DimSetEntryVRN."Dimension Value Code";
                    end;
                }
                textelement(BillingPeriod)
                {
                    trigger OnBeforePassVariable()
                    var
                        DimSetEntryBP: Record "Dimension Set Entry";
                    begin
                        DimSetEntryBP.Reset();
                        If DimSetEntryBP.Get(PurchaseHeader."Dimension Set ID", 'BILLING PERIOD') then
                            BillingPeriod := DimSetEntryBP."Dimension Value Code";
                    end;
                }
                textelement(RevPackgPlan)
                {
                    trigger OnBeforePassVariable()
                    var
                        DimSetEntryRPP: Record "Dimension Set Entry";
                    begin
                        DimSetEntryRPP.Reset();
                        If DimSetEntryRPP.Get(PurchaseHeader."Dimension Set ID", 'REV PACKG PLAN') then
                            RevPackgPlan := DimSetEntryRPP."Dimension Value Code";
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    PurchaseHeader."XML Created" := True;
                    PurchaseHeader.Modify();
                    Currency.Reset();
                    GLSetup.Get();
                    If PurchaseHeader."Currency Code" <> '' then
                        Currency.SetRange(Code, PurchaseHeader."Currency Code")
                    else
                        Currency.SetRange(Code, GLSetup."LCY Code");
                end;
            }
        }
    }
    trigger OnInitXmlPort();
    begin
        CompanyCode := 'CompanyCode__';
        OrderNumber := 'OrderNumber__';
        VendorNumber := 'VendorNumber__';
        OrderDate := 'OrderDate__';
        OrderedAmount := 'OrderedAmount__';
        DeliveredAmount := 'DeliveredAmount__';
        InvoicedAmount := 'InvoicedAmount__';
        CompanyCode := 'CompanyCode__';
        GBCurrency := 'GBCurrency__';
        GBCostCenter := 'GBCOSTCENTER__';
        GBConsoGroupCode := 'GBCONSOGROUPCODE__';
        GBVehRegNumber := 'GBVEHREGNUMBER__';
        GBBillingPeriod := 'GBBILLINGPERIOD__';
        GBRevPackgPlan := 'GBREVPACKGPLAN__';

        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        DimSetEntry: Record "Dimension Set Entry";
        Currency: Record Currency;
        GLSetup : Record "General Ledger Setup";
}
