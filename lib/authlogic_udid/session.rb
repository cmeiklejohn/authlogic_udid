module AuthlogicUDID
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
          attr_accessor :udid
          validate :validate_by_udid, :if => :authenticating_with_udid?
        end
      end

      # Shouldn't really ever be called, since this is intended for XML requests, 
      # but this is included for completeness.
      def credentials
        if authenticating_with_udid?
          details = {}
          details[:udid] = send(login_field)
          details
        else
          super
        end
      end

      # Setup credentials to be able to read and write udid
      def credentials=(value)
        super
        values = value.is_a?(Array) ? value : [value]
        hash = values.first.is_a?(Hash) ? values.first.with_indifferent_access : nil
        if !hash.nil?
          self.udid = hash[:udid] if hash.key?(:udid)
        end
      end

      private

      # If a udid is passed in the user_session create, let's assume this is a udid request.
      # TODO: Assumes that the object creating is in proper syntax: <class><udid></udid></class>
      # Ex. <user_session><udid></udid></user_session> if UserSession is the session class.
      def authenticating_with_udid?
        (controller.params && !controller.params[self.class.name.underscore.to_sym][:udid].blank?)
      end

      def validate_by_udid
        raise "#{self.udid}"
      end
    end
  end
end
