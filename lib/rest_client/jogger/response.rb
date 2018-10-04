module RestClient
  module Jogger
    class Response < Action
      def template
        Tilt::JbuilderTemplate.new root.join('templates', 'response_logging_template.json.jbuilder')
      end
    end
  end
end
