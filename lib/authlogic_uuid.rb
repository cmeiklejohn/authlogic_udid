require 'authlogic_uuid/acts_as_authentic'
require 'authlogic_uuid/session'

if ActiveRecord::Base.respond_to?(:add_acts_as_authentic_module)
  ActiveRecord::Base.send(:include, AuthlogicUUID::ActsAsAuthentic)
  Authlogic::Session::Base.send(:include, AuthlogicUUID::Session)
end

