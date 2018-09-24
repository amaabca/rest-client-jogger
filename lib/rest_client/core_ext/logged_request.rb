module LoggedRequest
  REQUEST_PATTERN = 'rest_client.request'.freeze
  RESPONSE_PATTERN = 'rest_client.response'.freeze
  DEFAULT_CONTENT_TYPE = 'application/json'.freeze

  def logged_request(opts = {}, &block)
    # We intend on using the following variables in this method's
    # ensure block. This means that we must take care to ensure
    # that we check for nil against these variables whenever they
    # are accessed.
    started = Time.now
    log_request(opts, started)
    response, exception = nil, nil
    response = execute(opts, &block)
  rescue StandardError => ex
    exception = ex.class.to_s
    response = ex.respond_to?(:response) && ex.response
    raise ex # Re-raise the exception, we just wanted to capture it
  ensure
    time_elapsed = (Time.now - started).round(2)
    opts[:exception] = exception
    logged_response = opts.merge({ time_elapsed: time_elapsed })
    logged_response = logged_response.deep_merge(response_data(response)) if response_data(response)
    ActiveSupport::Notifications.instrument RESPONSE_PATTERN, strip_authorization(logged_response)
  end

  private

  def response_data(response = nil)
    if response
      {
        code: response.code,
        payload: response.body.to_s.force_encoding('UTF-8'),
      }
    end
  end

  def strip_authorization(params)
    new_params = params.clone
    if new_params[:headers]
      new_params.merge!({ headers: new_params[:headers].reject { |k, _| k.to_s.casecmp('authorization').zero? }})
    end
    new_params
  end

  def log_request(opts, started)
    ActiveSupport::Notifications.instrument REQUEST_PATTERN, strip_authorization(opts).merge({ started: started})
  end
end
