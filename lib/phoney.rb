$:.push File.dirname(__FILE__)

module Phoney
  autoload :Integrations,   'phoney/integrations'
  autoload :Formatting,     'phoney/formatting'
  autoload :PhoneNumber,    'phoney/phone_number'
  autoload :Configuration,  'phoney/configuration'
  
  def self.configuration
    @configuration ||= Configuration.new
  end
  
  def self.configure
    yield configuration if block_given?
  end
  
  def self.configuration= configuration
    @configuration = configuration
  end
end