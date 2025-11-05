codeunit 50211 "Esker GLAccount Export"
{
    trigger OnRun()
    var
        CompanyInfo: Record "Company Information";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageAccount: Text[100];
        FileShare: Text[100];
        SAS: Interface "Storage Service Authorization";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        FilePath: Text[200];
        EskerSetup: Record "Esker Azure Parameters";
        AccessKey: SecretText;
    begin
        TempBlob.CreateOutStream(OutStream);
        Xmlport.Export(Xmlport::"ExportGLAccountCsv", OutStream);
        TempBlob.CreateInStream(InStream);
        CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__GLaccount__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';

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