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
          hash   = ActiveSupport::OrderedHash.new
          target = @messages || self
          target.each_key { |k| hash[k] = target[k][0] }
          hash
        end
      end
    end
  end
end