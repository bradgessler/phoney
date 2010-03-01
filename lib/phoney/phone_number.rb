module Phoney
  def PhoneNumber(number)
    number.is_a?(PhoneNumber) ? number : PhoneNumber.new(number)
  end
  
  # TODO make this work for i18n numbers
  class PhoneNumber
    @@formats = {
      :db => Proc.new{|n| n.digits },
      :standard => Proc.new{|n| "+#{n.country_code} (#{n.area_code}) #{n.number}" }
    }
    
    attr_accessor :digits
    
    def initialize digits
      self.digits = digits
    end
    
    def digits= digits
      @digits = self.class.canonicalize(digits)
    end
    
    def area_code
      digits[1..3]
    end
    
    def country_code
      digits[0...1]
    end
    
    # What is this really called?
    def number
      digits[3...10]
    end
    
    def to_s(format=Phoney.configuration.default_format)
      Phoney.configuration.formats[format].call(self)
    end
    
    # Strips all non-digits out of the phone number
    def self.canonicalize phone_number
      str = phone_number.to_s.strip.gsub(/[^\d]/, '')[-10..-1]  # Only works for US numbers
      "1#{str}" # Really crappy way of assuming a US country code
    end
  end
end