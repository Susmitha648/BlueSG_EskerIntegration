codeunit 50214 "Esker GRN Export"
{
    Permissions = tabledata "Purch. Rcpt. Line" = rimd;
    trigger OnRun()
    var
        PurchRcptLine:Record "Purch. Rcpt. Line";
        PurchRcptHdr:Record "Purch. Rcpt. Header";
        PurchRcpt:Record "Purch. Rcpt. Line";
        PurchRcptLineMarked:Record "Purch. Rcpt. Line";
        PurchRcptLineXMLCreated:Record "Purch. Rcpt. Line";
        PurchaseHdr : Record "Purchase Header";
        CompanyInfo : Record "Company Information";
        Currency : Record Currency;
        GLSetup : Record "General Ledger Setup";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        CSVFieldSeparator: Text;
        FileName: Text;
        CR: Char;
        LF: Char;
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageAccount: Text[100];
        FileShare: Text[100];
        SAS: Interface "Storage Service Authorization";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        FilePath: Text[200];
        EskerSetup: Record "Esker Azure Parameters";
        AccessKey : SecretText;
        DataExist : Boolean;
    begin
       
        CSVFieldSeparator := ';';
        CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__GoodsReceiptItems__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';
        CR := 13;
        LF := 10;
 
 
        TempBlob.CREATEOUTSTREAM(OutStream, TextEncoding::UTF8);
 
        OutStream.WRITETEXT('CompanyCode__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('OrderNumber__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('LineNumber__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('GRNumber__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('RequisitionNumber__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('DeliveryNote__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('DeliveryDate__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('Amount__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('Quantity__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('InvoicedAmount__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('InvoicedQuantity__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('DeliveryCompleted__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('BudgetID__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('GBGRNLINENUM__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('GBITEMNUM__');
        OutStream.WRITETEXT(Format(CR) + Format(LF));
       DataExist := false;
       PurchaseHdr.Reset();
       PurchaseHdr.SetRange(Status,PurchaseHdr.Status::Released);
       If PurchaseHdr.FindSet(false) then repeat
           PurchRcptHdr.Reset();
           PurchRcptHdr.SetRange("Order No.",PurchaseHdr."No.");
           If PurchRcptHdr.FindSet() then 
              repeat
               PurchRcptLine.Reset();
               // PurchRcptLine.SetRange("Exported to Esker",false); 
               PurchRcptLine.SetRange("Document No.",PurchRcptHdr."No.");
               PurchRcptLine.SetRange(Type,PurchRcptLine.Type::Item);
               PurchRcptLine.SetFilter(Quantity,'<>%1',0);
               IF PurchRcptLine.FINDSET(false) THEN 
                  REPEAT
                        Currency.Reset();
                    GLSetup.Get();
                    If PurchRcptHdr."Currency Code" <> '' then
                        Currency.SetRange(Code, PurchRcptHdr."Currency Code")
                    else
                        Currency.SetRange(Code, GLSetup."LCY Code");
                        DataExist := True;
                        OutStream.WRITETEXT(CompanyInfo."Company Code");
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(PurchRcptLine."Order No.");
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(PurchRcptLine."Order Line No."));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(PurchRcptLine."Document No.");

                        OutStream.WRITETEXT(CSVFieldSeparator);
                        
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(PurchRcptLine."Promised Receipt Date"));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(Round((PurchRcptLine."Unit Cost" * PurchRcptLine."Quantity"), Currency."Amount Rounding Precision"), 0 ,'<Precision,2:2><Sign><Integer Thousand><Decimals>'));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(PurchRcptLine."Quantity", 0,'<Precision,2:2><Sign><Integer Thousand><Decimals>'));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(Round((PurchRcptLine."Unit Cost" * PurchRcptLine."Quantity Invoiced") , Currency."Amount Rounding Precision"), 0,'<Precision,2:2><Sign><Integer Thousand><Decimals>'));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(PurchRcptLine."Quantity Invoiced", 0,'<Precision,2:2><Sign><Integer Thousand><Decimals>'));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(PurchRcptLine."Line No."));
                        OutStream.WRITETEXT(CSVFieldSeparator);
                        // OutStream.WRITETEXT(CSVFieldSeparator);
                        OutStream.WRITETEXT(Format(CR) + Format(LF));
                                    
                           
               
                  UNTIL PurchRcptLine.NEXT() = 0;
                
            until PurchRcptHdr.Next() = 0;
          until PurchaseHdr.Next() = 0;  
        If DataExist then begin
            TempBlob.CREATEINSTREAM(InStream, TextEncoding::UTF8);
        
            
            EskerSetup.Get();
            AccessKey := EskerSetup."Access Key";
            SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
            AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup."Master Data", SAS);
            // Create and upload the file
            AFSOperationResponse := AFSFileClient.CreateFile(FileName, InStream);
            if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());
            
            AFSOperationResponse := AFSFileClient.PutFileStream(FileName, InStream);
            if not AFSOperationResponse.IsSuccessful() then
                Error(AFSOperationResponse.GetError());
            
        end;
    end;
}
 
   
 