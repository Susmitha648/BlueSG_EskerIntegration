
pageextension 50202 "Comp Info Ext" extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
        addafter(GLN)
        {
            field("Company Code"; Rec."Company Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Company Code';
            }
        }
    }
}
