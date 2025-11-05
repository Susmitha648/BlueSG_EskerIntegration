report 50203 "PO Invoice Import"
{
    ApplicationArea = All;
    Caption = 'PO Invoice Import';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                EskerSetup: Record "Esker Azure Parameters";
                AzureDirectory: Record "AFS Directory Content";
                POImportError: Record "PO Import Error";
                ImportError: Record "PO Import Error";
                SAS: Interface "Storage Service Authorization";
                SASGetFile: Interface "Storage Service Authorization";
                singleinstance: Codeunit SingleInstance;
                StorageServiceAuthorization: Codeunit "Storage Service Authorization";
                StorageServiceAuthorizationGetFile: Codeunit "Storage Service Authorization";
                AFSFileClientGetInstream: Codeunit "AFS File Client";
                AFSOperationResponse: Codeunit "AFS Operation Response";
                AFSFileClient: Codeunit "AFS File Client";
                AFSFileClientGetFile: Codeunit "AFS File Client";
                OutStream: OutStream;
                FileInStream: InStream;
                AccessKey: SecretText;
                POInvImport: Codeunit "PO Invoice Import";
                xmlDec: XmlDeclaration;
                RootNode: XmlElement;
                ChildNode: XmlElement;
                XMLTxt: xmltext;
                ReadTxt: Text;
                WriteTxt: Text;
                XmlDocErrorImport: XmlDocument;
                TempBlob: Codeunit "Temp Blob";
                InStream: InStream;
                FileName: Text;
                RUID: Text;
            begin
                Clear(AccessKey);
                Clear(SAS);
                EskerSetup.Get();
                AccessKey := EskerSetup."Access Key";
                SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
                AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share", SAS);
                AFSOperationResponse := AFSFileClient.ListDirectory(EskerSetup."PO Invoices", AzureDirectory);

                AzureDirectory.Reset();
                AzureDirectory.SetRange("Resource Type", AzureDirectory."Resource Type"::File);
                If AzureDirectory.FindSet() then
                    repeat
                         Clear(POInvImport);
                        POInvImport.SetAzureDirectoryParameters(AzureDirectory, SAS);
                         
                        if not POInvImport.Run() then begin

                            if singleinstance.IsLineProcessStarted() then begin
                                //Datalog.SetRange("Entry No.", Data."Entry No.");
                                //if Datalog.FindFirst() then begin
                                POImportError.Init();
                                POImportError."Entry No." := 0;
                                POImportError."Import Error" := GetLastErrorText();
                                POImportError."Line Error" := true;
                                POImportError.RUID := singleinstance.GetRUID();
                                POImportError."File Name" := AzureDirectory.Name;
                                POImportError.Insert();
                                //end;
                            end else begin
                                // Datalog.SetRange("Entry No.", Data."Entry No.");
                                //if Datalog.FindFirst() then begin
                                POImportError.Init();
                                POImportError."Entry No." := 0;
                                POImportError."Import Error" := GetLastErrorText();

                                POImportError.RUID := singleinstance.GetRUID();
                                POImportError."File Name" := AzureDirectory.Name;
                                POImportError.Insert();
                                // end;

                            end;
                            Clear(AFSFileClientGetInstream);
                            AFSFileClientGetInstream.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup."PO Invoices", SAS);
                            AFSOperationResponse := AFSFileClientGetInstream.GetFileAsStream(AzureDirectory.Name, FileInStream);

                            Clear(AFSFileClientGetFile);

                            AFSFileClientGetFile.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup.Archive, SAS);
                            AFSFileClientGetFile.CreateFile(AzureDirectory.Name, FileInStream);
                            AFSOperationResponse := AFSFileClientGetFile.PutFileStream(AzureDirectory.Name, FileInStream);
                            If AFSOperationResponse.IsSuccessful() then
                                AFSOperationResponse := AFSFileClientGetInstream.DeleteFile(AzureDirectory.Name)
                            else
                                Error('%1', AFSOperationResponse.GetError());

                            //Send Acknowledgement for failed import
                            ImportError.Reset();
                            ImportError.SetRange("Acknowledgement Sent", False);
                            If ImportError.FindSet() then
                                repeat
                                    XmlDocErrorImport := XmlDocument.Create();
                                    RootNode := XmlElement.Create('ERPAck');
                                    XmlDocErrorImport.Add(RootNode);
                                    ChildNode := XmlElement.Create('EskerInvoiceID');
                                    XMLTxt := XmlText.Create(ImportError.RUID);
                                    ChildNode.add(XMLTxt);
                                    RootNode.add(ChildNode);
                                    ChildNode := XmlElement.Create('ERPPostingError');
                                    XMLTxt := XmlText.Create(ImportError."Import Error");
                                    ChildNode.add(XMLTxt);
                                    RootNode.add(ChildNode);

                                    Clear(TempBlob);
                                    TempBlob.CreateInStream(InStream);
                                    TempBlob.CreateOutStream(OutStream);
                                    XmlDocErrorImport.WriteTo(OutStream);
                                    OutStream.WriteText(WriteTxt);
                                    TempBlob.CreateInStream(InStream);
                                    Clear(RUID);
                                    RUID := CopyStr(ImportError.RUID, StrPos(ImportError.RUID, '.') + 1);

                                    FileName := 'ErpAck_Fail_' + RUID + '.xml';

                                    EskerSetup.Get();
                                    
                                    AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup.Acknowledgement, SAS);
                                    // Create and upload the file
                                    AFSOperationResponse := AFSFileClient.CreateFile(FileName, InStream);
                                    if not AFSOperationResponse.IsSuccessful() then
                                        Error(AFSOperationResponse.GetError());

                                    AFSOperationResponse := AFSFileClient.PutFileStream(FileName, InStream);
                                    if not AFSOperationResponse.IsSuccessful() then
                                        Error(AFSOperationResponse.GetError());
                                    ImportError."Acknowledgement Sent" := True;
                                    ImportError.Modify();
                                until ImportError.Next() = 0;

                        end;
                        commit;
                    until AzureDirectory.Next() = 0;
            end;
        }
    }
}
