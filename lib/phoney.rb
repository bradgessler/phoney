module Phoney
  autoload :Rails, 'phoney/rails'
  
  class << self
    # Strips out digits and area code
    def canonicalize phone_number
      phone_number.to_s.gsub(/[^\d]/, '')[-10..-1] # Only works for US numbers
    end
  end
end