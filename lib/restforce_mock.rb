require "restforce_mock/version"
require "restforce_mock/configuration"
require "restforce_mock/client"
require "restforce_mock/sandbox"
require "restforce_mock/schema_manager"
require "restforce_mock/error"

module RestforceMock
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= RestforceMock::Configuration.new
  end

  def self.reset
    @configuration = RestforceMock::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
