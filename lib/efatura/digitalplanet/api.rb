# frozen_string_literal: true

require 'savon'

module Efatura
  class Digitalplanet
    class API
      include Singleton
      attr_reader :client, :corporate_code, :user_name, :password, :ticket

      def initialize
        @client = Savon.client(
          endpoint: Efatura.digitalplanet_configuration.endpoint,
          wsdl: Efatura.digitalplanet_configuration.wsdl,
          env_namespace: :soapenv,
          log: true,
          log_level: :debug,
          namespace_identifier: :ein,
          element_form_default: :qualified
        )
        @corporate_code = Efatura.digitalplanet_configuration.corporate_code
        @user_name = Efatura.digitalplanet_configuration.user_name
        @password = Efatura.digitalplanet_configuration.password
      end

      def get_forms_authentication_ticket
        params = {
          CorporateCode: corporate_code,
          LoginName: user_name,
          Password: password.chomp
        }

        @ticket = get_response params, __method__
      end

      def check_customer_tax_id(customer_tax)
        params = {
          Ticket: @ticket,
          TaxIdOrPersonalId: customer_tax
        }

        response = get_response params, __method__
        if response[:customer_info_list].present?
          response[:customer_info_list][:e_invoice_customer_result]
        end
      end

      def check_invoice_state(uuid)
        params = {
          Ticket: @ticket,
          UUID: uuid
        }

        get_response params, __method__
      end

      def get_available_invoices(corporate_code, _login_name, _password)
        params = {
          Ticket: @ticket,
          CorporateCode: corporate_code
        }

        get_response params, __method__
      end

      def get_available_invoices_by_date(start_date)
        params = {
          Ticket: @ticket,
          CorporateCode: corporate_code,
          StartDate: start_date,
          EndDate: Time.now.strftime('%Y-%m-%d')
        }

        get_response params, __method__
      end

      def get_available_invoices_with_date(start_date)
        params = {
          Ticket: @ticket,
          CorporateCode: corporate_code,
          StartDate: start_date,
          EndDate: Time.now.strftime('%Y-%m-%d')
        }

        get_response params, __method__
      end

      def get_e_archive_invoice(uuid, file_type)
        params = {
          Ticket: @ticket,
          Value: uuid,
          ValueType: 'UUID',
          FileType: file_type
        }

        response = get_response params, __method__

        pdf = Base64.decode64(response[:return_value]).force_encoding('UTF-8')
        filename = response[:invoice_id] + '.' + file_type.downcase
        [pdf, filename]
      end

      def cancel_e_archive_invoice(uuid, total_amount, cancel_date)
        params = {
          Ticket: @ticket,
          Value: uuid,
          Type: 'UUID',
          TotalAmount: total_amount,
          CancelDate: cancel_date
        }

        get_response params, __method__
      end

      def get_invoice(uuid)
        params = {
          Ticket: @ticket,
          UUID: uuid
        }

        get_response params, __method__
      end

      def get_invoice_xml(uuid)
        params = {
          Ticket: @ticket,
          UUID: uuid
        }

        response = get_response params, __method__

        xml = Base64.decode64(response[:return_value]).force_encoding('UTF-8')
        filename = response[:invoice_id] + '.xml'
        [xml, filename]
      end

      def get_invoice_pdf(uuid)
        params = {
          Ticket: @ticket,
          UUID: uuid
        }

        response = get_response params, __method__

        pdf = Base64.decode64(response[:return_value]).force_encoding('UTF-8')
        filename = response[:invoice_id] + '.pdf'
        [pdf, filename]
      end

      def get_invoice_template(template_code, invoice_type)
        params = {
          Ticket: @ticket,
          TemplateCode: template_code,
          InvoiceType: invoice_type
        }

        response = get_response params, __method__
        response[:template]
      end

      def get_new_invoice_id(template_code, invoice_type, year, reconciliation_id)
        params = {
          Ticket: @ticket,
          templateCode: template_code,
          year: year,
          invoiceType: invoice_type,
          reconciliationid: reconciliation_id
        }

        get_response params, __method__
      end

      def send_invoice_data(encoded_data, identify_pk)
        # reciver_info = check_customer_tax_id(reciver_tax_no)

        params = {
          Ticket: @ticket,
          FileType: 'UBL',
          InvoiceRawData: encoded_data,
          CorporateCode: corporate_code,
          MapCode: '-1',
          ReciverPostboxName: identify_pk
        }

        get_response params, __method__
      end

      def send_invoice_data_with_template_code(encoded_data, identify_pk, template_code)
        params = {
          Ticket: @ticket,
          FileType: 'UBL',
          InvoiceRawData: encoded_data,
          CorporateCode: corporate_code,
          MapCode: '-1',
          ReciverPostboxName: identify_pk,
          TemplateCode: template_code
        }

        get_response params, __method__
      end

      def send_invoice_as_email(uuid, sender, receiver, direction)
        params = {
          ticket: @ticket,
          sender: sender,
          receiver: receiver_email(receiver), # receiver,
          uuid: uuid,
          direction: direction # Incoming, AllDirection, EArchive
        }

        get_response params, __method__
      end

      def send_e_archive_data(encoded_data)
        params = {
          Ticket: @ticket,
          FileType: 'UBL',
          InvoiceRawData: encoded_data,
          CorporateCode: corporate_code,
          MapCode: '-1'
        }

        get_response params, __method__
      end

      def send_e_archive_data_with_template_code(encoded_data, template_code)
        params = {
          Ticket: @ticket,
          FileType: 'UBL',
          InvoiceRawData: encoded_data,
          CorporateCode: corporate_code,
          MapCode: '-1',
          TemplateCode: template_code
        }

        get_response params, __method__
      end

      private

      def receiver_email(receiver)
        if Rails.env.development? || Rails.env.pilot? || Rails.env.test?
          Settings.kobiks.support_email
        else
          receiver
        end
      end

      def get_response(params, method)
        begin
          Rails.logger.info "Digital Planet Method => #{method}"
          Rails.logger.info "Digital Planet Request Params => #{params}"
          response = client.call(method, message: params).body[(method.to_s + '_response').to_sym][(method.to_s + '_result').to_sym]
        # Rails.logger.info "Digital Planet Response => #{response}"
        rescue Savon::SOAPFault => e
          Rails.logger.error "Digital Planet Error => #{e.message}"
          raise DigitalPlanetApiException, 503
        rescue SocketError => e
          Rails.logger.error "Digital Planet Error => #{e.message}"
          raise DigitalPlanetApiException, 503
        end

        if method == :get_forms_authentication_ticket
          raise DigitalPlanetApiException, 401 if response.nil?
        else
          if response[:service_result] == 'Error'
            raise KobiksError::IntegrationError, response[:service_result_description]
          end
        end

        response
      end

      private_class_method :new

      class DigitalPlanetApiException < StandardError
        attr_reader :err_code

        def initialize(err_code)
          @err_code = err_code
        end

        def message
          case @err_code
          when 401
            'Hata: Girilen değerler hatalı'
          when 503
            'Hata: Entöratöre ulaşılamadı Lütfen daha sonra deneyiniz.'
          end
        end
      end
    end
  end
end
