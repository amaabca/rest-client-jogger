module RestClient
  module Jogger
    class Request < Action
      def template
        Tilt::JbuilderTemplate.new root.join('templates', 'request_logging_template.json.jbuilder')
      end
    end
  end
end
