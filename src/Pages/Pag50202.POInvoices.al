/// <summary>
/// Page PO Invoices (ID 50202).
/// </summary>
page 50202 "PO Invoices"
{
    ApplicationArea = All;
    Caption = 'PO Invoices';
    SourceTable = "PO Header Staging";
    UsageCategory = Lists;
    PageType = List;
    Editable = false;
    DeleteAllowed = True;
    CardPageId = "PO Invoice";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.', Comment = '%';
                }
                field("Company Code"; Rec."Company Code")
                {
                    ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field("Invoice Description"; Rec."Invoice Description")
                {
                    ToolTip = 'Specifies the value of the Invoice Description field.', Comment = '%';
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount field.', Comment = '%';
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
                field("RUID"; Rec."RUID")
                {
                    ToolTip = 'Specifies the value of the RUID field.', Comment = '%';
                }
                field(Z_CompanyName; Rec.Z_CompanyName)
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
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
        }
    }
    actions
    {
        area(Processing)
        {
            
            action(ProcessNonPOnv)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Process PO Invoice';
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    POInvoiceHeader : Record "PO Header Staging";
                begin
                    SetSelectionFilter(POInvoiceHeader);
                    Report.RunModal(50200,False,False,POInvoiceHeader);
                end;
            }
            action(PurchInvoices)
            {

                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'Posted Purchase Invoice';
                trigger OnAction()
                var
                    PurchaseInvoiceRec: Record "Purch. Inv. Header";
                begin
                    PurchaseInvoiceRec.Reset();
                    PurchaseInvoiceRec.SETFILTER("Order No.", Rec."Order No.");
                    if PurchaseInvoiceRec.FINDFIRST then
                        PAGE.RUNMODAL(PAGE::"Posted Purchase Invoices", PurchaseInvoiceRec);
                end;

            }
        }
    }
    trigger OnOpenPage()
    begin
        CompanyInfo.Get();
        Rec.SetRange("Company Code", CompanyInfo."Company Code");
    end;

    var
    CompanyInfo : Record "Company Information";
}
