module RestClient
  module Jogger
    module Filters
      class Headers < Base
        DEFAULT_FILTERS = %w[authorization].freeze

        def filter
          filtered_keys = string_filters
          data.each_with_object({}) do |(key, value), memo|
            if filtered_keys.include?(key.to_s.downcase)
              memo[key] = filter_replacement
            else
              memo[key] = value
            end
          end
        end

        private

        def string_filters
          DEFAULT_FILTERS | normalized_filters
        end

        def normalized_filters
          filters
            .select { |e| e.is_a?(Symbol) || e.is_a?(String) }
            .map { |e| e.to_s.downcase }
        end
      end
    end
  end
end
