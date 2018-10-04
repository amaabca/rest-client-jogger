module RestClient
  module Jogger
    class Action
      include ActiveModel::Model
      attr_accessor :logger, :notifier

      def initialize(args = {})
        self.logger = args.fetch :logger
        super
      end

      def notifier
        @notifier ||= ::Rollbar
      end

      def call(name, start, finish, id, payload)
        start_time = payload.fetch(:start_time)
        render_params = {
          args: payload,
          payload: filter(payload),
          verify_ssl: payload[:verify_ssl] != OpenSSL::SSL::VERIFY_NONE,
          read_timeout: payload.fetch(:timeout) { payload[:read_timeout] },
          open_timeout: payload.fetch(:timeout) { payload[:open_timeout] },
          event_id: id,
          timestamp: start,
          time_elapsed: (finish - start_time).round(10),
          ip_address: ip_address
        }
        json = template.render nil, render_params
        name =~ /error/ ? logger.error(json) : logger.debug(json)
      rescue StandardError => e
        notifier.error e, payload: payload
      end

      def template
        raise NotImplementedError, 'define a #template method in a subclass'
      end

      private

      def filter(opts = {})
        filter_class(opts[:headers]).new(data: opts[:payload].to_s).filter
      end

      def filter_class(headers = {})
        content_type = headers.fetch(:content_type) { 'application/json' }
        RestClient::Jogger::Filters::Base.filter_class(content_type)
      end

      def root
        Pathname.new(ROOT_PATH).freeze
      end

      def ip_address
        Socket.ip_address_list.select(&:ipv4_private?).first.try(:ip_address)
      end
    end
  end
end
