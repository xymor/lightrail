module Lightrail
  module ActionController
    module Param
      def param(key)
        key.to_s.split('.').inject(params) do |param, key|
          return unless param
          param[key]
        end
      end
    end
  end
end