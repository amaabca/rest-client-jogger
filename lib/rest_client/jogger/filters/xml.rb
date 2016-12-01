module RestClient
  module Jogger
    module Filters
      class Xml < RestClient::Jogger::Filters::Base

      private

        def filter_data(filter)
          data.gsub! /<#{filter}>(.*)<\/#{filter}>/, %{<#{filter}>#{filter_replacement}</#{filter}>}
        end
      end
    end
  end
end
