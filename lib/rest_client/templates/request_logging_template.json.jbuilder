# frozen_string_literal: true
json.url args[:url]
json.method args[:method]
json.verify_ssl verify_ssl
json.headers args.fetch(:headers, {})
json.body do
  json.request payload
end
json.sourceIp ip_address
json.eventName LoggedRequest::REQUEST_PATTERN
json.eventId event_id
json.timeElapsed time_elapsed
json.openTimeout open_timeout
json.readTimeout read_timeout
json.timestamp timestamp.iso8601
