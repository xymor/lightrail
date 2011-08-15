require 'action_controller'
require 'active_support/concern'
require 'strobe/action_controller/metal'

Mime::Type.register "text/x-spml", :spml