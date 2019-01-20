# RestClient::Jogger

JSON Logger for RestClient

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rest-client-jogger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rest-client-jogger

## Usage

The `logged_request` method is the primary interaction with this gem.

You can call `RestClient::Request.logged_request` in place of `RestClient::Request.execute`. The `logged_request` method will send a notification to an `ActiveSupport::Notifications` subscriber.

Here's how to setup the event subscriber in a Rails application:

```ruby
# in an initializer somewhere
require 'rest_client/jogger'

RestClient::Jogger::EventSubscriber.new.subscribe
```

This will log all requests made with the `logged_request` method to a logfile in `log/rest_client.log`.

## Configuration

Some of the parameters used in this gem can be configured in the host application:

```ruby
# in an initializer somewhere
RestClient::Jogger.configure do |config|
  config.request_pattern = 'my.request'            # optional
  config.response_pattern = 'my.response'          # optional
  config.default_content_type = 'application/json' # optional
  config.default_filter_replacement = '[SECRET]'   # optional
  config.log_output = STDOUT                       # optional
  config.filter_parameters = [:param_name]         # optional
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amaabca/rest-client-jogger.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
