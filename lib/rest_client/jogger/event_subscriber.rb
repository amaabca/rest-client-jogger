module RestClient
  module Jogger
    class EventSubscriber
      attr_accessor :logger

      def logger
        @logger ||= ActiveSupport::Logger.new(RestClient::Jogger.log_output).tap { |l| l.level = Logger::DEBUG }
      end

      def request_pattern
        RestClient::Jogger.request_pattern
      end

      def response_pattern
        RestClient::Jogger.response_pattern
      end

      def subscribe
        ActiveSupport::Notifications.subscribe request_pattern, Request.new(logger: logger)
        ActiveSupport::Notifications.subscribe response_pattern, Response.new(logger: logger)
      end
    end
  end
end
