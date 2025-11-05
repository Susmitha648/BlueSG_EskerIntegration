xmlport 50208 "Purchase Line Export"
{
    Caption = 'Purchase Line Export';
    FileName = 'BLUESGESKER__PurchaseorderItems.csv';
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
                textelement(VendorNumber) { }
                textelement(OrderNumber) { }
                textelement(GRIV) { }
                textelement(ItemNumber) { }
                textelement(Description) { }
                textelement(OrderedAmount) { }
                textelement(OrderedQuantity) { }
                textelement(DeliveredAmount) { }
                textelement(DeliveredQuantity) { }
                textelement(InvoicedAmount) { }
                textelement(InvoicedQuantity) { }
                textelement(TaxCode) { }
                textelement(CompanyCode) { }
                textelement(UnitPrice) { }
                textelement(PartNumber) { }
                textelement(GLAccount) { }
                textelement(CostCenter) { }
                textelement(BudgetID) { }
                textelement(TaxRate) { }
                textelement(GBITEMGST) { }
                textelement(GBITEMGROUPGST) { }
                textelement(GBItemNumber) { }
                textelement(GBOLDPARTCODE) { }
                textelement(GBUNIT) { }
                textelement(GBSITE) { }
                textelement(GBWAREHOUSE) { }
                textelement(GBINVENTREFID) { }
                textelement(GBINVENTREFTRANSID) { }
                textelement(GBDEPARTMENT) { }
                textelement(GBFRANCHISECODE) { }
                textelement(GBLEASEAGREEMENT) { }
                textelement(GBSALESTYPE) { }
                textelement(GBVEHICLENUMBER) { }
                textelement(GBLINENUMBER) { }
                textelement(DiscountedUnitPrice) { }
                textelement(DiscountPercentage) { }
                textelement(ConsoGroupCodeText) { }
                textelement(VehicleRegNumberText) { }
                textelement(BillingPeriodText) { }
                textelement(RevPackgPlanText) { }

            }
            tableelement(PurchaseLine; "Purchase Line")
            {
                SourceTableView = sorting("Document No.") where(Type = filter(Item | "G/L Account"), "PO Exported" = CONST(True));
                fieldelement(PaytoVendorNo; PurchaseLine."Pay-to Vendor No.") { }
                fieldelement(DocumentNo; PurchaseLine."Document No.")
                {
                }
                textelement(GRIVValue) { }
                fieldelement(No; PurchaseLine."Line No.")
                {
                }
                textelement(Descriptionformat)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Descriptionformat := SanitizeDescription(PurchaseLine.Description);

                    end;
                }
                textelement(AmountIncludingVAT)
                {
                    trigger OnBeforePassVariable()
                    begin
                        AmountIncludingVAT := Format(PurchaseLine."Amount", 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');

                    end;
                }
                textelement(Quantity)
                {
                    trigger OnBeforePassVariable()
                    begin
                        Quantity := Format(PurchaseLine.Quantity, 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');

                    end;
                }
                textelement(DeliveredAmountValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        DeliveredAmountValue := Format(Round((PurchaseLine."Unit Cost" * PurchaseLine."Quantity Received"), Currency."Amount Rounding Precision"), 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');

                    end;
                }
                textelement(QtyReceivedBase)
                {
                    trigger OnBeforePassVariable()
                    begin
                        QtyReceivedBase := Format((PurchaseLine."Quantity Received"), 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');

                    end;
                }
                textelement(InvoicedAmountValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        InvoicedAmountValue := Format(Round((PurchaseLine."Unit Cost" * PurchaseLine."Quantity Invoiced"), Currency."Amount Rounding Precision"), 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');

                    end;
                }
                textelement(QtyInvoicedBase)
                {
                    trigger OnBeforePassVariable()
                    begin
                        QtyInvoicedBase := Format((PurchaseLine."Quantity Invoiced"), 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');

                    end;
                }
                fieldelement(VATIdentifier; PurchaseLine."VAT Identifier")
                {
                }
                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }

                textelement(UnitPriceLCY)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UnitPriceLCY := Format((PurchaseLine."Unit Cost"), 0, '<Precision,2:2><Sign><Integer Thousand><Decimals>');
                    end;
                }
                textelement(PartNumberValue) { }
                textelement(GLAccountValue) { }
                fieldelement(ShortcutDimension2Code; PurchaseLine."Shortcut Dimension 2 Code")
                {
                }
                textelement(BudgetIDValue) { }
                textelement(TaxRateValue) { }
                textelement(GBITEMGST__) { }
                textelement(GBITEMGROUPGST__) { }
                fieldelement(GBItemNumber; PurchaseLine."No.") { }
                textelement(GBOLDPARTCODE__) { }
                textelement(GBUNIT__) { }

                textelement(GBSITE__) { }
                textelement(GBWAREHOUSE__) { }
                textelement(GBINVENTREFID__) { }
                textelement(GBINVENTREFTRANSID__) { }
                textelement(GBDEPARTMENT__) { }
                textelement(GBFRANCHISECODE__) { }
                textelement(GBLEASEAGREEMENT__) { }
                textelement(GBSALESTYPE__) { }
                textelement(GBVEHICLENUMBER__) { }
                textelement(GBLINENUMBERvalue)
                {
                }
                fieldelement(LineDiscountAmount; PurchaseLine."Line Discount Amount")
                {
                }
                fieldelement(LineDiscount; PurchaseLine."Line Discount %")
                {
                }
                fieldelement(ShortcutDimension1Code; PurchaseLine."Shortcut Dimension 1 Code")
                {
                }
                textelement(VehRegNumber)
                {
                    trigger OnBeforePassVariable()
                    var
                        DimSetEntryVRN: Record "Dimension Set Entry";
                    begin
                        DimSetEntryVRN.Reset();
                        If DimSetEntryVRN.Get(PurchaseLine."Dimension Set ID", 'VEH REG NUMBER') then
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
                        If DimSetEntryBP.Get(PurchaseLine."Dimension Set ID", 'BILLING PERIOD') then
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
                        If DimSetEntryRPP.Get(PurchaseLine."Dimension Set ID", 'REV PACKG PLAN') then
                            RevPackgPlan := DimSetEntryRPP."Dimension Value Code";
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    Currency.Reset();
                    GLSetup.Get();
                    If PurchaseLine."Currency Code" <> '' then
                        Currency.SetRange(Code, PurchaseLine."Currency Code")
                    else
                        Currency.SetRange(Code, GLSetup."LCY Code");
                end;
            }
        }
    }
    trigger OnInitXmlPort();
    begin
        VendorNumber := 'VendorNumber__';
        OrderNumber := 'OrderNumber__';
        GRIV := 'GRIV__';
        ItemNumber := 'ItemNumber__';
        Description := 'Description__';
        OrderedAmount := 'OrderedAmount__';
        OrderedQuantity := 'OrderedQuantity__';
        DeliveredAmount := 'DeliveredAmount__';
        DeliveredQuantity := 'DeliveredQuantity__';
        InvoicedAmount := 'InvoicedAmount__';
        InvoicedQuantity := 'InvoicedQuantity__';
        TaxCode := 'TaxCode__';
        CompanyCode := 'CompanyCode__';
        UnitPrice := 'UnitPrice__';
        PartNumber := 'PartNumber__';
        GLAccount := 'GLAccount__';
        CostCenter := 'CostCenter__';
        BudgetID := 'BudgetID__';
        TaxRate := 'TaxRate__';
        GBITEMGST := 'GBITEMGST__';
        GBITEMGROUPGST := 'GBITEMGROUPGST__';
        GBOLDPARTCODE := 'GBOLDPARTCODE__';
        GBUNIT := 'GBUNIT__';
        GBSITE := 'GBSITE__';
        GBWAREHOUSE := 'GBWAREHOUSE__';
        GBINVENTREFID := 'GBINVENTREFID__';
        GBINVENTREFTRANSID := 'GBINVENTREFTRANSID__';
        GBDEPARTMENT := 'GBDEPARTMENT__';
        GBFRANCHISECODE := 'GBFRANCHISECODE__';
        GBLEASEAGREEMENT := 'GBLEASEAGREEMENT__';
        GBSALESTYPE := 'GBSALESTYPE__';
        GBVEHICLENUMBER := 'GBVEHICLENUMBER__';
        GBLINENUMBER := 'GBLINENUMBER__';
        DiscountedUnitPrice := 'Z_DiscountedUnitPrice__';
        DiscountPercentage := 'Z_DiscountPercentage__';
        ConsoGroupCodeText := 'GBCONSOGROUPCODE__';
        VehicleRegNumberText := 'GBVEHREGNUMBER__';
        BillingPeriodText := 'GBBILLINGPERIOD__';
        RevPackgPlanText := 'GBREVPACKGPLAN__';
        GBItemNumber := 'GBItemNumber__';
        CompanyInfo.Get();

    end;

    var
        CompanyInfo: Record "Company Information";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";

    local procedure SanitizeDescription(Value: Text): Text
    var
        i: Integer;
        Char: Char;
        Cleaned: Text;
        Code: Integer;
    begin
        // Replace common line breaks
        Value := Value.Replace('\r\n', ' ');
        Value := Value.Replace('\n', ' ');
        Value := Value.Replace('\r', ' ');



        // Escape quotes and wrap in double quotes if needed
        for i := 1 to StrLen(Value) do begin
            Char := Value[i];
            Code := Char;

            // Allow printable ASCII + extended latin (32-126, and safe unicode range)
            if ((Code >= 32) and (Code <> 8232) and (Code <> 8233) and (Code <> 8203) and (Code <> 8206) and (Code <> 8207)) then
                Cleaned += Char;
        end;

        exit(Value);
    end;
}
