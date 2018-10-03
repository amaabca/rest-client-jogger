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
        render_params = {
          args: payload,
          event_id: id,
          timestamp: start,
          execution_time: (finish-start).round(3),
          ip_address: ip_address
        }
        json_render = template(name).render nil, render_params
        json_render = stringify_details(json_render)
        name =~ /error/ ? logger.error(json_render) : logger.debug(json_render)
      rescue StandardError => e
        notifier.error e, payload: payload
      end

      def template(name)
        LoggedRequest::REQUEST_PATTERN==name ? request_template : response_template
      end

      def request_template
        Tilt::JbuilderTemplate.new root.join('templates', 'request_logging_template.json.jbuilder')
      end

      def response_template
        Tilt::JbuilderTemplate.new root.join('templates', 'response_logging_template.json.jbuilder')
      end

      def root
        Pathname.new(ROOT_PATH).freeze
      end

      def ip_address
        Socket.ip_address_list.detect(&:ipv4_private?).ip_address if Socket.ip_address_list.detect(&:ipv4_private?)
      end

      def stringify_details(rendered_payload)
        parsed_json_render = JSON.parse(rendered_payload)
        parsed_json_render["details"] = parsed_json_render["details"].to_json
        parsed_json_render.to_json
      end
    end
  end
end
