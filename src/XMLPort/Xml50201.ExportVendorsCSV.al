XMLport 50201 "ExportVendorsCSV"
{
    Format = VariableText;
    Direction = Export;
    FileName = 'BlueSGEsker_Vendor.csv';
    TextEncoding = UTF8;
    TableSeparator = '<CR><LF>';
    FieldSeparator = ';';
    FieldDelimiter = '';

    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = sorting(Number) where(Number = const(1));
                textelement(CompanyCode)
                {

                }

                textelement("No.")
                {
 
                }
                textelement("Name")
                {
 
                }
                textelement(Street)
                {

                }
                textelement(PostOfficeBox)
                {

                }
                textelement(City)
                {

                }
                textelement(PostalCode)
                {

                }
                textelement(Region)
                {

                }
                textelement(Country)
                {

                }
                textelement(PhoneNumber)
                {

                }
                textelement(FaxNumber)
                {

                }
                textelement(VATNumber)
                {

                }
                textelement(PreferredInvoiceType)
                {

                }
                
                textelement(PaymentTermCode)
                {
 
                }
                textelement(Email)
                {
 
                }
                textelement(GeneralAccount)
                {
 
                }
                textelement(TaxSystem)
                {
 
                }
                textelement(Currency)
                {
 
                }
                textelement(ParafiscalTax)
                {
 
                }
                textelement(SupplierDue)
                {
 
                }
                textelement(GBVendorGroup)
                {
 
                }
    
            
        }
        tableelement(Vendor; Vendor)
            {
                  textelement(CompanyCodeValue)
                {
                    trigger OnBeforePassVariable()
                    begin
                        CompanyCodeValue := CompanyInfo."Company Code";
                    end;
                }
                fieldelement("No."; Vendor."No.") { 
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."No." = '' then "No." := ';';
                            end;
                }
                fieldelement("Name"; Vendor."Name") 
                { 
                    trigger OnBeforePassField()
                    var
                    CorrectStr:Text; 
                    begin
                            if Vendor.Name = '' then Name := ';';
                            if StrPos(Vendor.Name,',') <>0 then begin
                        CorrectStr:=Vendor.Name;
                        CorrectStr:=DelChr(CorrectStr,'=',',');
                        
                            end else
                            CorrectStr:=Vendor.Name;
                            Name:=CorrectStr;
                            end;
                }
                fieldelement(Street; Vendor.Address) 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor.Address = '' then Street := ';';
                            end;
                    }

                fieldelement(PostOfficeBox; Vendor."Post Code") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Post Code" = '' then PostOfficeBox := ';';
                            end;
                    }
                fieldelement("City"; Vendor.City) 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor.City = '' then City := ';';
                            end;
                    }
                fieldelement("PostalCode"; Vendor."Post Code") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Post Code" = '' then PostalCode := ';';
                            end;
                    }
                fieldelement("Region"; Vendor."Country/Region Code")
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Country/Region Code" = '' then Region := ';';
                            end;
                    }
                fieldelement(Country; Vendor."Country/Region Code") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Country/Region Code" = '' then Country := ';';
                            end;
                    }
                fieldelement("PhoneNumber"; Vendor."Phone No.") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Phone No." = '' then PhoneNumber := ';';
                            end;
                    }
                fieldelement("FaxNumber"; Vendor."Fax No.") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Fax No." = '' then FaxNumber := ';';
                            end;
                    }
                    fieldelement("VATNumber"; Vendor."VAT Registration No.") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."VAT Registration No." = '' then VATNumber := ';';
                            end;
                    }
                    fieldelement("PreferredInvoiceType"; Vendor."Partner Type")//PreferredInvoiceType 
                {
                    trigger OnBeforePassField() 
                    begin
                        //  if Vendor."Fax No." = '' then 
                            PreferredInvoiceType := ';';
                            end;
                    }
                    fieldelement("PaymentTermsCode"; Vendor."Payment Terms Code") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Payment Terms Code" = '' then PaymentTermCode := ';';
                            end;
                    }
                    fieldelement("Email"; Vendor."E-Mail") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."E-Mail" = '' then Email := ';';
                            end;
                    }
                    fieldelement("GeneralAccount"; Vendor."Our Account No.") 
                {
                    trigger OnBeforePassField() 
                    begin
                        //  if Vendor."Fax No." = '' then
                            GeneralAccount := ';';
                            end;
                    }
                    fieldelement("TaxSystem"; Vendor."Tax Liable") //TaxSystem
                {
                    trigger OnBeforePassField() 
                    begin
                        //  if Vendor."Tax Liable" = '' then
                            TaxSystem := ';';
                            end;
                    }
                    fieldelement("Currency"; Vendor."Currency Code") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Currency Code" = '' then Currency := ';';
                            end;
                    }
                    fieldelement("ParafiscalTax"; Vendor."Fax No.") //ParafiscalTax
                {
                    trigger OnBeforePassField() 
                    begin
                        //  if Vendor."Fax No." = '' then
                            ParafiscalTax := ';';
                            end;
                    }
                    fieldelement("SupplierDue"; Vendor."Balance Due") 
                {
                    trigger OnBeforePassField() 
                    begin
                            if Vendor."Balance Due" = 0 then
                            ParafiscalTax := ';';
                            end;
                    }
                    fieldelement("GBVendorGroup"; Vendor."Gen. Bus. Posting Group") ///////
                {
                    trigger OnBeforePassField() 
                    begin
                        //  if Vendor."Fax No." = '' then
                            GBVendorGroup := ';';
                            end;
                    }
            }
        
    }
    }
    trigger OnInitXmlPort();
            begin
                CompanyInfo.Get();
                CompanyCode := 'CompanyCode__';
                "No." := 'Number__';
                Name := 'Name__';
                Street := 'Street__';
                PostOfficeBox := 'PostOfficeBox__';
                City := 'City__';
                Country := 'Country__';
                Currency := 'Currency__';
                Email := 'Email__';
                FaxNumber := 'FaxNumber__';
                GBVendorGroup := 'GBVendorGroup__';
                GeneralAccount := 'GeneralAccount__';
                ParafiscalTax := 'ParafiscalTax__';
                PaymentTermCode := 'PaymentTermCode__';
                PhoneNumber := 'PhoneNumber__';
                PostalCode := 'PostalCode__';
                PostOfficeBox := 'PostOfficeBox__';
                PaymentTermCode := 'PaymentTermCode__';
                PreferredInvoiceType := 'PreferredInvoiceType__';
                Region := 'Region__';
                SupplierDue := 'SupplierDue__';
                TaxSystem := 'TaxSystem__';
                VATNumber := 'VATNumber__';
                // TaxRate := 'TaxRate__';
                // TaxAccount := 'TaxAccount__';
                // TaxAccountForCollection := 'TaxAccountForCollection__';
                // TaxType := 'TaxType__';
            end;
    var
        CompanyInfo: Record "Company Information";
}

    
