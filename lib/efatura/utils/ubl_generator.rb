module Efatura
  module Utils
    class UblGenerator
      def self.generate(invoice)
        builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
          xml.send('Invoice',
                   'xmlns': 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
                   'xmlns:cac': 'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
                   'xmlns:cbc': 'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
                   'xmlns:ccts': 'urn:un:unece:uncefact:documentation:2',
                   'xmlns:ext': 'urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2',
                   'xmlns:qdt': 'urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2',
                   'xmlns:ubltr': 'urn:oasis:names:specification:ubl:schema:xsd:TurkishCustomizationExtensionComponents',
                   'xmlns:udt': 'urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2',
                   'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance',
                   'xsi:schemaLocation': 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.1.xsd') do
            xml.send('cbc:UBLVersionID', '2.1')
            xml.send('cbc:CustomizationID', 'TR1.2')
            xml.send('cbc:ProfileID', invoice.profile_id)
            xml.send('cbc:ID', invoice.invoice_id)
            xml.send('cbc:CopyIndicator', false)
            xml.send('cbc:UUID', invoice.uuid)
            xml.send('cbc:IssueDate', invoice.issued_date)
            xml.send('cbc:IssueTime', invoice.issued_time)
            xml.send('cbc:InvoiceTypeCode', invoice.invoice_type)
            xml.send('cbc:Note', invoice.note)
            xml.send('cbc:DocumentCurrencyCode', invoice.iso,
                     'listAgencyName': 'United Nations Economic Commission for Europe',
                     'listID': 'ISO 4217 Alpha',
                     'listName': 'Currency',
                     'listVersionID': '2001')
            xml.send('cbc:LineCountNumeric', '1')
            xml.send('cac:DespatchDocumentReference') do
              xml.send('cbc:ID', invoice.delivery_id)
              xml.send('cbc:IssueDate', invoice.issued_date)
            end
            xml.send('cac:AdditionalDocumentReference') do
              xml.send('cbc:ID', 'gonderimSekli')
              xml.send('cbc:IssueDate', invoice.issued_date)
              xml.send('cbc:DocumentType', 'ELEKTRONIK')
            end
            xml.send('cac:AdditionalDocumentReference') do
              xml.send('cbc:ID', 'duzenlemeTarihi')
              xml.send('cbc:IssueDate', invoice.issued_date)
              xml.send('cbc:DocumentType', invoice.issued_time)
            end
            xml.send('cac:AdditionalDocumentReference') do
              xml.send('cbc:ID', invoice.elogo_name)
              xml.send('cbc:IssueDate', invoice.issued_date)
              xml.send('cbc:DocumentType', invoice.elogo_id)
            end
            xml.send('cac:AdditionalDocumentReference') do
              xml.send('cbc:ID', invoice.total_str)
              xml.send('cbc:IssueDate', invoice.issued_date)
              xml.send('cbc:DocumentType', 'TOTAL_NET_STR')
            end
            xml.send('cac:Signature') do
              xml.send('cbc:ID', invoice.supplier[:vkn], 'schemeID': 'VKN_TCKN')
              xml.send('cac:SignatoryParty') do
                xml.send('cac:PartyIdentification') do
                  xml.send('cbc:ID', invoice.supplier[:vkn], 'schemeID': 'VKN_TCKN')
                end
                xml.send('cac:PartyName') do
                  xml.send('cbc:Name', invoice.supplier[:trade_name])
                end
                xml.send('cac:PostalAddress') do
                  xml.send('cbc:CitySubdivisionName', invoice.supplier[:address])
                  xml.send('cbc:CityName', invoice.supplier[:city])
                  xml.send('cbc:PostalZone', invoice.supplier[:zip])
                  xml.send('cac:Country') do
                    xml.send('cbc:Name', invoice.supplier[:country])
                  end
                end
                xml.send('cac:PartyTaxScheme') do
                  xml.send('cac:TaxScheme') do
                    xml.send('cbc:Name', invoice.supplier[:tax_office])
                  end
                end
              end
              xml.send('cac:DigitalSignatureAttachment') do
                xml.send('cac:ExternalReference') do
                  xml.send('cbc:URI', "#Signature_#{invoice.invoice_id}")
                end
              end
            end
            xml.send('cac:AccountingSupplierParty') do
              xml.send('cac:Party') do
                xml.send('cbc:WebsiteURI', invoice.supplier[:web_uri])
                xml.send('cac:PartyIdentification') do
                  xml.send('cbc:ID', invoice.supplier[:vkn], 'schemeID': invoice.supplier[:id_type])
                end
                xml.send('cac:PartyIdentification') do
                  xml.send('cbc:ID', invoice.supplier[:sicil_no], 'schemeID': 'TICARETSICILNO')
                end
                xml.send('cac:PartyIdentification') do
                  xml.send('cbc:ID', invoice.supplier[:mernis_no], 'schemeID': 'MERSISNO')
                end
                xml.send('cac:PartyName') do
                  xml.send('cbc:Name', invoice.supplier[:trade_name])
                end
                xml.send('cac:PostalAddress') do
                  xml.send('cbc:CitySubdivisionName', invoice.supplier[:address])
                  xml.send('cbc:CityName', invoice.supplier[:city])
                  xml.send('cbc:PostalZone', invoice.supplier[:zip])
                  xml.send('cac:Country') do
                    xml.send('cbc:Name', invoice.supplier[:country])
                  end
                end
                xml.send('cac:PartyTaxScheme') do
                  xml.send('cac:TaxScheme') do
                    xml.send('cbc:Name', invoice.supplier[:tax_office])
                  end
                end
                xml.send('cac:Contact') do
                  xml.send('cbc:Telephone', invoice.supplier[:phone])
                  xml.send('cbc:ElectronicMail', invoice.supplier[:email])
                  xml.send('cbc:Telefax', invoice.supplier[:fax])
                end
              end
            end
            xml.send('cac:AccountingCustomerParty') do
              xml.send('cac:Party') do
                xml.send('cbc:WebsiteURI', invoice.customer[:web_uri])
                xml.send('cac:PartyIdentification') do
                  xml.send('cbc:ID', invoice.customer[:vkn], 'schemeID': invoice.customer[:id_type])
                end

                if invoice.customer[:vkn].size == 10
                  xml.send('cac:PartyName') do
                    xml.send('cbc:Name', invoice.customer[:trade_name])
                  end
                else
                  xml.send('cac:Person') do
                    xml.send('cbc:FirstName', invoice.customer[:first_name])
                    xml.send('cbc:FamilyName', invoice.customer[:last_name])
                  end
                end

                xml.send('cac:PostalAddress') do
                  xml.send('cbc:CitySubdivisionName', invoice.customer[:address])
                  xml.send('cbc:CityName', invoice.customer[:city])
                  xml.send('cbc:PostalZone', invoice.customer[:zip])
                  xml.send('cac:Country') do
                    xml.send('cbc:Name', invoice.customer[:country])
                  end
                end
                xml.send('cac:PartyTaxScheme') do
                  xml.send('cac:TaxScheme') do
                    xml.send('cbc:Name', invoice.customer[:tax_office])
                  end
                end

                xml.send('cac:Contact') do
                  xml.send('cbc:Telephone', invoice.customer[:phone])
                  xml.send('cbc:ElectronicMail', invoice.customer[:email])
                  #xml.send('cbc:Telefax', invoice.customer[:fax])
                end
              end
            end
            xml.send('cac:TaxTotal') do
              xml.send('cbc:TaxAmount', invoice.tax, 'currencyID': invoice.iso)
              xml.send('cac:TaxSubtotal') do
                #xml.send('cbc:TaxableAmount', invoice.sub_total, 'currencyID': invoice.iso)
                xml.send('cbc:TaxAmount', invoice.tax, 'currencyID': invoice.iso)
                xml.send('cac:TaxCategory') do
                  xml.send('cbc:TaxExemptionReason ', '351 - İstisna Olmayan Diğer') if invoice.tax == 0
                  xml.send('cbc:TaxExemptionReasonCode ', '351') if invoice.tax == 0 # Altın için bu kod
                  xml.send('cac:TaxScheme') do
                    xml.send('cbc:Name ', 'KDV')
                    xml.send('cbc:TaxTypeCode ', '0015')
                  end
                end
              end
            end
            xml.send('cac:LegalMonetaryTotal') do
              xml.send('cbc:LineExtensionAmount', invoice.sub_total, 'currencyID': invoice.iso)
              #xml.send('cbc:AllowanceTotalAmount', invoice.discount, 'currencyID': invoice.iso)
              xml.send('cbc:TaxExclusiveAmount', invoice.sub_total, 'currencyID': invoice.iso)
              xml.send('cbc:TaxInclusiveAmount', invoice.total, 'currencyID': invoice.iso)
              xml.send('cbc:PayableAmount', invoice.total, 'currencyID': invoice.iso)
            end
            invoice.invoice_line_items.each_with_index do |line_item, index|
              xml.send('cac:InvoiceLine') do
                xml.send('cbc:ID', index + 1)
                xml.send('cbc:Note', line_item[:note])
                xml.send('cbc:InvoicedQuantity', line_item[:quantity], 'unitCode': 'C62') # Miktar')
                xml.send('cbc:LineExtensionAmount', line_item[:total], 'currencyID': line_item[:iso]) # Mal Hizmet Tutarı
                xml.send('cac:TaxTotal') do
                  xml.send('cbc:TaxAmount', line_item[:tax], 'currencyID': line_item[:iso])
                  xml.send('cac:TaxSubtotal') do
                    xml.send('cbc:TaxableAmount', line_item[:sub_total], 'currencyID': line_item[:iso])
                    xml.send('cbc:TaxAmount', line_item[:tax], 'currencyID': line_item[:iso]) # KDV tutarı'
                    xml.send('cbc:Percent', line_item[:tax_rate]) # KDV oranı
                    xml.send('cac:TaxCategory') do
                      xml.send('cbc:TaxExemptionReason', '351 - İstisna Olmayan Diğer') if invoice.tax == 0
                      xml.send('cbc:TaxExemptionReasonCode', '351') if invoice.tax == 0 # Altın için bu kod
                      xml.send('cac:TaxScheme') do
                        xml.send('cbc:Name', 'KDV')
                        xml.send('cbc:TaxTypeCode', '0015')
                      end
                    end
                  end
                end
                xml.send('cac:Item') do
                  xml.send('cbc:Name', line_item[:cached_name]) # Mal Hizmet
                end
                xml.send('cac:Price') do
                  xml.send('cbc:PriceAmount', line_item[:price], 'currencyID': line_item[:iso]) # Birim Fiyat')
                end
                #xml.send('cac:AllowanceCharge') do
                #  xml.send('cbc:ChargeIndicator', false)
                #  xml.send('cbc:Amount', line_item[:discount], 'currencyID': line_item[:iso]) # İskonto Tutarı')
                #  xml.send('cbc:MultiplierFactorNumeric', line_item[:discount_rate], 'currencyID': line_item[:iso]) # iskonto oranı')
                #end
              end
            end
          end
        end

        builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
      end
    end
  end
end
