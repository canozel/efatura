# frozen_string_literal: true

require 'dry-validation'

module Efatura
  module Models
    module Validations
      class InvoiceLineItem < Dry::Validation::Contract
        json do
          required(:id_no).filled(:string)
          # optional(:asd).value(:string)
        end

        rule(:id_no) do
          unless /([0-9]{11}|[0-9]{10})/i.match?(value)
            key.failure('has invalid format')
          end
        end
      end
    end
  end
end
