# frozen_string_literal: true

require 'efatura/digitalplanet/version'
require 'efatura/digitalplanet/configuration'
require 'efatura/utils/string_inquirer'
require 'efatura/digitalplanet/methods'

module Efatura
  class Error < StandardError; end

  class Digitalplanet
    include Methods

    def initialize(corporate_code:, user_name:, password:)
      Efatura.digitalplanet_configuration.corporate_code = corporate_code
      Efatura.digitalplanet_configuration.user_name = user_name
      Efatura.digitalplanet_configuration.password = password
    end
  end

  class << self
    attr_writer :digitalplanet_configuration

    def env
      @_env ||= Efatura::Utils::StringInquirer.new(ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = Efatura::Utils::StringInquirer.new(environment)
    end
  end

  def self.digitalplanet_configuration
    @digitalplanet_configuration ||= Efatura::Digitalplanet::Configuration.new
  end

  def self.digitalplanet_configure
    yield(digitalplanet_configuration)
  end
end
