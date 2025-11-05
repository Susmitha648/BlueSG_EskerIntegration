enum 50200 "Invoice Process Status"
{
    Extensible = true;
    
    value(0; Imported)
    {
        Caption = 'Imported';
    }
    value(1; Processed)
    {
        Caption = 'Processed';
    }
    value(2; Error)
    {
        Caption = 'Error';
    }
}
