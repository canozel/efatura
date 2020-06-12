# frozen_string_literal: true

require_relative 'validations/invoice'
require_relative 'base'

module Efatura
  module Models
    class Invoice < Models::Base
      validation_class Efatura::Models::Validations::Invoice

      attr_accessor :profile_id, :invoice_id, :issued_date, :issued_time, :invoice_type, :notes,
                    :iso, :total_str, :tax, :sub_total, :discount, :total

      attr_reader :uuid

      def uuid=(uuid)
        @uuid = uuid || SecureRandom.uuid
      end

      def to_encoded_data
        Base64.encode64(ubl).gsub "\n", ''
      end

      def ubl
        @ubl ||= Utils::UblGenerator.generate(self)
      end
    end
  end
end
