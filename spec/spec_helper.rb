require 'simplecov'
require 'nokogiri'
require 'webmock/rspec'
require 'rest-client'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'rspec/json_expectations'
require 'rest_client/jogger'

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

RSpec.configure do |config|
  WebMock.disable_net_connect!

  config.before(:all) do
    FileUtils.mkdir_p('log')
  end
end
