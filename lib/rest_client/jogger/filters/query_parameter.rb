module RestClient
  module Jogger
    module Filters
      class QueryParameter
        attr_accessor :url

        def initialize(opts = {})
          self.url = opts.fetch(:url)
        end

        def filter
          duplicate = uri.dup
          duplicate.query = parameters
          duplicate.to_s
        end

        private

        def parameters
          CGI.parse(uri.query.to_s).each_with_object([]) do |(key, values), memo|
            values.each do |value|
              memo << "#{key}=#{filtered_value(key, value)}"
            end
          end.join('&')
        end

        def filtered_value(key, value)
          filter_parameters.include?(key.to_sym) ? RestClient::Jogger.configuration.default_filter_replacement : value
        end

        def filter_parameters
          @filter_parameters ||= begin
            defined?(Rails) ? Rails.configuration.filter_parameters : RestClient::Jogger.filter_parameters
          end
        end

        def uri
          @uri ||= URI.parse(url)
        end
      end
    end
  end
end
