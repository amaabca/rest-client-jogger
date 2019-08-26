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
        params = render_params(start, finish, id, payload)
        json = template.render(nil, params)
        name =~ /error/ ? logger.error(json) : logger.debug(json)
      rescue StandardError => e
        notifier.error e, payload: payload
      end

      def template
        raise NotImplementedError, 'define a #template method in a subclass'
      end

      private

      def render_params(start, finish, id, opts)
        start_time = opts.fetch(:start_time)
        url = opts.fetch(:url)
        headers = opts.fetch(:headers) { {} }
        {
          method: opts[:method],
          headers: headers,
          url: RestClient::Jogger::Filters::QueryParameters.new(data: url).filter,
          payload: filter(body: opts[:payload], headers: headers),
          verify_ssl: opts[:verify_ssl],
          read_timeout: opts.fetch(:timeout) { opts[:read_timeout] },
          open_timeout: opts.fetch(:timeout) { opts[:open_timeout] },
          event_id: id,
          timestamp: start,
          time_elapsed: (finish - start_time).round(10),
          ip_address: ip_address
        }
      end

      def filter(opts = {})
        filter_class(opts.fetch(:headers)).new(data: opts[:body].to_s).filter
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
