# frozen_string_literal: true

require 'test_helper'

class Efatura::DigitalplanetConfigTest < Minitest::Test
  def test_configuration
    Efatura.digitalplanet_configure do |config|
      config.corporate_code = 'test'
      config.user_name = 'test'
      config.password = 'test'
    end

    configuration = Efatura.digitalplanet_configuration
    assert_equal configuration.corporate_code, 'test'
    assert_equal configuration.user_name, 'test'
    assert_equal configuration.password, 'test'
  end

  def test_env_without_env
    if ENV['RACK_ENV'].nil? && ENV['RAILS_ENV'].nil?
      assert_equal Efatura.env.development?, true
    end
  end

  def test_env
    unless ENV['RACK_ENV'].nil? && ENV['RAILS_ENV'].nil?
      assert_equal Efatura.env.production?, true
      assert_equal Efatura.env.development?, false
    end
  end

  def test_wsdl_and_endpoint
    if Efatura.env.development?
      assert_equal(
        Efatura.digitalplanet_configuration.wsdl,
        'https://integrationservicewithoutmtomtest.eveelektronik.com.tr/IntegrationService.wsdl'
      )
      assert_equal(
        Efatura.digitalplanet_configuration.endpoint,
        'https://integrationservicewithoutmtomtest.eveelektronik.com.tr/IntegrationService.asmx'
      )
    end

    Efatura.digitalplanet_configure do |config|
      config.wsdl = 'test'
      config.endpoint = 'test'
    end

    configuration = Efatura.digitalplanet_configuration
    assert_equal configuration.wsdl, 'test'
    assert_equal configuration.endpoint, 'test'
  end
end
