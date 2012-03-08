module Lightrail
  module Wrapper
    module Associations
      # +association+ returns the name of the association in the wrapped object.
      # +key+ returns the JSON key  to store the +association+ id.
      # +as+ is the name of the +association+ in the flat JSON.
      # +includes+ is the name expected on the include.
      class AssociationConfig
        attr_reader :name, :as, :key, :includes

        def initialize(name, options)
          @name = name.to_sym
        end

        # Receives a view and update it accordingly with the given object id
        # and the association cardinality.
        def update(view, object)
          raise NotImplementedError
        end
      end

      class HasOneConfig < AssociationConfig
        def initialize(name, options)
          super
          @as          = options[:as] || name.to_s.pluralize.to_sym
          @key         = options[:key] || :"#{name}_id"
          @includes    = options[:includes] || name.to_s.pluralize
        end

        def update(view, object)
          view[@key] = object && object.id
        end
      end

      class HasManyConfig < AssociationConfig
        def initialize(name, options)
          super
          @as          = options[:as] || name.to_sym
          @key         = options[:key] || name.to_sym
          @includes    = options[:includes] || name.to_s
        end

        def update(view, object)
          view[@key] = object.map(&:id)
        end
      end
    end
  end
end