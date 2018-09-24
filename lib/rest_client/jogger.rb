require "json"
require "mime/types"
require "active_model"
require "rollbar"
require "tilt/jbuilder"
require "rest_client/jogger/version"
require "rest_client/jogger/event_subscriber"
require "rest_client/jogger/request_complete"
require "rest_client/jogger/filters/base"
require "rest_client/jogger/filters/json"
require "rest_client/jogger/filters/xml"
require "rest_client/core_ext/logged_request"

module RestClient
  class Request
    extend LoggedRequest
  end
  module Jogger
    ROOT_PATH = File.expand_path(File.dirname(__FILE__)).freeze
  end
end
