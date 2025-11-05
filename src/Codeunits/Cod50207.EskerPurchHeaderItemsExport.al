#pragma warning disable AA0215
/// <summary>
/// Codeunit Esker PurchHeaderItems Export (ID 50207).
/// </summary>
codeunit 50207 "Esker PurchHeaderItems Export"
#pragma warning restore AA0215
{
    trigger OnRun()
    var
        CompanyInfo: Record "Company Information";
        PurchaseHeader: Record "Purchase Header";
        PurchHdr: Record "Purchase Header";
        PH: Record "Purchase Header";
        EskerSetup: Record "Esker Azure Parameters";
        PurchaseLine: Record "Purchase Line";
        TempBlob: Codeunit "Temp Blob";
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
        SAS: Interface "Storage Service Authorization";
        AccessKey: SecretText;
    begin
        PH.Reset();
        PH.SetRange(Status, PH.Status::Released);
        If PH.IsEmpty then
            Exit;
        TempBlob.CreateOutStream(OutStream);
        Xmlport.Export(Xmlport::"Purchase Header Items Export", OutStream);
        TempBlob.CreateInStream(InStream);
        CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__PurchaseorderHeaders__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';
        // DownloadFromStream(InStream, '', '', '', FileName);


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
        if AFSOperationResponse.IsSuccessful() then begin
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("XMl Created", true);
            PurchaseHeader.SetRange("Exported to Esker", false);
            If PurchaseHeader.FindSet(true) then
                repeat
                    PurchaseHeader."Exported to Esker" := True;
                    PurchaseHeader.Modify();
                until PurchaseHeader.Next() = 0;
            PurchHdr.Reset();
            PurchHdr.SetRange("Exported to Esker", true);
            if PurchHdr.FindSet() then
                repeat
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SetRange("Document No.", PurchHdr."No.");
                    PurchaseLine.SetRange("PO Exported", False);
                    If PurchaseLine.FindSet(true) then
                        Repeat
                            PurchaseLine."PO Exported" := True;
                            PurchaseLine.Modify();
                        until PurchaseLine.Next() = 0;
                until PurchHdr.Next() = 0;
        end else begin
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("XMl Created", true);
            PurchaseHeader.SetRange("Exported to Esker", false);
            If PurchaseHeader.FindSet() then
                repeat
                    PurchaseHeader."XMl Created" := false;
                    PurchaseHeader.Modify();
                until PurchaseHeader.Next() = 0;
        end;

    end;

}
