module LoggedRequest
  REQUEST_PATTERN = 'rest_client.request'.freeze
  RESPONSE_PATTERN = 'rest_client.response'.freeze
  DEFAULT_CONTENT_TYPE = 'application/json'.freeze

  def logged_request(opts = {}, &block)
    # We intend on using the following variables in this method's
    # ensure block. This means that we must take care to ensure
    # that we check for nil against these variables whenever they
    # are accessed.
    response, exception = nil, nil
    started = Time.now
    ActiveSupport::Notifications.instrument REQUEST_PATTERN,
      log_request(opts)
    require "pry"; binding.pry
    response = execute(opts, &block)
  rescue StandardError, RestClient::Exception => ex
    require "pry"; binding.pry
    exception = ex.class.to_s
    response = ex.respond_to?(:response) && ex.response
    raise ex # Re-raise the exception, we just wanted to capture it
  ensure
    require "pry"; binding.pry
    time = (Time.now - started).round(2)
    ActiveSupport::Notifications.instrument RESPONSE_PATTERN,
      log_response(response, exception, time)
  end

  private

  def log_request(opts)
    content_type = content_type_from_headers(opts[:headers])
    payload = filter(content_type).new(data: opts[:payload]).filter
    opts[:headers].reject! { |k, _| k.to_s.casecmp('authorization').zero? } if opts[:headers]
    params = opts.except(:user, :password, :payload).merge(payload: payload)
    {
      request: params
    }
  end

  def log_response(response, exception, time)
    {
      response: response_data(response),
      exception: exception,
      time_elapsed: time
    }
  end

  def response_data(response = nil)
    if response
      {
        code: response.code,
        headers: response.headers.reject { |k, _| k.to_s.casecmp('authorization').zero? },
        body: response.body.to_s.force_encoding('UTF-8')
      }
    end
  end

  def filter(content_type)
    RestClient::Jogger::Filters::Base.filter_class(content_type)
  end

  def content_type_from_headers(headers)
    (headers && headers[:content_type]) || DEFAULT_CONTENT_TYPE
  end
end
