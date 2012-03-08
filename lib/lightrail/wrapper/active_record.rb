module Lightrail
  module Wrapper
    module ActiveRecord
      def slice(*attrs)
        attrs.map! { |a| a.to_s }
        attributes.slice(*attrs)
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Lightrail::Wrapper::ActiveRecord
end

