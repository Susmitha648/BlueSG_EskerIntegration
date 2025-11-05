xmlport 50213 StagingXMLportSHeader
{
    Format = FixedText;
    Direction = Import;
    TextEncoding = UTF8;
    UseRequestPage = false;
    TableSeparator = '';
    Caption = 'Import PO Xml';
    schema
    {
        textelement(Invoice)
        {
            tableelement(POHeaderStaging; "PO Header Staging")
            {
                fieldelement(NetAmount; POHeaderStaging."Net Amount")
                {
                }
                fieldelement(CalculateTax; POHeaderStaging."Calculate Tax")
                {
                }
                fieldelement(CompanyCode; POHeaderStaging."Company Code")
                {
                }
                fieldelement(CreatedDateTime; POHeaderStaging."Created DateTime")
                {
                }
                fieldelement(DueDate; POHeaderStaging."Due Date")
                {
                }
                fieldelement(ERPLinkingDate; POHeaderStaging."ERP Linking Date")
                {
                }
                fieldelement(ERPMMInvoiceNumber; POHeaderStaging."ERP MM Invoice Number")
                {
                }
                fieldelement(ERPPaymentBlocked; POHeaderStaging."ERP Payment Blocked")
                {
                }
                fieldelement(ERPPostingDate; POHeaderStaging."ERP Posting Date")
                {
                }
                fieldelement(ERPSystem; POHeaderStaging."ERP System")
                {
                }
                fieldelement(EntryNo; POHeaderStaging."Entry No.")
                {
                }
                fieldelement(ErrorMessage; POHeaderStaging."Error Message")
                {
                }
                fieldelement(ExchangeRate; POHeaderStaging."Exchange Rate")
                {
                }
                fieldelement(GRIV; POHeaderStaging.GRIV)
                {
                }
                fieldelement(Generic; POHeaderStaging.Generic)
                {
                }
                fieldelement(GoodsReceipt; POHeaderStaging."Goods Receipt")
                {
                }
                fieldelement(HeaderText; POHeaderStaging."Header Text")
                {
                }
                fieldelement(InvoiceAmount; POHeaderStaging."Invoice Amount")
                {
                }
                fieldelement(InvoiceCurrency; POHeaderStaging."Invoice Currency")
                {
                }
                fieldelement(InvoiceDate; POHeaderStaging."Invoice Date")
                {
                }
                fieldelement(InvoiceDescription; POHeaderStaging."Invoice Description")
                {
                }
                fieldelement(InvoiceNo; POHeaderStaging."Invoice No.")
                {
                }
                fieldelement(InvoiceReferenceNo; POHeaderStaging."Invoice Reference No.")
                {
                }
                fieldelement(InvoiceType; POHeaderStaging."Invoice Type")
                {
                }
                fieldelement(LocalCurrency; POHeaderStaging."Local Currency")
                {
                }
                fieldelement(LocalInvoiceAmount; POHeaderStaging."Local Invoice Amount")
                {
                }
                fieldelement(LocalNetAmount; POHeaderStaging."Local Net Amount")
                {
                }
                fieldelement(LocalTaxAmount; POHeaderStaging."Local Tax Amount")
                {
                }
                fieldelement(ManualLink; POHeaderStaging."Manual Link")
                {
                }
                fieldelement(OrderNo; POHeaderStaging."Order No.")
                {
                }
                fieldelement(PaymentApprovalStatus; POHeaderStaging."Payment Approval Status")
                {
                }
                fieldelement(PaymentTerms; POHeaderStaging."Payment Terms")
                {
                }
                fieldelement(PostingDate; POHeaderStaging."Posting Date")
                {
                }
                fieldelement(ProcessingStatus; POHeaderStaging."Processing Status")
                {
                }
                fieldelement(RUID; POHeaderStaging.RUID)
                {
                }
                fieldelement(ReceptionMethod; POHeaderStaging."Reception Method")
                {
                }
                fieldelement(SAPPaymentMethod; POHeaderStaging."SAP Payment Method")
                {
                }
                fieldelement(SystemCreatedAt; POHeaderStaging.SystemCreatedAt)
                {
                }
                fieldelement(SystemCreatedBy; POHeaderStaging.SystemCreatedBy)
                {
                }
                fieldelement(SystemId; POHeaderStaging.SystemId)
                {
                }
                fieldelement(SystemModifiedAt; POHeaderStaging.SystemModifiedAt)
                {
                }
                fieldelement(SystemModifiedBy; POHeaderStaging.SystemModifiedBy)
                {
                }
                fieldelement(TouchlessDone; POHeaderStaging."Touchless Done")
                {
                }
                fieldelement(TouchlessEnabled; POHeaderStaging."Touchless Enabled")
                {
                }
                fieldelement(UnplannedDeliveryCost; POHeaderStaging."Unplanned Delivery Cost")
                {
                }
                fieldelement(VendorCity; POHeaderStaging."Vendor City")
                {
                }
                fieldelement(VendorCountry; POHeaderStaging."Vendor Country")
                {
                }
                fieldelement(VendorName; POHeaderStaging."Vendor Name")
                {
                }
                fieldelement(VendorNo; POHeaderStaging."Vendor No.")
                {
                }
                fieldelement(VendorPostalBOX; POHeaderStaging."Vendor Postal BOX")
                {
                }
                fieldelement(VendorRegion; POHeaderStaging."Vendor Region")
                {
                }
                fieldelement(VendorStreet; POHeaderStaging."Vendor Street")
                {
                }
                fieldelement(VendorZipcode; POHeaderStaging."Vendor Zip code")
                {
                }
                fieldelement(VerifacationDate; POHeaderStaging."Verifacation Date")
                {
                }
                fieldelement(Z_BU; POHeaderStaging."Z_BU ")
                {
                }
                fieldelement(Z_CompanyName; POHeaderStaging.Z_CompanyName)
                {
                }
                fieldelement(Z_Data_Before_WSCall; POHeaderStaging.Z_Data_Before_WSCall)
                {
                }
                fieldelement(Z_PO_OpenAmount; POHeaderStaging.Z_PO_OpenAmount)
                {
                }
                fieldelement(Z_VendorExchangeRate; POHeaderStaging.Z_VendorExchangeRate)
                {
                }
                fieldelement(Z_WS_Call_Response; POHeaderStaging.Z_WS_Call_Response)
                {
                }
                fieldelement(Z_WorkshopInvoice; POHeaderStaging.Z_WorkshopInvoice)
                {
                }



                // PO staging are starting from here
                tableelement(POLineStaging; "PO Line Staging")
                {
                    LinkTable = POHeaderStaging;
                    LinkFields = "Entry No." = field("Entry No.");

                    fieldelement(AccountAssignmentCategory; POLineStaging."Account Assignment Category")
                    {
                    }
                    fieldelement(Amount; POLineStaging.Amount)
                    {
                    }
                    fieldelement(BillingPeriod; POLineStaging."Billing Period")
                    {
                    }
                    fieldelement(CCDescription; POLineStaging.CCDescription)
                    {
                    }
                    fieldelement(ChassisNumber; POLineStaging."Chassis Number")
                    {
                    }
                    fieldelement(ConsoGroupCode; POLineStaging."Conso Group Code")
                    {
                    }
                    fieldelement(CostCenter; POLineStaging."Cost Center")
                    {
                    }
                    fieldelement(DeliveryNote; POLineStaging."Delivery Note")
                    {
                    }
                    fieldelement(DepartmentCode; POLineStaging."Department Code")
                    {
                    }
                    fieldelement(DifferentInvoicingParty; POLineStaging."Different Invoicing Party")
                    {
                    }
                    fieldelement(EntryNo; POLineStaging."Entry No.")
                    {
                    }
                    fieldelement(ErrorMessage; POLineStaging."Error Message")
                    {
                    }
                    fieldelement(FamilyCode; POLineStaging."Family Code")
                    {
                    }
                    fieldelement(FranchiseCode; POLineStaging."Franchise Code")
                    {
                    }
                    fieldelement(GLAccount; POLineStaging."GL Account")
                    {
                    }
                    fieldelement(GLDescription; POLineStaging."GL Description")
                    {
                    }
                    fieldelement(GoodsReceiptNo; POLineStaging."Goods Receipt No.")
                    {
                    }
                    fieldelement(InternalOrder; POLineStaging."Internal Order ")
                    {
                    }
                    fieldelement(ItemNo; POLineStaging."Item No.")
                    {
                    }
                    fieldelement(ItemTaxGroup; POLineStaging."Item Tax Group")
                    {
                    }
                    fieldelement(LineNo; POLineStaging."Line No.")
                    {
                    }
                    fieldelement(LineType; POLineStaging."Line Type")
                    {
                    }
                    fieldelement(OrderNo; POLineStaging."Order No.")
                    {
                    }
                    fieldelement(PartyNo; POLineStaging."Part No.")
                    {
                    }
                    fieldelement(ProcessingStatus; POLineStaging."Processing Status")
                    {
                    }
                    fieldelement(Quantity; POLineStaging.Quantity)
                    {
                    }
                    fieldelement(SystemCreatedAt; POLineStaging.SystemCreatedAt)
                    {
                    }
                    fieldelement(SystemCreatedBy; POLineStaging.SystemCreatedBy)
                    {
                    }
                    fieldelement(SystemId; POLineStaging.SystemId)
                    {
                    }
                    fieldelement(SystemModifiedAt; POLineStaging.SystemModifiedAt)
                    {
                    }
                    fieldelement(SystemModifiedBy; POLineStaging.SystemModifiedBy)
                    {
                    }
                    fieldelement(TaxAmount; POLineStaging."Tax Amount")
                    {
                    }
                    fieldelement(TaxCode; POLineStaging."Tax Code")
                    {
                    }
                    fieldelement(TaxGroup; POLineStaging."Tax Group")
                    {
                    }
                    fieldelement(TaxJurisdiction; POLineStaging."Tax Jurisdiction")
                    {
                    }
                    fieldelement(TaxRate; POLineStaging."Tax Rate")
                    {
                    }
                    fieldelement(UOMCode; POLineStaging."UOM Code")
                    {
                    }
                    fieldelement(UnitPrice; POLineStaging."Unit Price")
                    {
                    }
                    fieldelement(VehicleNumber; POLineStaging."Vehicle Number")
                    {
                    }
                    fieldelement(VehicleNumberCode; POLineStaging."Vehicle Number Code")
                    {
                    }
                    fieldelement(WorkDate; POLineStaging."Work Date")
                    {
                    }
                    fieldelement(WorkOrder; POLineStaging."Work Order")
                    {
                    }
                    fieldelement(Z_CalculatedUnitPrice; POLineStaging.Z_CalculatedUnitPrice)
                    {
                    }
                    fieldelement(Z_CalculatedUnitPriceBeforeDiscount; POLineStaging.Z_CalculatedUnitPriceDiscount)
                    {
                    }
                    fieldelement(Z_DiscountPercentage; POLineStaging.Z_DiscountPercentage)
                    {
                    }
                    fieldelement(Z_DiscountedUnitPrice; POLineStaging.Z_DiscountedUnitPrice)
                    {
                    }
                    fieldelement(Z_RevPackgPlanCode; POLineStaging.Z_RevPackgPlanCode)
                    {
                    }




                }
            }
        }
        // requestpage
        // {
        //     layout
        //     {
        //         area(Content)
        //         {
        //             group(GroupName)
        //             {
        //             }
        //         }
        //     }
        //     actions
        //     {
        //         area(Processing)
        //         {
        //         }
        //     }
        // }
    }


    trigger OnPostXmlPort()
    var
        POHeaderRec: Record "PO Header Staging";
        POLineRec: Record "PO Line Staging";

    begin
        if POHeaderRec.Insert(true) then begin

            POHeaderRec."RUID" := POHeaderStaging.RUID;
            POHeaderRec."Company Code" := POHeaderStaging."Company Code";
            POHeaderRec."ERP Linking Date" := POHeaderStaging."ERP Linking Date";
            POHeaderRec."ERP Posting Date" := POHeaderStaging."ERP Posting Date";
            POHeaderRec."Invoice Amount" := POHeaderStaging."Invoice Amount";
            POHeaderRec."Invoice Currency" := POHeaderStaging."Invoice Currency";
            POHeaderRec."Invoice Date" := POHeaderStaging."Invoice Date";
            POHeaderRec."Invoice No." := POHeaderStaging."Invoice No.";
            POHeaderRec."Vendor No." := POHeaderStaging."Vendor No.";
            POHeaderRec."Vendor Name" := POHeaderStaging."Vendor Name";
            POHeaderRec."Processing Status" := POHeaderStaging."Processing Status";
            POHeaderRec.Insert();
        end;
        POLineRec.Init();
        POLineRec."Entry No." := POHeaderRec."Entry No."; // validating header and lines
        POLineRec."Line No." := POLineStaging."Line No.";
        POLineRec."Order No." := POLineStaging."Order No.";
        POLineRec."Item No." := POLineStaging."Item No.";
        POLineRec."Quantity" := POLineStaging.Quantity;
        POLineRec."Unit Price" := POLineStaging."Unit Price";
        POLineRec."Amount" := POLineStaging."Amount";
        POLineRec.Insert();
    end;


}
