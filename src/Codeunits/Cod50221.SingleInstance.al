codeunit 50221 SingleInstance

{
    SingleInstance = true;
    var
        Data: Record "Non PO Header Staging";
        DataLine: Record "Non PO Line Staging";
        LineProcessStarted: Boolean;
        gRUID : Text;

    procedure SetData(pData: Record "Non PO Header Staging"; pLineProcessStarted: Boolean)
    begin
        Data := pData;
        LineProcessStarted := pLineProcessStarted;
    end;

    procedure GetData(var pData: Record "Non PO Header Staging")
    begin
        pData := Data;
    end;
    procedure SetRUID(RUID: Text[100])
    begin
        gRUID := RUID;
    end;

    procedure GetRUID() : Text 
    begin
       Exit(gRUID);
    end;

    procedure SetDataLine(pLineProcessStarted: Boolean)

    begin
        
        LineProcessStarted := pLineProcessStarted;

    end;

    procedure GetDataLine(var pDataLine: Record "Non PO Line Staging")

    begin
        pDataLine := DataLine;

    end;

    procedure IsLineProcessStarted(): Boolean
    begin
        exit(LineProcessStarted);
    end;
}

