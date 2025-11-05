codeunit 50216 "PO Invoice Process"
{
    TableNo = "PO Header Staging";
    trigger OnRun()
    var
        POInvoiceHeader: Record "PO Header Staging";
        POInvoiceLine: Record "PO Line Staging";
        PurchaseOrder: Record "Purchase Header";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        TempPurchLine: Record "Purchase Line" temporary;
        InvoicedAmount: Decimal;
        TaxAmount: Decimal;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        GLSetup.Get();
        If PurchaseOrder.Get(PurchaseOrder."Document Type"::Order, Rec."Order No.") then begin
            If PurchaseOrder."Buy-from Vendor No." <> Rec."Vendor No." then
                Error('Purchase Order Vendor no does not match');
            //Fill the TempPurchLine buffer
            TempPurchLine.DeleteAll();
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.SetRange("Document No.", Rec."Order No.");
            PurchaseLine.SetRange(type, PurchaseLine.Type::Item);
            if PurchaseLine.FindSet(false) then
                repeat
                    TempPurchLine.Init();
                    TempPurchLine := PurchaseLine;
                    TempPurchLine.Insert();
                until PurchaseLine.next = 0;

            PurchaseOrder."Vendor Invoice No." := Rec."Invoice No.";
            PurchaseOrder."Invoice Received Date" := Rec."Invoice Date";
            PurchaseOrder.Validate("Document Date", Rec."Invoice Date");
            If PurchaseOrder."Currency Code" = '' then
                PurchaseOrder.Validate("Posting Date", Rec."Posting Date")
            else begin
                PurchaseOrder."Posting Date" := Rec."Posting Date";
                PurchaseOrder."VAT Reporting Date" := Rec."Posting Date";
            end;
            If PurchaseOrder."Currency Code" <> '' then
                if (GLSetup."LCY Code" <> PurchaseOrder."Currency Code") then
                    If Rec."Esker Exch. Rate Amount" <> 0 then begin
                        PurchaseOrder.Status := PurchaseOrder.Status::Open;
                        CurrencyExchangeRate.Reset();
                        CurrencyExchangeRate.SetRange("Currency Code", Rec."Invoice Currency");
                        CurrencyExchangeRate.SetRange("Starting Date", 0D, Rec."Posting Date");
                        If CurrencyExchangeRate.FindLast() then
                            PurchaseOrder.Validate("Currency Factor", CurrencyExchangeRate."Exchange Rate Amount" / Rec."Esker Exch. Rate Amount");
                        PurchaseOrder.Status := PurchaseOrder.Status::Released;
                    end;
            PurchaseOrder."Invoice Received Amount" += Rec."Invoice Amount";
            If PurchaseOrder."Amount Including VAT" <> Rec."Invoice Amount" then
                PurchaseOrder."Partially Invoiced" := True;
            PurchaseOrder.Modify();

            //update Qty to invoice in purchlines
            POInvoiceLine.Reset();
            POInvoiceLine.SetRange("Entry No.", Rec."Entry No.");
            POInvoiceLine.SetRange("Order No.", Rec."Order No.");
            If POInvoiceLine.FindSet(false) then
                repeat
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange("Document No.", Rec."Order No.");
                    PurchaseLine.SetRange("Line No.", POInvoiceLine."Item No.");
                    If PurchaseLine.FindFirst() then begin
                        Currency.Reset();

                        If PurchaseOrder."Currency Code" <> '' then
                            Currency.SetRange(Code, PurchaseOrder."Currency Code")
                        else
                            Currency.SetRange(Code, GLSetup."LCY Code");
                        InvoicedAmount := Round(POInvoiceLine.Quantity * PurchaseLine."Unit Cost", Currency."Amount Rounding Precision");
                        //Message('Test1%1',InvoicedAmount);
                        //Message('Test2%1',PurchaseLine."Direct Unit Cost");
                        If InvoicedAmount <> POInvoiceLine.Amount then
                            Error('Amount not tally');

                        TempPurchLine.Reset();
                        TempPurchLine.SetRange("Document Type", TempPurchLine."Document Type"::Order);
                        TempPurchLine.SetRange("Document No.", Rec."Order No.");
                        TempPurchLine.SetRange("Line No.", POInvoiceLine."Item No.");
                        if not TempPurchLine.FindFirst() then
                            PurchaseLine.Validate("Qty. to Invoice", POInvoiceLine.Quantity + PurchaseLine."Qty. to Invoice")
                        else begin
                            PurchaseLine.Validate("Qty. to Invoice", POInvoiceLine.Quantity);
                            TempPurchLine.Delete();
                        end;
                        PurchaseLine.Modify();

                    end;

                until POInvoiceLine.Next() = 0;

            //Set the remaining Purch lines Qty to invoice to Zero
            TempPurchLine.Reset();
            TempPurchLine.SetRange("Document Type", TempPurchLine."Document Type"::Order);
            TempPurchLine.SetRange("Document No.", Rec."Order No.");
            if TempPurchLine.FindSet() then
                repeat
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange("Document No.", Rec."Order No.");
                    PurchaseLine.SetRange("Line No.", TempPurchLine."Line No.");
                    If PurchaseLine.FindFirst() then begin
                        PurchaseLine.Validate("Qty. to Invoice", 0);
                        PurchaseLine.Modify();
                    end;
                until TempPurchLine.Next() = 0;

            //Posting the PO
            PurchaseOrder.Invoice := True;
            PurchaseOrder.Receive := False;
            PurchaseOrder.Modify();

            Codeunit.Run(CODEUNIT::"Purch.-Post", PurchaseOrder);

        end else
            Error('Purchase Order %1 does not exist', Rec."Order No.");
    end;
}
