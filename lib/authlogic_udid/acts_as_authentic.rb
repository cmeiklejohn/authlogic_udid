module AuthlogicUDID
  module ActsAsAuthentic
    def self.included(klass)
      klass.class_eval do
        extend Config
        add_acts_as_authentic_module(Methods, :prepend)
      end
    end
    
    module Config
      # * <tt>Default:</tt> true
      # * <tt>Accepts:</tt> Boolean
      def validate_email_or_udid_field(value = nil)
        rw_config(:validate_email_or_udid_field, value, true)
      end
      alias_method :validate_email_or_udid_field=, :validate_email_or_udid_field

      # * <tt>Default:</tt> {:within => 6..100}
      # * <tt>Accepts:</tt> Hash of options accepted by validates_length_of
      def validates_length_of_email_or_udid_field_options(value = nil)
        rw_config(:validates_length_of_email_or_udid_field_options, value, {:within => 6..100, :allow_nil => true})
      end
      alias_method :validates_length_of_email_or_udid_field_options=, :validates_length_of_email_or_udid_field_options

      def validates_format_of_email_or_udid_field_options(value = nil)
        rw_config(:validates_format_of_email_or_udid_field_options, value, {:with => Authlogic::Regex.email, :message => I18n.t('error_messages.email_invalid', :default => "should look like an email address."), :allow_nil => :true})
      end
      alias_method :validates_format_of_email_or_udid_field_options=, :validates_format_of_email_or_udid_field_options

      def validates_uniqueness_of_email_or_udid_field_options(value = nil)
        rw_config(:validates_uniqueness_of_email_or_udid_field_options, value, {:case_sensitive => false, :scope => validations_scope, :if => "#{email_field}_changed?".to_sym, :allow_nil => true})
      end
      alias_method :validates_uniqueness_of_email_or_udid_field_options=, :validates_uniqueness_of_email_or_udid_field_options
    end
    
    module Methods
      def self.included(klass)
        klass.class_eval do
          if validate_email_or_udid_field && email_field
            validates_length_of email_field, validates_length_of_email_or_udid_field_options
            validates_format_of email_field, validates_format_of_email_or_udid_field_options
            validates_uniqueness_of email_field, validates_uniqueness_of_email_or_udid_field_options
       
            # TODO: Abstract out into udid_method  
            validates_presence_of :udid
          end
        end
      end
    end
  end
end
