report 50202 NonPOInvociesImport
{
    ApplicationArea = All;
    Caption = 'NonPO Invoices Import';
    UsageCategory = Tasks;
    ProcessingOnly = True;
    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                XmlDoc: XmlDocument;
                Root: XmlElement;
                XMLContent: BigText;
                Records: XmlNodeList;
                NodeList: XmlNodeList;
                NodeListSec: XmlNodeList;
                Node: XmlNode;
                Node2: XmlNode;
                e: XmlElement;
                FileInStream: InStream;
                Data: Record "Non PO Header Staging";
                XMLBuffer: Record "XML Buffer" temporary;
                g: XmlElement;
                DataLine: Record "Non PO Line Staging";
                FileList: List of [Text];
                AFSFileClient: Codeunit "AFS File Client";
                AFSFileClientGetFile: Codeunit "AFS File Client";
                AFSFileClientGetInstream: Codeunit "AFS File Client";
                SAS: Interface "Storage Service Authorization";
                EskerSetup: Record "Esker Azure Parameters";
                AzureDirectory: Record "AFS Directory Content";
                AFSOperationResponse: Codeunit "AFS Operation Response";
                AccessKey: SecretText;
                StorageServiceAuthorization: Codeunit "Storage Service Authorization";
                NonPOInvImport: Codeunit "Non PO Invoices Import";
                singleinstance: Codeunit SingleInstance;
                LineProcessStarted: Boolean;
                Datalog: Record "Non PO Header Staging";
                NonPOImportError: Record "Non PO Import Errors";
                ImportError: Record "Non PO Import Errors";
                xmlDec: XmlDeclaration;
                RootNode: XmlElement;
                ChildNode: XmlElement;
                XMLTxt: xmltext;
                ReadTxt: Text;
                WriteTxt: Text;
                XmlDocErrorImport: XmlDocument;
                TempBlob: Codeunit "Temp Blob";
                OutStream: OutStream;
                InStream: InStream;
                FileName: Text;
                RUID: Text;
            begin
                EskerSetup.Get();
                AccessKey := EskerSetup."Access Key";
                SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
                AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share", SAS);
                AFSOperationResponse := AFSFileClient.ListDirectory(EskerSetup."Non PO Invoices", AzureDirectory);

                AzureDirectory.Reset();
                AzureDirectory.SetRange("Resource Type", AzureDirectory."Resource Type"::File);
                if AzureDirectory.FindSet() then
                    repeat

                        // Call the procedure to set Azure directory parameters
                        Clear(NonPOInvImport);
                        NonPOInvImport.SetAzureDirectoryParameters(AzureDirectory, SAS);
                        if not NonPOInvImport.Run() then begin

                            if singleinstance.IsLineProcessStarted() then begin
                                //Datalog.SetRange("Entry No.", Data."Entry No.");
                                //if Datalog.FindFirst() then begin
                                NonPOImportError.Init();
                                NonPOImportError."Entry No." := 0;
                                NonPOImportError."Import Error" := GetLastErrorText();
                                NonPOImportError."Line Error" := true;
                                NonPOImportError.RUID := singleinstance.GetRUID();
                                NonPOImportError."File Name" := AzureDirectory.Name;
                                NonPOImportError.Insert();
                                //end;
                            end else begin
                                // Datalog.SetRange("Entry No.", Data."Entry No.");
                                //if Datalog.FindFirst() then begin
                                NonPOImportError.Init();
                                NonPOImportError."Entry No." := 0;
                                NonPOImportError."Import Error" := GetLastErrorText();

                                NonPOImportError.RUID := singleinstance.GetRUID();
                                NonPOImportError."File Name" := AzureDirectory.Name;
                                NonPOImportError.Insert();
                                // end;

                            end;
                            Clear(AFSFileClientGetInstream);
                            AFSFileClientGetInstream.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup."Non PO Invoices", SAS);
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
                                    AccessKey := EskerSetup."Access Key";
                                    //SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
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
                    // Process each file
                    until AzureDirectory.Next() = 0;
            end;
        }
    }

}