module Phoney
  class Configuration
    attr_accessor :formats, :default_format
    
    # Various formats included by default for formatting phone numbers
    @@formats = {
      :db => Proc.new{|n| n.digits },
      :e164 => Proc.new{|n| "+#{n.country_code} (#{n.area_code}) #{n.number}" }
    }
    
    # ITU-T phone number standard (http://en.wikipedia.org/wiki/E.164)
    @@default_format = :e164
    
    def initialize
      self.formats = @@formats
      self.default_format = @@default_format
      yield self if block_given?
    end
  end
end