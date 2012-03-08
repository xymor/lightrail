module Lightrail
  module Wrapper
    module Controller
      extend ActiveSupport::Concern

      private

      # Receives an object and render it as JSON considering its respective wrapper.
      def json(object, options={})
        json = Lightrail::Wrapper.render(object, wrapper_scope,
          :include => wrapper_includes, :fallback => controller_name, :as => options.delete(:as))
        render options.merge(:json => json)
      end

      def errors(object)
        render :errors => { object.class.model_name.underscore => object.errors }
      end

      # Receives a relation and add the appropriate includes and configuration.
      # Useful when wrapping up arrays to avoid N+1 queries in the database.
      def wrap_array(array)
        array = array.to_a
        return array if array.empty?

        klass = array[0].class
        valid = Lightrail::Wrapper.find(klass).valid_includes(wrapper_includes)
        return array if valid.empty?

        klass.send(:preload_associations, array, valid)
        array
      end

      # Returns a wrapper around the given object.
      def wrapper(object, scope=wrapper_scope)
        Lightrail::Wrapper.find(object).new(object, scope)
      end

      # Returns given includes as a nested hash.
      def wrapper_includes
        @wrapper_includes ||= params[:include].to_s.split(",")
      end

      # Pass the relevant scope to the wrapper object.
      def wrapper_scope
        raise NotImplementedError, "wrapper_scope needs to be implemented according to your application"
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Lightrail::Wrapper::Controller
end

Lightrail::ActionController::Metal.send :include, Lightrail::Wrapper::Controller