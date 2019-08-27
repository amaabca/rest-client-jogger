module RestClient
  module Jogger
    module Filters
      class QueryParameters < Base
        def filter
          return uri.to_s if uri.query.blank?
          uri.dup.tap { |u| u.query = parameters }.to_s
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
          filters.include?(key.to_sym) ? filter_replacement : value
        end

        def uri
          @uri ||= URI.parse(data)
        end
      end
    end
  end
end
