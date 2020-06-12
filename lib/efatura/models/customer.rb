# frozen_string_literal: true

require_relative 'validations/customer'
require_relative 'base'

module Efatura
  module Models
    class Customer < Models::Base
      validation_class Efatura::Models::Validations::Customer

      attr_accessor :city, :county, :email, :fax, :first_name, :last_name,
                    :full_address, :id_no, :phone, :tax_office, :web_uri, :zip
    end
  end
end
