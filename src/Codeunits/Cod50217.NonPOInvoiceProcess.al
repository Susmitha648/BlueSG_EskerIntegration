#pragma warning disable AA0215
/// <summary>
/// Codeunit Non PO Invoice Process (ID 50217).
/// </summary>
codeunit 50217 "Non PO Invoice Process"
#pragma warning restore AA0215
{
    TableNo = "Non PO Header Staging";
    trigger OnRun()
    var
        POInvoiceLine: Record "Non PO Line Staging";
        PurchaseHeader: Record "Purchase Header";
        PurchInvDel: Record "Purchase Header";
        PurchCredDel: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        GLSetup: Record "General Ledger Setup";
        NoSeries: Codeunit "No. Series";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        PurchSetup: Record "Purchases & Payables Setup";
        PLine: Record "Purchase Line";
        VATAmount: Decimal;
        VATDifference : Decimal;
        LineNo: Integer;
        DocNo: Code[20];
    begin
        PurchSetup.Get();
        Clear(DocNo);
        PurchaseHeader.Init();
        if Rec."Document Type" = 'Invoice' then begin
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
            PurchaseHeader.Validate("Vendor Invoice No.", Rec."Invoice No.");
        end else begin
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
            PurchaseHeader.Validate("Vendor Cr. Memo No.", Rec."Invoice No.");
        end;
        PurchaseHeader.Validate("Posting Date", Rec."Posting Date");
        PurchaseHeader.Insert(true);
        PurchaseHeader.Validate("Buy-from Vendor No.", Rec."Vendor No.");
        PurchaseHeader.Validate("Document Date", Rec."Invoice Date");
        PurchaseHeader.Modify();

        GLSetup.Get();
        if GLSetup."LCY Code" <> Rec."Invoice Currency" then begin
            PurchaseHeader.Validate("Currency Code", Rec."Invoice Currency");
            If Rec."Esker Exch. Rate Amount" <> 0 then begin
                CurrencyExchangeRate.Reset();
                CurrencyExchangeRate.SetRange("Currency Code", Rec."Invoice Currency");
                CurrencyExchangeRate.SetRange("Starting Date", 0D, Rec."Posting Date");
                If CurrencyExchangeRate.FindLast() then
                    PurchaseHeader.Validate("Currency Factor", CurrencyExchangeRate."Exchange Rate Amount" / Rec."Esker Exch. Rate Amount");
            end;
        end;
        DocNo := PurchaseHeader."No.";

        PurchaseHeader.Modify();

        //updating staging table with Purch invoice no.


        POInvoiceLine.Reset();
        POInvoiceLine.SetRange("Entry No.", Rec."Entry No.");
        POInvoiceLine.SetRange("Invoice No.", Rec."Invoice No.");
        If POInvoiceLine.FindSet(false) then
            repeat
                Clear(LineNo);
                PLine.Reset();
                PLine.SetCurrentKey("Document Type", "Document No.", "Line No.");
                PLine.SetAscending("Line No.", false);
                if Rec."Document Type" = 'Invoice' then
                    PLine.SetRange("Document Type", PLine."Document Type"::Invoice)
                else
                    PLine.SetRange("Document Type", PLine."Document Type"::"Credit Memo");
                PLine.SetRange("Document No.", PurchaseHeader."No.");
                If PLine.FindFirst() then
                    LineNo := PLine."Line No."
                Else
                    LineNo := 0;
                //PurchaseInvoiceLine.InitHeaderDefaults(PurchaseInvoice, PurchaseInvoiceLine);
                PurchaseLine.Init();
                if Rec."Document Type" = 'Invoice' then
                    PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice
                else
                    PurchaseLine."Document Type" := PurchaseLine."Document Type"::"Credit Memo";
                PurchaseLine."Document No." := PurchaseHeader."No.";
                PurchaseLine."Line No." := LineNo + 10000;
                If POInvoiceLine."Line Type" = 'GL' then begin
                    PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
                    PurchaseLine.Validate("No.", POInvoiceLine."GL Account");
                    PurchaseLine.Description := POInvoiceLine.Description;
                end;
                PurchaseLine.Insert();
                PurchaseLine.Validate("Currency Code", PurchaseHeader."Currency Code");
                PurchaseLine.Validate(Quantity, 1);
                PurchaseLine.Validate("VAT Prod. Posting Group", POInvoiceLine."Tax Code");
                if Rec."Invoice Amount" > 0 then begin
                    if PurchaseHeader."Prices Including VAT" then
                        PurchaseLine.Validate("Direct Unit Cost", POInvoiceLine.Amount + POInvoiceLine."Tax Amount")
                    else
                        PurchaseLine.Validate("Direct Unit Cost", POInvoiceLine.Amount);
                end else
                    if PurchaseHeader."Prices Including VAT" then
                        PurchaseLine.Validate("Direct Unit Cost", POInvoiceLine.Amount * -1 + POInvoiceLine."Tax Amount" * -1)
                    else
                        PurchaseLine.Validate("Direct Unit Cost", POInvoiceLine.Amount * -1);
                
                VATAmount := PurchaseLine."Amount Including VAT" - PurchaseLine.Amount;
                VATDifference := ABS(POInvoiceLine."Tax Amount") - ABS(VATAmount);
                
                If (ABS(VATDifference) < 0.05) and (ABS(VATDifference) > 0) then begin
                    PurchaseLine.Validate("Amount Including VAT" , ABS(POInvoiceLine.Amount) + ABS(POInvoiceLine."Tax Amount"));
                    PurchaseLine."VAT Difference" := VATDifference;
                    PurchaseLine.Amount := POInvoiceLine.Amount;   
                end;

                PurchaseLine.Validate("Dimension Set ID", CreateDimension(POInvoiceLine));
                PurchaseLine.Modify();



            until POInvoiceLine.Next() = 0;

        PurchaseHeader.CalcFields("Amount Including VAT");
       
        If ABS(PurchaseHeader."Amount Including VAT") <> ABS(Rec."Invoice Amount") then begin

            If Rec."Document Type" = 'Invoice' then begin
                If PurchInvDel.Get(PurchInvDel."Document Type"::Invoice, DocNo) then
                    PurchInvDel.Delete(true);
            end else
                If PurchCredDel.Get(PurchCredDel."Document Type"::"Credit Memo", DocNo) then
                    PurchCredDel.Delete(true);
            Error('Amount not tally');
        end;

       Codeunit.Run(CODEUNIT::"Purch.-Post", PurchaseHeader);
        If Rec."Document Type" = 'Invoice'
         then begin
            If PurchInvDel.Get(PurchInvDel."Document Type"::Invoice, DocNo) then
                PurchInvDel.Delete(true);
        end else
            If PurchCredDel.Get(PurchCredDel."Document Type"::"Credit Memo", DocNo) then
                PurchCredDel.Delete(true);

    end;



    /// <summary>
    /// CreateDimension.
    /// </summary>
    /// <param name="NonPOLine">Record "Non PO Line Staging".</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CreateDimension(NonPOLine: Record "Non PO Line Staging"): Integer
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionValue: Record "Dimension Value";
        DimensionManagement: Codeunit DimensionManagement;
        DimSetID: Integer;
    begin
        GeneralLedgerSetup.Get();
        If NonPOLine."Conso Group Code" <> '' then
            If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 1 Code", NonPOLine."Conso Group Code") then begin
                DimensionValue.Init();
                DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 1 Code");
                DimensionValue.Validate(Code, NonPOLine."Conso Group Code");
                DimensionValue.Validate(Name, NonPOLine."Conso Group Code");
                DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                DimensionValue.Insert();
            end;


        If NonPOLine."Cost Center" <> '' then
            If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 2 Code", NonPOLine."Cost Center") then begin
                DimensionValue.Init();
                DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 2 Code");
                DimensionValue.Validate(Code, NonPOLine."Cost Center");
                DimensionValue.Validate(Name, NonPOLine."Cost Center");
                DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                DimensionValue.Insert();
            end;


        If NonPOLine.Z_VehRegNumberCode <> '' then
            If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 3 Code", NonPOLine.Z_VehRegNumberCode) then begin
                DimensionValue.Init();
                DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 3 Code");
                DimensionValue.Validate(Code, NonPOLine.Z_VehRegNumberCode);
                DimensionValue.Validate(Name, NonPOLine.Z_VehRegNumberCode);
                DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                DimensionValue.Insert();
            end;


        If NonPOLine."Billing Period" <> '' then
            If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 4 Code", NonPOLine."Billing Period") then begin
                DimensionValue.Init();
                DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 4 Code");
                DimensionValue.Validate(Code, NonPOLine."Billing Period");
                DimensionValue.Validate(Name, NonPOLine."Billing Period");
                DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                DimensionValue.Insert();
            end;


        If NonPOLine.Z_RevPackgPlanCode <> '' then
            If not DimensionValue.Get(GeneralLedgerSetup."Shortcut Dimension 5 Code", NonPOLine.Z_RevPackgPlanCode) then begin
                DimensionValue.Init();
                DimensionValue.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 5 Code");
                DimensionValue.Validate(Code, NonPOLine.Z_RevPackgPlanCode);
                DimensionValue.Validate(Name, NonPOLine.Z_RevPackgPlanCode);
                DimensionValue.Validate("Dimension Value Type", DimensionValue."Dimension Value Type"::Standard);
                DimensionValue.Insert();
            end;


        DimSetID := 0;
        TempDimensionSetEntry.DeleteAll();

        If NonPOLine."Conso Group Code" <> '' then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 1 Code");
            TempDimensionSetEntry.Validate("Dimension Value Code", NonPOLine."Conso Group Code");
            TempDimensionSetEntry.Insert();
        end;

        If NonPOLine."Cost Center" <> '' then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 2 Code");
            TempDimensionSetEntry.Validate("Dimension Value Code", NonPOLine."Cost Center");
            TempDimensionSetEntry.Insert();
        end;

        If NonPOLine.Z_VehRegNumberCode <> '' then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 3 Code");
            TempDimensionSetEntry.Validate("Dimension Value Code", NonPOLine.Z_VehRegNumberCode);
            TempDimensionSetEntry.Insert();
        end;

        If NonPOLine."Billing Period" <> '' then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 4 Code");
            TempDimensionSetEntry.Validate("Dimension Value Code", NonPOLine."Billing Period");
            TempDimensionSetEntry.Insert();
        end;

        If NonPOLine.Z_RevPackgPlanCode <> '' then begin
            TempDimensionSetEntry.Init();
            TempDimensionSetEntry.Validate("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 5 Code");
            TempDimensionSetEntry.Validate("Dimension Value Code", NonPOLine.Z_RevPackgPlanCode);
            TempDimensionSetEntry.Insert();
        end;

        DimSetID := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);

        DimensionSetEntry.Reset();
        DimensionSetEntry.SetRange("Dimension Set ID", DimSetID);
        if not DimensionSetEntry.FindFirst() then begin
            TempDimensionSetEntry.Reset();
            if TempDimensionSetEntry.FindSet() then
                repeat
                    DimensionSetEntry.Init();
                    DimensionSetEntry.Validate("Dimension Set ID", DimSetID);
                    DimensionSetEntry.Validate("Dimension Code", TempDimensionSetEntry."Dimension Code");
                    DimensionSetEntry.Validate("Dimension Value Code", TempDimensionSetEntry."Dimension Value Code");
                    DimensionSetEntry.Insert();
                until TempDimensionSetEntry.Next() = 0;
        end;

        TempDimensionSetEntry.Reset();
        TempDimensionSetEntry.DeleteAll();
        exit(DimSetID);
    end;

}
