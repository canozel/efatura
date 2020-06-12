# frozen_string_literal: true

require_relative 'validations/supplier'
require_relative 'base'

module Efatura
  module Models
    class Supplier < Models::Base
      validation_class Efatura::Models::Validations::Supplier

      attr_accessor :city, :county, :email, :fax, :first_name, :last_name,
                    :full_address, :id_no, :phone, :tax_office, :web_uri, :zip
    end
  end
end
