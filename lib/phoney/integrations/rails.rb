module Phoney
  module Integrations
    module Rails
      class << self
        # Strap all the helper methods into rails
        def init!
          ::ActiveRecord::Base.send :include, ActiveRecord
          ::ActionController::Base.helper Helpers
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
                  #{attr}_without_phone_number_canonicalization = Phoney::PhoneNumber.new(num)
                end
                alias_method_chain :#{attr}, :phone_number_canonicalization
              )
            end
          end
          alias :phone_number :phone_numbers
        end
      end
      
      module Helpers
        @@automagical_attributes = %w(phone_number phonenumber telephone_number telephonenumber phone telephone number)
        
        # Try to guess the method on the class that will return a phone number
        def phone_number obj
          if meth = @@automagical_attributes.detect{|meth| obj.respond_to?(meth) }
            format_phone_number obj.send(meth)
          end
        end
        
        # Format a number into a phone number. I ripped those code from Rails, but its not good!
        def format_phone_number number, options={}
          PhoneNumber.new(number).to_s
        end
      end
    end
  end
end