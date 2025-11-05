codeunit 50222 "PO Invoice Import"
{
    var
        SAS: Interface "Storage Service Authorization";
        AzureDirectory: Record "AFS Directory Content";

    trigger OnRun()
    var
        FileInStream: InStream;
        XmlDoc: XmlDocument;
        Root: XmlElement;
        NodeList: XmlNodeList;
        Node: XmlNode;
        e: XmlElement;
        Data: Record "PO Header Staging";
        DataLine: Record "PO Line Staging";
        AFSFileClient: Codeunit "AFS File Client";
        AFSFileClientGetFile: Codeunit "AFS File Client";
        EskerSetup: Record "Esker Azure Parameters";
        AFSOperationResponse: Codeunit "AFS Operation Response";
        StorageServiceAuthorization: Codeunit "Storage Service Authorization";
        AccessKey: SecretText;
        RUID: Text;
        AttributeCollection: XmlAttributeCollection;
        Attribute: XmlAttribute;
        POLine: Record "PO Line Staging";
        NodeListSec: XmlNodeList;
        Node2: xmlNode;
        g: XmlElement;
        SingleInstance: Codeunit SingleInstance;
    begin
        EskerSetup.Get();
        Clear(FileInStream);

        AFSFileClient.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup."PO Invoices", SAS);
        AFSOperationResponse := AFSFileClient.GetFileAsStream(AzureDirectory.Name, FileInStream);

        If AFSOperationResponse.IsSuccessful() then begin
            // FileInStream.ReadText(XMLContent);
            // Message('%1', XMLContent);
            If XmlDocument.ReadFrom(FileInStream, XmlDoc) then begin
                XmlDoc.GetRoot(Root);
                //Records := XmlDoc.GetChildNodes();
                XmlDoc.GetRoot(Root);
                AttributeCollection := Root.Attributes();
                AttributeCollection.Get('RUID', Attribute);
                RUID := Attribute.Value;
                SingleInstance.SetRUID(RUID);
                If XmlDoc.SelectNodes('Invoice', NodeList) then begin

                    Foreach Node in NodeList do begin

                        e := Node.AsXmlElement();
                        // Message('%1', e);
                        Data.Init();
                        Data."Entry No." := 0;
                        Data."Order No." := GetText(e, 'OrderNumber');
                        Data."Posting Date" := GetDateTime(e, 'PostingDate');
                        Data."ERP Linking Date" := GetDateTime(e, 'ERPLinkingDate');
                        Data."ERP Posting Date" := GetDateTime(e, 'ERPPostingDate');
                        Data."ERP Payment Blocked" := GetBoolean(e, 'ERPPaymentBlocked');
                        Data."Esker Exch. Rate Amount" := GetDecimal(e, 'Z_VendorExchangeRate');
                        Data.GRIV := GetBoolean(e, 'GRIV');
                        Data.RUID := RUID;
                        Data."Company Code" := GetText(e, 'CompanyCode');
                        Data."Vendor No." := GetText(e, 'VendorNumber');
                        Data."Vendor Name" := GetText(e, 'VendorName');
                        Data."Vendor City" := GetText(e, 'VendorCity');
                        Data."Vendor Country" := GetText(e, 'VendorCountry');
                        Data."Vendor Postal BOX" := GetText(e, 'VendorPOBox');
                        Data."Vendor Region" := GetText(e, 'VendorRegion');
                        Data."Vendor Street" := GetText(e, 'VendorStreet');
                        Data."Vendor Zip Code" := GetText(e, 'VendorZipCode');
                        Data."Verification Date" := GetDateTime(e, 'VerificationDate');
                        Data."Invoice Amount" := GetDecimal(e, 'InvoiceAmount');
                        Data."Invoice Currency" := GetText(e, 'InvoiceCurrency');
                        Data."Invoice Date" := GetDateTime(e, 'InvoiceDate');
                        Data."Invoice No." := GetText(e, 'InvoiceNumber');
                        Data."Local Currency" := GetText(e, 'LocalCurrency');
                        Data."Local Invoice Amount" := GetDecimal(e, 'LocalInvoiceAmount');
                        Data."Local Net Amount" := GetDecimal(e, 'LocalNetAmount');
                        Data."Local Tax Amount" := GetDecimal(e, 'LocalTaxAmount');
                        Data."Net Amount" := GetDecimal(e, 'NetAmount');
                        Data."Payment Terms" := GetText(e, 'PaymentTerms');
                        Data."Tax Amount" := GetDecimal(e, 'TaxAmount');
                        Data."Z_CompanyName" := GetText(e, 'Z_CompanyName');
                        Data."Z_BU " := GetText(e, 'Z_BU');
                        Data."Z_PO_OpenAmount" := GetDecimal(e, 'Z_PO_OpenAmount');
                        //Data."Z_VendorExchangeRate" := GetBoolean(e, 'Z_VendorExchangeRate');
                        Data.Status := Data.Status::Imported;
                        Data.Insert();
                    end;
                    XmlDoc.SelectNodes('//Invoice/LineItems/item', NodeListSec);

                    Foreach Node2 in NodeListSec do begin

                        g := Node2.AsXmlElement();
                        //Message('Test2%1', g);
                        DataLine.Init();
                        DataLine."Entry No." := Data."Entry No.";
                        DataLine."Order No." := GetText(g, 'OrderNumber');
                        POLine.Reset();
                        POLine.SetCurrentKey("Entry No.","Line No.","Order No.");
                        POLine.SetAscending("Line No.",false);
                        POLine.SetRange("Entry No.", Data."Entry No.");
                        POLine.SetRange("Order No.", DataLine."Order No.");
                        If POLine.Findfirst() then
                            DataLine."Line No." := POLine."Line No." + 10000
                        else
                            DataLine."Line No." := 10000;

                        SingleInstance.SetDataline(true);
                        
                        DataLine.Amount := GetDecimal(g, 'Amount');
                        DataLine."Delivery Note" := GetText(g, 'DeliveryNote');
                        DataLine.Description := GetText(g, 'Description');
                        DataLine."Goods Receipt No." := GetText(g, 'GoodsReceipt');
                        DataLine."Item No." := GetInteger(g, 'ItemNumber');
                        DataLine."Part No." := GetText(g, 'PartNumber');
                        DataLine.Quantity := GetDecimal(g, 'Quantity');
                        DataLine."Tax Amount" := GetDecimal(g, 'TaxAmount');
                        DataLine."Tax Code" := GetText(g, 'TaxCode');
                        DataLine.Z_DiscountPercentage := GetDecimal(g, 'Z_DiscountPercentage');
                        DataLine.Z_CalculatedUnitPrice := GetDecimal(g, 'Z_CalculatedUnitPrice');
                        DataLine.Z_CalculatedUnitPriceDiscount := GetDecimal(g, 'Z_CalculatedUnitPriceBeforeDiscount');
                        DataLine."UOM Code" := GetText(g, 'Z_UOM');
                        DataLine."Tax Group" := GetText(g, 'Z_TaxGroup');
                        DataLine."Franchise Code" := GetText(g, 'Z_FranchiseCode');
                        DataLine.Z_RevPackgPlanCode := GetText(g, 'Z_RevPackgPlanCode');
                        DataLine.Insert();

                    end;
                    Clear(AFSFileClientGetFile);

                    AFSFileClientGetFile.Initialize(EskerSetup."Azure Storage Account", EskerSetup."File Share" + '\' + EskerSetup.Archive, SAS);
                    AFSFileClientGetFile.CreateFile(AzureDirectory.Name, FileInStream);
                    AFSOperationResponse := AFSFileClientGetFile.PutFileStream(AzureDirectory.Name, FileInStream);
                    If AFSOperationResponse.IsSuccessful() then
                        AFSOperationResponse := AFSFileClient.DeleteFile(AzureDirectory.Name)
                    else
                        Error('%1', AFSOperationResponse.GetError());
                end;
            end;

        end else
            Error('%1', AFSOperationResponse.GetError());
            

    end;

    procedure SetAzureDirectoryParameters(var pAzureDirectory: Record "AFS Directory Content"; pSAS: Interface "Storage Service Authorization")
    begin
        AzureDirectory := pAzureDirectory;
        SAS := pSAS;
    end;

    procedure GetText(e: XmlElement; Name: Text): Text
    var
        FieldNode: XmlNode;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            exit(FieldNode.AsXmlElement().InnerText);
    end;

    procedure GetInteger(e: XmlElement; Name: Text): Integer
    var
        FieldNode: XmlNode;
        IntValue: Integer;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if Evaluate(IntValue, FieldNode.AsXmlElement().InnerText, 9) then
                exit(IntValue);
    end;

    procedure GetDecimal(e: XmlElement; Name: Text): Decimal
    var
        FieldNode: XmlNode;
        DecValue: Decimal;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if Evaluate(DecValue, FieldNode.AsXmlElement().InnerText, 9) then
                exit(DecValue);
    end;

    procedure GetDateTime(e: XmlElement; Name: Text): Date
    var
        FieldNode: XmlNode;
        DateTimeValue: Date;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if Evaluate(DateTimeValue, FieldNode.AsXmlElement().InnerText, 9) then
                exit(DateTimeValue);

    end;

    procedure GetBoolean(e: XmlElement; Name: Text): Boolean
    var
        FieldNode: XmlNode;
        BooleanValue: Boolean;
    begin
        foreach FieldNode in e.GetChildElements(Name) do
            if Evaluate(BooleanValue, FieldNode.AsXmlElement().InnerText, 9) then
                exit(BooleanValue);
    end;
}
