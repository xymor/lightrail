require 'active_model/errors'

module Strobe
  module Models
    module Errors
      def errors
        @errors ||= Strobe::Models::Errors::Errors.new(self)
      end

      class Errors < ::ActiveModel::Errors
        # Only show one message per error key.
        def as_json(options=nil)
          hash = ActiveSupport::OrderedHash.new
          @messages.each { |k, v| hash[k] = v[0] }
          hash
        end
      end
    end
  end
end