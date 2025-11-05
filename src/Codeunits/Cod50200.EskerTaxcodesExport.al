codeunit 50200 "Esker Taxcodes Export"
{
    trigger OnRun()
    var
        CompanyInfo : Record "Company Information";
        EskerSetup: Record "Esker Azure Parameters";
        TempBlob: Codeunit "Temp Blob";
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
         StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
        SAS: Interface "Storage Service Authorization";
        AccessKey : SecretText;
        
    begin
        TempBlob.CreateOutStream(OutStream);
        Xmlport.Export(Xmlport::"VAT Posting Export",OutStream);
        TempBlob.CreateInStream(InStream);
        CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__Taxcodes__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';
        
        
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
  
    
