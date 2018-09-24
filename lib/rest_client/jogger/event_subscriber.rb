module RestClient
  module Jogger
    class EventSubscriber
      attr_accessor :logger

      def logger
        @logger ||= ActiveSupport::Logger.new('log/rest_client.log').tap { |l| l.level = Logger::DEBUG }
      end

      def request_pattern
        LoggedRequest::REQUEST_PATTERN
      end

      def response_pattern
        LoggedRequest::RESPONSE_PATTERN
      end

      def subscribe
        ActiveSupport::Notifications.subscribe request_pattern, RequestComplete.new(logger: logger)
        ActiveSupport::Notifications.subscribe response_pattern, RequestComplete.new(logger: logger)
      end
    end
  end
end
