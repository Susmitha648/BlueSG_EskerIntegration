codeunit 50209 "Esker PyamentInvoice Export"
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
        FilePath: Text[200];
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        EskerSetup: Record "Esker Azure Parameters";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        AccessKey: SecretText;
    begin
        VLE.Reset();
        VLE.SetRange("Exported to Esker", false);
        VLE.SetFilter("Closed by Entry No.", '<>%1', 0);
        VLE.SetFilter("Document Type",'%1|%2', VLE."Document Type"::Invoice,VLE."Document Type"::"Credit Memo");
        If VLE.IsEmpty then
            Exit;

        TempBlob.CreateOutStream(OutStream);
        Xmlport.Export(Xmlport::"PaymentInvoiceExport", OutStream);
        TempBlob.CreateInStream(InStream);
        CompanyInfo.Get();
        FileName := CompanyInfo."Company Code" + 'ESKER__PaymentInvoice__' + FORMAT(CurrentDateTime, 0, '<Year4><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2>') + '.csv';
        //DownloadFromStream(InStream, '', '', '', FileName);
        EskerSetup.Get();
        AccessKey := EskerSetup."Access Key";
        SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
        AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup."Paid Invoices", SAS);
        // Create and upload the file
        AFSOperationResponse := AFSFileClient.CreateFile(FileName, InStream);
        if not AFSOperationResponse.IsSuccessful() then
            Error(AFSOperationResponse.GetError());

        AFSOperationResponse := AFSFileClient.PutFileStream(FileName, InStream);
        if AFSOperationResponse.IsSuccessful() then begin
            VendorLedgerEntry.Reset();
            VendorLedgerEntry.SetRange("XMl Created", true);
            VendorLedgerEntry.SetRange("Exported to Esker", false);
            If VendorLedgerEntry.FindSet(true) then
                repeat
                    VendorLedgerEntry."Exported to Esker" := True;
                    VendorLedgerEntry.Modify();
                until VendorLedgerEntry.Next() = 0;
        end else begin
            VendorLedgerEntry.Reset();
            VendorLedgerEntry.SetRange("XMl Created", true);
            VendorLedgerEntry.SetRange("Exported to Esker", false);
            If VendorLedgerEntry.FindSet(true) then
                repeat
                    VendorLedgerEntry."XMl Created" := false;
                    VendorLedgerEntry.Modify();
                until VendorLedgerEntry.Next() = 0;
        end;
    end;
}
