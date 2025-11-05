#pragma warning disable AA0215
/// <summary>
/// Report Non PO Invoice Process (ID 50201).
/// </summary>
Report 50201 "Non PO Invoice Process"
#pragma warning restore AA0215
{
    ApplicationArea = All;
    Caption = 'Non PO Invoice Process';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(NonPOHeaderStaging; "Non PO Header Staging")
        {

            RequestFilterFields = "Order No.";
            trigger
            OnAfterGetRecord()
            var
                PurchaseInvHdr: Record "Purch. Inv. Header";
                PurchCrdMemoHdr: Record "Purch. Cr. Memo Hdr.";
                TempBlob: Codeunit "Temp Blob";
                RootNode: XmlElement;
                ChildNode: XmlElement;
                XMLTxt: xmltext;
                WriteTxt: Text;
                XmlDoc: XmlDocument;
                OutStream: OutStream;
                InStream: InStream;
                FileName: Text;
                InvoicNo: Text;
                RUID: Text;
            begin
                Commit();
                If not Codeunit.Run(CodeUnit::"Non PO Invoice Process", NonPOHeaderStaging) then begin

                    NonPOHeaderStaging.Status := NonPOHeaderStaging.Status::Error;
                    NonPOHeaderStaging."Process Error" := GetLastErrorText();
                    NonPOHeaderStaging.Modify();

                    XmlDoc := XmlDocument.Create();
                    RootNode := XmlElement.Create('ERPAck');
                    XmlDoc.Add(RootNode);
                    ChildNode := XmlElement.Create('EskerInvoiceID');
                    XMLTxt := XmlText.Create(NonPOHeaderStaging.RUID);
                    ChildNode.add(XMLTxt);
                    RootNode.add(ChildNode);
                    ChildNode := XmlElement.Create('ERPPostingError');
                    XMLTxt := XmlText.Create(NonPOHeaderStaging."Process Error");
                    ChildNode.add(XMLTxt);
                    RootNode.add(ChildNode);

                    Clear(TempBlob);
                    TempBlob.CreateInStream(InStream);
                    TempBlob.CreateOutStream(OutStream);
                    XmlDoc.WriteTo(OutStream);
                    OutStream.WriteText(WriteTxt);
                    TempBlob.CreateInStream(InStream);
                    Clear(RUID);
                    RUID := CopyStr(NonPOHeaderStaging.RUID, StrPos(NonPOHeaderStaging.RUID, '.') + 1);

                    FileName := 'ErpAck_Fail_' + RUID + '.xml';


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
                    NonPOHeaderStaging.Status := NonPOHeaderStaging.Status::Processed;
                    NonPOHeaderStaging."Process Error" := '';

                    If NonPOHeaderStaging."Document Type" = 'Invoice' then begin
                        PurchaseInvHdr.Reset();
                        PurchaseInvHdr.SetAscending("No.", false);
                        PurchaseInvHdr.SetRange("Vendor Invoice No.", NonPOHeaderStaging."Invoice No.");
                        PurchaseInvHdr.SetRange("Buy-from Vendor No.", NonPOHeaderStaging."Vendor No.");
                        If PurchaseInvHdr.FindFirst() then
                            NonPOHeaderStaging."Posted Purch. Invoice No." := PurchaseInvHdr."No.";
                    end else begin
                        PurchCrdMemoHdr.Reset();
                        PurchCrdMemoHdr.SetAscending("No.", false);
                        PurchCrdMemoHdr.SetRange("Vendor Cr. Memo No.", NonPOHeaderStaging."Invoice No.");
                        PurchCrdMemoHdr.SetRange("Buy-from Vendor No.", NonPOHeaderStaging."Vendor No.");
                        If PurchCrdMemoHdr.FindFirst() then;
                            NonPOHeaderStaging."Posted Purch. Invoice No." := PurchCrdMemoHdr."No.";
                            
                    end;

                    NonPOHeaderStaging.Modify();
                    XmlDoc := XmlDocument.Create();
                    RootNode := XmlElement.Create('ERPAck');
                    XmlDoc.Add(RootNode);

                    ChildNode := XmlElement.Create('EskerInvoiceID');
                    XMLTxt := XmlText.Create(NonPOHeaderStaging.RUID);
                    ChildNode.add(XMLTxt);
                    RootNode.add(ChildNode);

                    ChildNode := XmlElement.Create('ERPID');
                    XMLTxt := XmlText.Create(NonPOHeaderStaging."Posted Purch. Invoice No.");
                    ChildNode.add(XMLTxt);
                    RootNode.add(ChildNode);

                    Clear(TempBlob);
                    TempBlob.CreateInStream(InStream);
                    TempBlob.CreateOutStream(OutStream);
                    XmlDoc.WriteTo(OutStream);
                    OutStream.WriteText(WriteTxt);
                    TempBlob.CreateInStream(InStream);

                    Clear(InvoicNo);
                    InvoicNo := CopyStr(NonPOHeaderStaging.RUID, StrPos(NonPOHeaderStaging.RUID, '.') + 1);


                    FileName := 'ErpAck_Success_' + InvoicNo + '.xml';

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
                end;

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                NonPOHeaderStaging.SetRange("Company Code", CompanyInfo."Company Code");
                NonPOHeaderStaging.SetFilter(Status, '%1', NonPOHeaderStaging.Status::Imported);
            end;

        }

    }

    var
        CompanyInfo: Record "Company Information";
        EskerSetup: Record "Esker Azure Parameters";
        AFSFileClient: Codeunit "AFS File Client";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        SAS: Interface "Storage Service Authorization";
        AccessKey: SecretText;

}
