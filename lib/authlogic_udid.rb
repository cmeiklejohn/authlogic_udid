require 'authlogic_udid/acts_as_authentic'
require 'authlogic_udid/session'

if ActiveRecord::Base.respond_to?(:add_acts_as_authentic_module)
  ActiveRecord::Base.send(:include, AuthlogicUDID::ActsAsAuthentic)
  Authlogic::Session::Base.send(:include, AuthlogicUDID::Session)
end

