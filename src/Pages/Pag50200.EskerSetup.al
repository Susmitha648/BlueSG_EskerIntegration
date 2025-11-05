page 50200 "Esker Azure Parameters"
{
    ApplicationArea = All;
    Caption = 'Esker Azure Parameters';
    PageType = Card;
    SourceTable = "Esker Azure Parameters";
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Access Key"; Rec."Access Key")
                {
                    ToolTip = 'Specifies the value of the Access Key field.', Comment = '%';
                }
                field("Azure Storage Account"; Rec."Azure Storage Account")
                {
                    ToolTip = 'Specifies the value of the Azure Storage Account field.', Comment = '%';
                }
                field("File Share"; Rec."File Share")
                {
                    ToolTip = 'Specifies the value of the Azure File Share.', Comment = '%';
                }
                field("Master Data"; Rec."Master Data")
                {
                    ToolTip = 'Specifies the value of the Master Data field.', Comment = '%';
                }
                field("Non PO Invoices"; Rec."Non PO Invoices")
                {
                    ToolTip = 'Specifies the value of the Non PO Invoices field.', Comment = '%';
                }
                field("PO Invoices"; Rec."PO Invoices")
                {
                    ToolTip = 'Specifies the value of the PO Invoices field.', Comment = '%';
                }
                field("Paid Invoices"; Rec."Paid Invoices")
                {
                    ToolTip = 'Specifies the value of the Paid Invoices field.', Comment = '%';
                }
                field(Archive; Rec.Archive)
                {
                    ToolTip = 'Specifies the value of the Archive field.', Comment = '%';
                }
                field("Vendor Template"; Rec."Vendor Template")
                {
                    ToolTip = 'Specifies the value of the Vendor Template';
                }
                field("Acknowledgement"; Rec.Acknowledgement)
                {
                    ToolTip = 'Specifies the value of the acknowledgement folder';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}
