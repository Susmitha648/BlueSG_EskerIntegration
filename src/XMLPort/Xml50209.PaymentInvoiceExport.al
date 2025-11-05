#pragma warning disable AA0215
/// <summary>
/// XmlPort PaymentInvoiceExport (ID 50209).
/// </summary>
xmlport 50209 PaymentInvoiceExport
#pragma warning restore AA0215
{
    Caption = 'PaymentInvoiceExport';
    FileName = 'BLUESGESKER__PaymentInvoice.csv';
    Format = VariableText;
    Direction = Export;
    TextEncoding = UTF8;
    FieldSeparator = ';';
    FieldDelimiter = '';
    TableSeparator = '<CR><LF>';
    UseRequestPage = false;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(CompanyCode)
                {
                }
                textelement(VendorNumber)
                {
                }
                textelement(InvoiceNumber)
                {
                }
                textelement(PaymentDate)
                {
                }
                textelement(PaymentMethod)
                {
                }
                textelement(PaymentReference)
                {
                }
            }
            tableelement(VendorLedgerEntry; "Vendor Ledger Entry")
            {
                SourceTableView = sorting("Entry No.") Where("Document Type" = filter(Invoice|"Credit Memo"), "Closed by Entry No." = Filter(<> 0), "Exported to Esker" = const(false));
                textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                fieldelement(VendorNo; VendorLedgerEntry."Vendor No.")
                {
                }
                fieldelement(DocumentNo; VendorLedgerEntry."External Document No.")
                {
                }
                textelement(PostingDate)
                {
                    trigger OnBeforePassVariable()
                    var
                    VendLedgerEntry : Record "Vendor Ledger Entry";
                    begin
                        VendLedgerEntry.Reset();
                        VendLedgerEntry.SetRange("Entry No.",VendorLedgerEntry."Closed by Entry No.");
                        VendLedgerEntry.SetRange("Document Type",VendLedgerEntry."Document Type"::Payment);
                        If VendLedgerEntry.FindFirst() then
                        PostingDate := Format(VendLedgerEntry."Posting Date",10,'<Year4>-<Month,2>-<Day,2>');
                    end;
                }
                fieldelement(PaymentMethodCode; VendorLedgerEntry."Payment Method Code")
                {
                }
                fieldelement(PaymentReference; VendorLedgerEntry."Payment Reference")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    VendorLedgerEntry."XML Created" := True;
                    VendorLedgerEntry.Modify();
                end;
            }
        }
    }
     trigger OnInitXmlPort();
    begin
        CompanyCode := 'Company code';
        VendorNumber := 'Vendor number';
        InvoiceNumber := 'Invoice number';
        PaymentDate := 'Payment date';
        PaymentMethod := 'Payment method';
        PaymentReference := 'Payment reference';
        

        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
}
