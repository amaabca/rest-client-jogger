module RestClient
  module Jogger
    class EventSubscriber
      attr_accessor :logger

      def logger
        @logger ||= ActiveSupport::Logger.new('log/rest_client.log').tap { |l| l.level = Logger::DEBUG }
      end

      def pattern
        LoggedRequest::PATTERN
      end

      def subscribe
        ActiveSupport::Notifications.subscribe pattern, RequestComplete.new(logger: logger)
      end

    end
  end
end
