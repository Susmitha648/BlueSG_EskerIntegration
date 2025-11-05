/// <summary>
/// Page PO Invoice Subform (ID 50203).
/// </summary>
page 50203 "PO Invoice Subform"
{
    ApplicationArea = All;
    Caption = 'PO Invoice Subform';
    PageType = ListPart;
    SourceTable = "PO Line Staging";
    Editable = false;
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
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the GL Account Description field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.', Comment = '%';
                }
                field("UOM Code"; Rec."UOM Code")
                {
                    ToolTip = 'Specifies the value of the UOM Code field.', Comment = '%';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Billing Period"; Rec."Billing Period")
                {
                    ToolTip = 'Specifies the value of the Billing Period field.', Comment = '%';
                }
                field("Cost Center"; Rec."Cost Center")
                {
                    ToolTip = 'Specifies the value of the Cost Center field.', Comment = '%';
                }
                field("Conso Group Code"; Rec."Conso Group Code")
                {
                    ToolTip = 'Specifies the value of the Consolidated Group Code field.', Comment = '%';
                }
                field("Chassis Number"; Rec."Chassis Number")
                {
                    ToolTip = 'Specifies the value of the Chassis Number field.', Comment = '%';
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.', Comment = '%';
                }
                field("Part No."; Rec."Part No.")
                {
                    ToolTip = 'Specifies the value of the Party No. field.', Comment = '%';
                }
                field("GL Account"; Rec."GL Account")
                {
                    ToolTip = 'Specifies the value of the General Ledger Account field.', Comment = '%';
                }
                field("GL Description"; Rec."GL Description")
                {
                    ToolTip = 'Specifies the value of the GL Account Description field.', Comment = '%';
                }
                field("Goods Receipt No."; Rec."Goods Receipt No.")
                {
                    ToolTip = 'Specifies the value of the Goods Receipt Number field.', Comment = '%';
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the value of the Order No. field.', Comment = '%';
                }
                field("Tax Code"; Rec."Tax Code")
                {
                    ToolTip = 'Specifies the value of the Tax Code field.', Comment = '%';
                }
                field("Tax Group"; Rec."Tax Group")
                {
                    ToolTip = 'Specifies the value of the Rev Packing Plan Code field.', Comment = '%';
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ToolTip = 'Specifies the value of the Tax Amount field.', Comment = '%';
                }
                field("Delivery Note"; Rec."Delivery Note")
                {
                    ToolTip = 'Specifies the value of the Delivery Note field.', Comment = '%';
                }
                field("Line Type"; Rec."Line Type")
                {
                    ToolTip = 'Specifies the value of the "Line Type" field.', Comment = '%';
                }
            }
        }
    }
}
