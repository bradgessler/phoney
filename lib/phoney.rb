module Phoney
  autoload :Integrations, 'phoney/integrations'
  autoload :Formatting,   'phoney/formatting'
  
  class << self
    # Convert a phone number into only numbers
    def canonicalize phone_number
      phone_number.to_s.strip.gsub(/[^\d]/, '')[-10..-1]  # Only works for US numbers
    end
  end
end