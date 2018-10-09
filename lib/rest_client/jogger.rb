require 'json'
require 'mime/types'
require 'active_model'
require 'active_support/all'
require 'rollbar'
require 'tilt/jbuilder'
require 'rest_client/jogger/version'
require 'rest_client/jogger/configuration'
require 'rest_client/jogger/event_subscriber'
require 'rest_client/jogger/action'
require 'rest_client/jogger/request'
require 'rest_client/jogger/response'
require 'rest_client/jogger/filters/base'
require 'rest_client/jogger/filters/json'
require 'rest_client/jogger/filters/xml'
require 'rest_client/core_ext/logged_request'

module RestClient
  class Request
    extend LoggedRequest
  end
  
  module Jogger
    ROOT_PATH = File.expand_path(File.dirname(__FILE__)).freeze

    class << self
      Configuration::ATTRIBUTES.each do |attribute|
        delegate attribute, to: :configuration
      end

      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end
