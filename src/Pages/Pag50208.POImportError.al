/// <summary>
/// Page PO Import Error (ID 50208).
/// </summary>
page 50208 "PO Import Error"
{
    ApplicationArea = All;
    Caption = 'PO Import Error';
    PageType = List;
    SourceTable = "PO Import Error";
    UsageCategory = History;
    Editable = false;
    DeleteAllowed = False;
    
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
                  field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.', Comment = '%';
                }
                field("Acknowledgement Sent"; Rec."Acknowledgement Sent")
                {
                    ToolTip = 'Specifies the value of the Acknowledgement Sent field.', Comment = '%';
                }
                field("Import Error"; Rec."Import Error")
                {
                    ToolTip = 'Specifies the value of the Import Error field.', Comment = '%';
                }
                field("Line Error"; Rec."Line Error")
                {
                    ToolTip = 'Specifies the value of the Line Error field.', Comment = '%';
                }
                field(RUID; Rec.RUID)
                {
                    ToolTip = 'Specifies the value of the RUID field.', Comment = '%';
                }
            }
        }
    }
}
