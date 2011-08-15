module Strobe
  module ActionController
    module Haltable
      def process_action(*)
        opts = catch :halt do
          return super
        end

        if opts
          render opts
        end
      end

      def halt(opts = nil)
        throw :halt, opts
      end
    end
  end
end

ActionController::Renderers.add :errors do |errors, opts|
  json = { :errors => errors }.to_json(opts)
  self.status         = 422 if status == 200
  self.content_type ||= Mime::JSON
  self.response_body  = json
end      
