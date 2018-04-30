module LoggedRequest
  PATTERN = 'rest_client.request'.freeze
  DEFAULT_CONTENT_TYPE = 'application/json'.freeze

  def logged_request(opts = {}, &block)
    # We intend on using the following variables in this method's
    # ensure block. This means that we must take care to ensure
    # that we check for nil against these variables whenever they
    # are accessed.
    response, exception = nil, nil
    started = Time.now
    response = execute(opts, &block)
  rescue StandardError => ex
    exception = ex.class.to_s
    response = ex.respond_to?(:response) && ex.response
    raise ex # Re-raise the exception, we just wanted to capture it
  ensure
    time = (Time.now - started).round(2)
    content_type = content_type_from_headers(opts[:headers])
    payload = filter(content_type).new(data: opts[:payload]).filter
    opts[:headers].reject! { |k, _| k.to_s.casecmp('authorization').zero? } if opts[:headers]
    params = opts.except(:user, :password, :payload).merge(payload: payload)
    ActiveSupport::Notifications.instrument PATTERN,
      log_data(params, response, exception, time)
  end

  private

  def log_data(params, response, exception, time)
    request_data(params).merge(
      response: response_data(response),
      exception: exception,
      time_elapsed: time
    )
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

  def request_data(params)
    {
      request: params
    }
  end

  def filter(content_type)
    RestClient::Jogger::Filters::Base.filter_class(content_type)
  end

  def content_type_from_headers(headers)
    (headers && headers[:content_type]) || DEFAULT_CONTENT_TYPE
  end
end
