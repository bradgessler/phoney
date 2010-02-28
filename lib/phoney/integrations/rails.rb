module Phoney
  module Integrations
    module Rails
      class << self
        # Strap all the helper methods into rails
        def init!
          ::ActiveRecord::Base.send(:include, Phoney::Rails::ActiveRecord)
          ::ActionController::Base.helper(Phoney::Rails::Helpers)
        end
      end
    
      module ActiveRecord
        def self.included(base)
          base.send :extend, ClassMethods
        end
      
        module ClassMethods
          def phone_numbers attrs
            Array(attrs).each do |attr|
              class_eval %(
                def #{attr}_with_phone_number_canonicalization=(num)
                  #{attr}_without_phone_number_canonicalization = Phoney.canonicalize(num)
                end
                alias_method_chain :#{attr}, :phone_number_canonicalization
              )
            end
          end
          alias :phone_number :phone_numbers
        end
      end
    
      module Helpers
        @@automagical_fields = %w(phone_number phonenumber telephone_number telephonenumber phone telephone number)
        
        # Try to guess the method on the class that will return a phone number
        def phone_number obj
          raise obj.inspect
          
          if meth = @@automagical_fields.detect{|meth| obj.respond_to?(meth) }
            format_phone_number obj.send(meth)
          end
        end
        
        # Format a number into a phone number. I ripped those code from Rails, but its not good!
        def format_phone_number number, opts={}
          number       = Phoney.canonicalize number unless number.nil?
          options      = options.symbolize_keys
          area_code    = options[:area_code] || true
          delimiter    = options[:delimiter] || "-"
          extension    = options[:extension].to_s.strip || nil
          country_code = options[:country_code] || '1'
          
          begin
            str = ""
            str << "+#{country_code}#{delimiter}" unless country_code.blank?
            str << if area_code
              number.gsub!(/([0-9]{1,3})([0-9]{3})([0-9]{4}$)/,"(\\1) \\2#{delimiter}\\3")
            else
              number.gsub!(/([0-9]{0,3})([0-9]{3})([0-9]{4})$/,"\\1#{delimiter}\\2#{delimiter}\\3")
              number.starts_with?('-') ? number.slice!(1..-1) : number
            end
            str << " x #{extension}" unless extension.blank?
            str
          rescue
            number
          end
        end
      end
    end
  end
end