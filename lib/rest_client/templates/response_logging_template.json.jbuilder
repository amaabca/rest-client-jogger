# frozen_string_literal: true
json.url args[:url]
json.method args[:method]
json.verify_ssl verify_ssl
json.requestHeaders args.fetch(:headers, {})
json.responseHeaders args[:response].try(:headers)
json.body do
  json.request payload
  json.response args[:response].try(:body).to_s.force_encoding('UTF-8')
end
json.sourceIp ip_address
json.eventName LoggedRequest::RESPONSE_PATTERN
json.eventId event_id
json.timeElapsed time_elapsed
json.openTimeout open_timeout
json.readTimeout read_timeout
json.code args[:response].try(:code)
json.timestamp timestamp.iso8601
json.exception args[:exception]
