module Phoney
  module Integrations
    module Rails
      class << self
        # Strap all the helper methods into rails
        def init!
          ::ActiveRecord::Base.send :include, ActiveRecord
        end
      end
      
      module ActiveRecord
        def self.included(base)
          base.send :extend,  ClassMethods
          base.send :include, InstanceMethods
        end
        
        module ClassMethods
          def phone_numbers attrs
            Array(attrs).each do |attr|
              class_eval %(
                def #{attr}= number
                  write_attribute :#{attr}, Phoney::PhoneNumber.new(number).to_s(:db)
                end
                
                def #{attr}
                  Phoney::PhoneNumber.new(read_attribute(:#{attr}))
                end
              )
            end
          end
        end
        
        module InstanceMethods
        end
      end
    end
  end
end