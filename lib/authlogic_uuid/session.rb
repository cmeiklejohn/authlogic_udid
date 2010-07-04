module AuthlogicUUID
  # This module is responsible for adding oauth
  # to the Authlogic::Session::Base class.
  module Session
    def self.included(klass)
      klass.class_eval do 
        extend Config
        include Methods
      end
    end

    module Config
    end

    module Methods
      def self.included(klass)
        klass.class_eval do
          attr_accessor :uuid
          validate :validate_by_uuid, :if => :authenticating_with_uuid?
        end
      end

      # Shouldn't really ever be called, since this is intended for XML requests, 
      # but this is included for completeness.
      def credentials
        if authenticating_with_uuid?
          details = {}
          details[:uuid] = send(login_field)
          details
        else
          super
        end
      end

      # Setup credentials to be able to read and write UUID
      def credentials=(value)
        super
        values = value.is_a?(Array) ? value : [value]
        hash = values.first.is_a?(Hash) ? values.first.with_indifferent_access : nil
        if !hash.nil?
          self.uuid = hash[:uuid] if hash.key?(:uuid)
        end
      end

      private

      # If a UUID is passed in the user_session create, let's assume this is a UUID request.
      # TODO: Assumes that the object creating is in proper syntax: <class><uuid></uuid></class>
      # Ex. <user_session><uuid></uuid></user_session> if UserSession is the session class.
      def authenticating_with_uuid?
        (controller.params && !controller.params[self.class.name.underscore.to_sym][:uuid].blank?)
      end

      def validate_by_uuid
        raise "#{self.uuid}"
      end
    end
  end
end
