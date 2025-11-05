page 50201 "PO Invoice"
{
    ApplicationArea = All;
    Caption = 'PO Invoice';
    PageType = Document;
    SourceTable = "PO Header Staging";
    Editable = false;
    DeleteAllowed = False;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Vendor Street"; Rec."Vendor Street")
                {
                    ToolTip = 'Specifies the value of the Vendor Street field.', Comment = '%';
                }
                field("Vendor City"; Rec."Vendor City")
                {
                    ToolTip = 'Specifies the value of the Vendor City field.', Comment = '%';
                }
                field("Vendor Country"; Rec."Vendor Country")
                {
                    ToolTip = 'Specifies the value of the Vendor Country field.', Comment = '%';
                }
                field("Vendor Region"; Rec."Vendor Region")
                {
                    ToolTip = 'Specifies the value of the Vendor Region field.', Comment = '%';
                }
                field("Vendor Zip code"; Rec."Vendor Zip code")
                {
                    ToolTip = 'Specifies the value of the Vendor Zip code field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Invoice Description"; Rec."Invoice Description")
                {
                    ToolTip = 'Specifies the value of the Invoice Description field.', Comment = '%';
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount field.', Comment = '%';
                }
                field("Invoice Currency"; Rec."Invoice Currency")
                {
                    ToolTip = 'Specifies the value of the Invoice Currency field.', Comment = '%';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
                }
                field("Invoice Reference No."; Rec."Invoice Reference No.")
                {
                    ToolTip = 'Specifies the value of the Invoice Reference Number field.', Comment = '%';
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    ToolTip = 'Specifies the value of the Net Amount field.', Comment = '%';
                }
                field("Z_BU "; Rec."Z_BU ")
                {
                    ToolTip = 'Specifies the value of the BU field.', Comment = '%';
                }
                field(Z_CompanyName; Rec.Z_CompanyName)
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                }
                field(Z_Data_Before_WSCall; Rec.Z_Data_Before_WSCall)
                {
                    ToolTip = 'Specifies the value of the Data Before WSCall field.', Comment = '%';
                }
                field(Z_PO_OpenAmount; Rec.Z_PO_OpenAmount)
                {
                    ToolTip = 'Specifies the value of the PO Open Amount field.', Comment = '%';
                }
                field(Z_VendorExchangeRate; Rec.Z_VendorExchangeRate)
                {
                    ToolTip = 'Specifies the value of the Vendor ExchangeRate field.', Comment = '%';
                }
                field(Z_WS_Call_Response; Rec.Z_WS_Call_Response)
                {
                    ToolTip = 'Specifies the value of the Call Response field.', Comment = '%';
                }
                field(Z_WorkshopInvoice; Rec.Z_WorkshopInvoice)
                {
                    ToolTip = 'Specifies the value of the Workshop Invoice field.', Comment = '%';
                }
                 field("Process Error"; Rec."Process Error")
                {
                    ToolTip = 'Specifies the value of the Process Error field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
            part(Lines; "PO Invoice Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Entry No."), "Order No." = field("Order No.");
            }

        }
    }
     trigger OnOpenPage()
    begin
       CompanyInfo.Get();
       Rec.SetRange("Company Code",CompanyInfo."Company Code");
    end;
    var
    CompanyInfo : Record "Company Information";
}
