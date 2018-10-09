module RestClient
  module Jogger
    module Filters
      class Base
        DEFAULT_REPLACEMENT = '[FILTERED]'.freeze

        include ActiveModel::Model

        attr_accessor :data, :content_type, :filters, :filter_replacement

        def self.filter_class(content_type)
          type = MIME::Types[content_type].first
          if type && type.sub_type == 'xml'
            RestClient::Jogger::Filters::Xml
          else
            RestClient::Jogger::Filters::Json
          end
        end

        def initialize(opts = {})
          super
          self.data = data.dup
        end

        def filter
          filters.each do |filter|
            filter_data filter
          end
          data
        end

        def data
          @data ||= ''
        end

        def filter_replacement
          @filter_replacement ||= DEFAULT_REPLACEMENT
        end

        def filters
          @filters ||= filter_parameters
        end

        def content_type
          @content_type ||= 'application/json'
        end

      private

        def filter_parameters
          defined?(Rails) ? Rails.configuration.filter_parameters : []
        end

        def filter_data(filter)
          raise NotImplementedError
        end
      end
    end
  end
end
