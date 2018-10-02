module RestClient
  module Jogger
    class RequestComplete
      include ::ActiveModel::Model
      attr_accessor :logger, :notifier

      def initialize(args = {})
        self.logger = args.fetch :logger
        super
      end

      def notifier
        @notifier ||= ::Rollbar
      end

      def call(name, start, finish, id, payload)
        message = ::JSON.dump(payload.merge(event_name: name, event_id: id, timestamp: start))
        name =~ /error/ ? logger.error(message) : logger.debug(message)
      rescue StandardError => e
        notifier.warning e, payload: payload
      end

    end
  end
end
