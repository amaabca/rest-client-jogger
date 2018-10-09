# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_client/jogger/version'

Gem::Specification.new do |spec|
  spec.name          = "rest-client-jogger"
  spec.version       = RestClient::Jogger::VERSION
  spec.authors       = ["Jordan Babe", "Jesse Doyle", "Michael van den Beuken"]
  spec.email         = ["jordan.babe@ama.ab.ca", "jesse.doyle@ama.ab.ca", "michael.beuken@gmail.com"]

  spec.summary       = %q{Logs RestClient requests in a JSON format}
  spec.description   = %q{Logs RestClient requests in a JSON format.}
  spec.homepage      = "https://github.com/amaabca/rest-client-jogger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Rails/ActiveModel/ActiveSupport 5.0.X requires ruby >= 2.2.2
  if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2.2')
    spec.add_dependency "activesupport", '>= 4.2'
    spec.add_dependency "activemodel", '>= 4.2'
  else
    spec.add_dependency "activesupport", '~> 4.2'
    spec.add_dependency "activemodel", '~> 4.2'
  end

  spec.add_dependency "mime-types"
  spec.add_dependency "rollbar"
  spec.add_dependency "jbuilder"
  spec.add_dependency 'tilt'
  spec.add_dependency 'tilt-jbuilder'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-json_expectations"
  spec.add_development_dependency "rest-client", "~> 2.0.0"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
end
