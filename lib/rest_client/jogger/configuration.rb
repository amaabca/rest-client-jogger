module RestClient
  module Jogger
    class Configuration
      include ActiveModel::Model

      REQUIRED_ATTRIBUTES = %i().freeze
      OPTIONAL_ATTRIBUTES = %i(
        request_pattern
        response_pattern
        default_content_type
        default_filter_replacement
        log_output
        filter_parameters
      ).freeze
      ATTRIBUTES = (REQUIRED_ATTRIBUTES | OPTIONAL_ATTRIBUTES).freeze

      attr_accessor *ATTRIBUTES

      def request_pattern
        @request_pattern || 'rest_client.request'
      end

      def response_pattern
        @response_pattern || 'rest_client.response'
      end

      def default_content_type
        @default_content_type || 'application/json'
      end

      def default_filter_replacement
        @default_filter_replacement || '[FILTERED]'
      end

      def log_output
        @log_output || 'log/rest_client.log'
      end

      def filter_parameters
        @filter_parameters || []
      end
    end
  end
end
