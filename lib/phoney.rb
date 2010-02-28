$:.push File.dirname(__FILE__)

module Phoney
  autoload :Integrations, 'phoney/integrations'
  autoload :Formatting,   'phoney/formatting'
  autoload :PhoneNumber,  'phoney/phone_number'
end