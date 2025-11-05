Report 50200 "PO Invoice Process"
{
    ApplicationArea = All;
    Caption = 'PO Invoice Process';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(POHeaderStaging; "PO Header Staging")
        {

            RequestFilterFields = "Order No.";
            //DataItemTableView = Where(Status = Const(Imported), Status = Const(Error));
            trigger
            OnAfterGetRecord()
            var
                PurchaseOrdr: Record "Purch. Inv. Header";
                xmlDec: XmlDeclaration;
                RootNode: XmlElement;
                ChildNode: XmlElement;
                XMLTxt: xmltext;
                ReadTxt: Text;
                WriteTxt: Text;
                SucChildNode: XmlElement;
                SucXMLTxt: xmltext;
                SucReadTxt: Text;
                SucWriteTxt: Text;
                SucInstream : InStream;
                SucOutStream : OutStream;
                SucRootNode : XmlElement;
                SucXmlDoc : XmlDocument;
                InvoicNo : Text;
            begin
                Commit();
                If not Codeunit.Run(CodeUnit::"PO Invoice Process", POHeaderStaging) then begin
                    POHeaderStaging.Status := POHeaderStaging.Status::Error;
                    POHeaderStaging."Process Error" := GetLastErrorText();
                    POHeaderStaging.Modify();


                    XmlDoc := XmlDocument.Create();
                    RootNode := XmlElement.Create('ERPAck');
                    XmlDoc.Add(RootNode);
                    
                    Clear(ChildNode);
                    ChildNode := XmlElement.Create('EskerInvoiceID');
                    XMLTxt := XmlText.Create(POHeaderStaging.RUID);
                    ChildNode.add(XMLTxt);
                    RootNode.add(ChildNode);

                    Clear(ChildNode);
                    ChildNode := XmlElement.Create('ERPPostingError');
                    XMLTxt := XmlText.Create(POHeaderStaging."Process Error");
                    ChildNode.add(XMLTxt);
                    RootNode.add(ChildNode);


                    TempBlob.CreateInStream(InStream);
                    TempBlob.CreateOutStream(OutStream);
                    XmlDoc.WriteTo(OutStream);
                    OutStream.WriteText(WriteTxt);
                    TempBlob.CreateInStream(InStream);
                    Clear(InvoicNo);
                    InvoicNo := CopyStr(POHeaderStaging.RUID,StrPos(POHeaderStaging.RUID, '.') + 1);

                    FileName := 'ErpAck_Fail_' + InvoicNo + '.xml';


                    EskerSetup.Get();
                    AccessKey := EskerSetup."Access Key";
                    SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
                    AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup.Acknowledgement, SAS);
                    // Create and upload the file
                    AFSOperationResponse := AFSFileClient.CreateFile(FileName, InStream);
                    if not AFSOperationResponse.IsSuccessful() then
                        Error(AFSOperationResponse.GetError());

                    AFSOperationResponse := AFSFileClient.PutFileStream(FileName, InStream);
                    if not AFSOperationResponse.IsSuccessful() then
                        Error(AFSOperationResponse.GetError());

                end else begin
                    POHeaderStaging.Status := POHeaderStaging.Status::Processed;
                    POHeaderStaging."Process Error" := '';
                    POHeaderStaging.Modify();
                    PurchaseOrdr.Reset();
                    PurchaseOrdr.SetAscending("No.",false);
                    PurchaseOrdr.SetRange("Order No.",POHeaderStaging."Order No.");
                    If PurchaseOrdr.FindFirst() then;
                       
                    SucXmlDoc := XmlDocument.Create();
                    SucRootNode := XmlElement.Create('ERPAck');
                    SucXmlDoc.Add(SucRootNode);
                    
                    SucChildNode := XmlElement.Create('EskerInvoiceID');
                    SucXMLTxt := XmlText.Create(POHeaderStaging.RUID);
                    SucChildNode.add(SucXMLTxt);
                    SucRootNode.add(SucChildNode);
                    
                    
                    SucChildNode := XmlElement.Create('ERPID');
                    SucXMLTxt := XmlText.Create(PurchaseOrdr."No.");
                    SucChildNode.add(SucXMLTxt);
                    SucRootNode.add(SucChildNode);

                    Clear(TempBlob);
                    TempBlob.CreateInStream(SucInstream);
                    TempBlob.CreateOutStream(SucOutStream);
                    SucXmlDoc.WriteTo(SucOutStream);
                    SucOutStream.WriteText(SucWriteTxt);
                    TempBlob.CreateInStream(SucInstream);
                    
                    Clear(InvoicNo);
                    InvoicNo := CopyStr(POHeaderStaging.RUID,StrPos(POHeaderStaging.RUID, '.')+1);
                    FileName := 'ErpAck_Success_' + InvoicNo + '.xml';
                    EskerSetup.Get();
                    AccessKey := EskerSetup."Access Key";
                    SAS := StorageServiceAuthorization.CreateSharedKey(AccessKey);
                    AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup.Acknowledgement, SAS);
                    // Create and upload the file
                    AFSOperationResponse := AFSFileClient.CreateFile(FileName, SucInstream);
                    if not AFSOperationResponse.IsSuccessful() then
                        Error(AFSOperationResponse.GetError());

                    AFSOperationResponse := AFSFileClient.PutFileStream(FileName, SucInstream);
                    if not AFSOperationResponse.IsSuccessful() then
                        Error(AFSOperationResponse.GetError());
                end;
                
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                POHeaderStaging.SetRange("Company Code", CompanyInfo."Company Code");
                POHeaderStaging.SetFilter(Status, '%1', POHeaderStaging.Status::Imported);
                // POHeaderStaging.SetRange("Entry No.",79);
            end;

        }

    }
    var
        CompanyInfo: Record "Company Information";
        XmlDoc: XmlDocument;
        RootElement: XmlElement;
        POElement: XmlElement;
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
        AccessKey: SecretText;
        xmlcontent: BigText;

}
