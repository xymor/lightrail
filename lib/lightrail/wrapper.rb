module Lightrail
  module Wrapper
    class Result < Hash
      attr_reader :associations

      def initialize
        super
        @associations = Hash.new { |h,k| h[k] = [] }
      end
    end

    class << self
      # Receives an object and returns its wrapper.
      def find(model)
        klass = model.is_a?(Class) ? model : model.class
        ActiveSupport::Dependencies.constantize("#{klass.name}Wrapper")
      end

      # Receives an object, find its wrapper and render it.
      # If the object is an array, loop for each element in the
      # array and call +render_many+ (instead of +render+).
      def render(object, scope, options={}, result={})
        result = Result.new.merge!(result)

        if object.blank?
          handle_blank(object, result, options)
        elsif object.respond_to?(:each)
          object.each { |i| Lightrail::Wrapper.find(i).new(i, scope).render_many(options, result) }
        else
          Lightrail::Wrapper.find(object).new(object, scope).render(options, result)
        end

        result.associations.inject(result) do |final, (key, value)|
          value.uniq!
          render_association(value, scope, { :as => key }, final)
        end
      end

      def render_association(value, scope, options, result)
        if value.empty?
          handle_blank(value, result, options)
          result
        else
          wrapper = Lightrail::Wrapper.find(value.first)
          wrapper.around_association(value, scope) do
            value.each { |i| wrapper.new(i, scope).render_many(options, result) }
            result
          end
        end
      end

      private

      def handle_blank(object, result, options)
        name   = options[:as] || options[:fallback]
        name ||= object ? "resources" : "resource"
        result[name] = object
      end
    end
  end
end

require "lightrail/wrapper/model"
require "lightrail/wrapper/controller"
require "lightrail/wrapper/active_record"
