# frozen_string_literal: true

require_relative 'validations/invoice_line_item'
require_relative 'base'

module Efatura
  module Models
    class InvoiceLineItem < Models::Base
      validation_class Efatura::Models::Validations::InvoiceLineItem

      attr_accessor :note, :quantity, :total, :tax, :tax_rate, :iso,
                    :cached_name, :price, :discount, :discount_rate
    end
  end
end
