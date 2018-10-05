# frozen_string_literal: true
json.ignore_nil!
json.exception args[:exception]
json.url args[:url]
json.method args[:method]
json.verifySsl verify_ssl
json.requestHeaders args.fetch(:headers, {})
json.responseHeaders args[:response].try(:headers)
json.requestBody payload
json.responseBody args[:response].try(:body).to_s.force_encoding('UTF-8')
json.sourceIp ip_address
json.eventName LoggedRequest::RESPONSE_PATTERN
json.eventId event_id
json.timeElapsed time_elapsed
json.openTimeout open_timeout
json.readTimeout read_timeout
json.code args[:response].try(:code)
json.timestamp timestamp.iso8601
