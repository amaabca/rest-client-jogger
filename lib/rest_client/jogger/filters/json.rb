module RestClient
  module Jogger
    module Filters
      class Json < Base

        private

        def filter_data(filter)
          data.gsub! /"#{filter}":\s*"[^"]*"/, %{"#{filter}": "#{filter_replacement}"}
        end
      end
    end
  end
end
