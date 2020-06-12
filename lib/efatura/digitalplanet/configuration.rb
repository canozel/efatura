# frozen_string_literal: true

module Efatura
  class Digitalplanet
    class Configuration
      attr_accessor :dev_corporate_code, :dev_user_name, :dev_password
      attr_writer :wsdl, :endpoint, :corporate_code, :user_name, :password

      def wsdl
        @wsdl ||= if Efatura.env.production?
                    'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.wsdl'
                  else
                    'https://integrationservicewithoutmtomtest.eveelektronik.com.tr/IntegrationService.wsdl'
                  end
      end

      def endpoint
        @endpoint ||= if Efatura.env.production?
                        'https://integrationservicewithoutmtom.digitalplanet.com.tr/IntegrationService.asmx'
                      else
                        'https://integrationservicewithoutmtomtest.eveelektronik.com.tr/IntegrationService.asmx'
                      end
      end

      def corporate_code
        if Efatura.env.development?
          @dev_corporate_code || @corporate_code
        else
          @corporate_code
        end
      end

      def user_name
        if Efatura.env.development?
          @dev_user_name || @user_name
        else
          @user_name
        end
      end

      def password
        if Efatura.env.development?
          @dev_password || @password
        else
          @password
        end
      end
    end
  end
end
