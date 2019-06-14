module RestClient
  module Jogger
    module Filters
      class Json < RestClient::Jogger::Filters::Base

      private

        def filter_data(filter)
          data.gsub! /"#{filter}":\s*"[^"]*"/, %{"#{filter}": "#{filter_replacement}"}
          data.gsub! /\\n/, ''
        end
      end
    end
  end
end
