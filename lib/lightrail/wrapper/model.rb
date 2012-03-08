require "lightrail/wrapper/associations"

module Lightrail
  module Wrapper
    class Model
      class_attribute :associations
      self.associations = []

      class << self
        def inherited(base)
          base.class_eval do
            alias_method wrapped_class.model_name.underscore, :resource
          end
        end

        def around_association(collection, scope)
          yield
        end

        # Declares that this object is associated to the given association
        # with cardinality 1..1.
        def has_one(*associations)
          options = associations.extract_options!
          self.associations += associations.map { |a| Associations::HasOneConfig.new(a, options) }
          define_association_methods(associations)
        end

        # Declares that this object is associated to the given association
        # with cardinality 1..*.
        def has_many(*associations)
          options = associations.extract_options!
          self.associations += associations.map { |a| Associations::HasManyConfig.new(a, options) }
          define_association_methods(associations)
        end

        # Based on the declared associations and the given parameters,
        # generate an includes clause that can be passed down to the relation
        # object to avoid doing N+1 queries.
        def valid_includes(includes)
          result = []
          includes.each do |i|
            if association = associations.find { |a| a.includes == i }
              result << association.name
            end
          end
          result
        end

        # Returns the original class wrapped by this wrapper.
        def wrapped_class
          @wrapped_class ||= name.sub(/Wrapper$/, "").constantize
        end

        private

        def define_association_methods(associations)
          associations.each do |association|
            class_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{association}
                @resource.#{association}
              end
            RUBY
          end
        end
      end

      attr_reader :resource, :scope

      def initialize(resource, scope)
        @resource = resource
        @scope    = scope
      end

      def view
        raise NotImplementedError, "No view implemented for #{self}"
      end

      # Gets the view and render the associated object.
      def render(options={}, result=Result.new)
        name         = options[:as] || wrapped_model_name.underscore
        result[name] = view = self.view
        _include_associations(result, view, options[:include])
      end

      # Gets the view and render the associated considering it is part of a collection.
      def render_many(options={}, result=Result.new)
        name     = options[:as] || wrapped_model_name.plural
        view     = self.view
        array    = (result[name] ||= []) << view
        _include_associations(result, view, options[:include])
      end

      private

      def _include_associations(result, view, includes)
        return result if includes.blank?
        associations = result.associations

        self.class.associations.each do |config|
          next unless includes.include?(config.includes)
          object = send(config.name)
          config.update(view, object)
          associations[config.as].concat Array.wrap(object)
        end

        result
      end

      def wrapped_model_name
        self.class.wrapped_class.model_name
      end
    end
  end
end
