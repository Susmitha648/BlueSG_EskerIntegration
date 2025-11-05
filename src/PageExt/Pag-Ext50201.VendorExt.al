namespace BlueSG_EskerIntegration.BlueSG_EskerIntegration;

using Microsoft.Purchases.Vendor;
using System.Utilities;

pageextension 50201 VendorExt extends "Vendor List"
{
    actions
    {
        addafter("Purchase Journal")
        {
            action(VendorExport)
            {
                Promoted = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                begin
                    // TempBlob.CREATEOUTSTREAM(OutStream, TextEncoding::UTF8);
                    Xmlport.Run(50201);
                end;
            }
            action(GLAccountExport)
            {
                Promoted = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                begin
                    // TempBlob.CREATEOUTSTREAM(OutStream, TextEncoding::UTF8);
                    Xmlport.Run(50202);
                end;
            }
            action(ExportGRN)
            {
                Promoted = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                begin
                    // TempBlob.CREATEOUTSTREAM(OutStream, TextEncoding::UTF8);
                    Codeunit.Run(50202);
                end;
            }
            action(ExportCurrency)
            {
                Promoted = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                begin
                    // TempBlob.CREATEOUTSTREAM(OutStream, TextEncoding::UTF8);
                    Codeunit.Run(50201);
                end;
            }
        }
    }

}
