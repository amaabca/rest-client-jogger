module LoggedRequest
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
    response = ex.respond_to?(:response) ? ex.response : nil
    raise ex # Re-raise the exception, we just wanted to capture it
  ensure
    logged_response = opts.merge(exception: exception, response: response)
    ActiveSupport::Notifications.instrument(
      RestClient::Jogger.response_pattern,
      log_payload(logged_response, started)
    )
  end

  private

  def log_payload(params, started)
    params.merge(
      headers: filtered_headers(params),
      start_time: started
    )
  end

  def filtered_headers(opts)
    headers = opts.fetch(:headers) { {} }
    RestClient::Jogger::Filters::Headers.new(data: headers).filter
  end

  def log_request(opts, started)
    ActiveSupport::Notifications.instrument(
      RestClient::Jogger.request_pattern,
      log_payload(opts, started)
    )
  end
end
