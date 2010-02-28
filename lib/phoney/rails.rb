module Phoney
  module Rails
    class << self
      # Strap all the helper methods into rails
      def init!
        ::Rails::ActiveRecord::Base.send      :include, Phoney::Rails::ActiveRecord
        ::Rails::ActionView::Base.send        :include, Phoney::Rails::Helpers
        ::Rails::ActionController::Base.send  :include, Phoney::Rails::Helpers
      end
    end
    
    module ActiveRecord
      def self.included(base)
        base.send :include, ClassMethods
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
      def phone_number
      end
      
      def format_phone_number num
      end
    end
  end
end