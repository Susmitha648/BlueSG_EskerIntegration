page 50206 "Non PO Invoices"
{
    ApplicationArea = All;
    Caption = 'Non PO Invoices';
    SourceTable = "Non PO Header Staging";
    UsageCategory = Lists;
    PageType = List;
    Editable = false;//t
    DeleteAllowed = false;//t
    CardPageId = "Non PO Invoice";
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
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.', Comment = '%';
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
                field(RUID; Rec.RUID)
                {
                    ToolTip = 'Specifies the value of the RUID field.', Comment = '%';
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
                Caption = 'Process Non PO Invoice';
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ProcessPI: Report "Non PO Invoice Process";
                    NonPOInvoiceHeader : Record "Non PO Header Staging";
                begin
                    SetSelectionFilter(NonPOInvoiceHeader);
                    Report.RunModal(50201,False,False,NonPOInvoiceHeader);
                end;
            }
            action(PurchInvoices)
            {

                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Caption = 'Posted Purchase Invoice';
                //RunObject = page "Purchase Invoices";
                trigger OnAction()
                var
                    PurchaseInvoiceRec: Record "Purch. Inv. Header";
                begin

                    PurchaseInvoiceRec.SETFILTER("No.", Rec."Posted Purch. Invoice No.");
                    if PurchaseInvoiceRec.FINDFIRST then
                        PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice", PurchaseInvoiceRec);
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
        CompanyInfo: Record "Company Information";


}

