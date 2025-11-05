codeunit 50208 "Esker PuchLineItem Export"
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
        PurchaseLine: Record "Purchase Line";
        PL: Record "Purchase Line";
        EskerSetup: Record "Esker Azure Parameters";
        PurchaseHeader: Record "Purchase Header";
        AccessKey: SecretText;
    begin
        PL.Reset();
        PL.SetRange("PO Exported",true);
        PL.SetRange(Type,PL.Type::Item);
        if PL.IsEmpty then 
          Exit;
          
        EskerSetup.Get();
        TempBlob.CreateOutStream(OutStream);
        Xmlport.Export(Xmlport::"Purchase Line Export", OutStream);
        TempBlob.CreateInStream(InStream);
        CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__PurchaseorderItemsBSG__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';
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
