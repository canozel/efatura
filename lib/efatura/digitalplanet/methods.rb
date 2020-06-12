# frozen_string_literal: true

require 'efatura/digitalplanet/api'

module Efatura
  class Digitalplanet
    module Methods
      def send_invoice(invoice)
        unless invoice.instance_of?(Efatura::Models::Invoice)
          raise ArgumentError, ''
        end

        if invoice.identifier_pk[:is_exist]
          API.instance.send_invoice_data_with_template_code(invoice.to_encoded_data, identify_pk, template_code)
        end
      end
    end
  end
end
