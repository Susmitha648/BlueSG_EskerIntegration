codeunit 50215 "Esker Currencies Export"
{
    trigger OnRun()
    var
        Currency:Record Currency;
        CurrencyExchRate:Record "Currency Exchange Rate";
        CompanyInfo : Record "Company Information";
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
    begin
        CSVFieldSeparator := ';';
         CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__Currencies__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';
        CR := 13;
        LF := 10;
 
 
        TempBlob.CREATEOUTSTREAM(OutStream, TextEncoding::UTF8);
 
        OutStream.WRITETEXT('CompanyCode__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('RatioFrom__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('CurrencyFrom__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('RatioTo__');
        OutStream.WRITETEXT(CSVFieldSeparator);
        OutStream.WRITETEXT('Rate__');
        OutStream.WRITETEXT(Format(CR) + Format(LF));
 
       
 
        IF Currency.FINDSET(false) THEN BEGIN
            REPEAT
                CurrencyExchRate.Reset();
                CurrencyExchRate.SetAscending("Starting Date",false);
                CurrencyExchRate.SetRange("Currency Code",Currency.Code);
                if CurrencyExchRate.FindFirst() then begin
                
                    OutStream.WRITETEXT(CompanyInfo."Company Code");
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Format(CurrencyExchRate."Exchange Rate Amount"));
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Currency.Code);
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Format(CurrencyExchRate."Adjustment Exch. Rate Amount"));
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Format(CurrencyExchRate."Relational Exch. Rate Amount"));
                    OutStream.WRITETEXT(Format(CR) + Format(LF));
                end else begin
                    OutStream.WRITETEXT(CompanyInfo."Company Code");
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Format(1));
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Currency.Code);
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Format(1));
                    OutStream.WRITETEXT(CSVFieldSeparator);
                    OutStream.WRITETEXT(Format(1));
                    OutStream.WRITETEXT(Format(CR) + Format(LF));
                end;
               
            UNTIL Currency.NEXT = 0;
            TempBlob.CREATEINSTREAM(InStream, TextEncoding::UTF8);
        END;
        //DownloadFromStream(InStream, '', '', '', FileName);
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
}
 
   
 