# frozen_string_literal: true

require_relative 'validations/customer'

module Efatura
  module Models
    class Base
      def initialize(validation_class, **args)
        result = validation_class.call(args)
        raise ArgumentError, result.errors.to_h if result.failure?

        args.each do |key, value|
          begin
            public_send("#{key}=", value)
          rescue NoMethodError
            raise Models::UnknownAttributeError, key
          end
        end
      end

      def self.validation_class(klass)
        @validation_class ||= klass.new
      end

      def self.new(*args)
        super(@validation_class, *args)
      end

      class Models::UnknownAttributeError < Efatura::Error
        def initialize(attribute)
          @attribute = attribute
        end

        def to_s
          "unknown attribute #{@attribute} for Customer"
        end
      end
    end
  end
end
