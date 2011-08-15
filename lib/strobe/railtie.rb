require "strobe/action_controller"
require "rails/railtie"

module Strobe
  class Railtie < Rails::Railtie
    class Wrapper
      def initialize(config)
        @config = config
      end
      
      def remove_session_middlewares!
        @config.app_middleware.delete "ActionDispatch::Cookies"
        @config.app_middleware.delete "ActionDispatch::Session::CookieStore"
        @config.app_middleware.delete "ActionDispatch::Flash"
      end

      def remove_browser_middlewares!
        @config.app_middleware.delete "ActionDispatch::BestStandardsSupport"
      end
    end

    config.strobe = Wrapper.new(config)
    
    initializer "strobe.action_controller.set_config" do |app|
      Strobe::ActionController::Metal.class_eval do
        include app.routes.url_helpers
        self.logger      ||= Rails.logger
        self.cache_store ||= RAILS_CACHE
        prepend_view_path "app/views"
        app.config.action_controller.each { |k,v| send("#{k}=", v) rescue nil }
      end
    end
  end
end