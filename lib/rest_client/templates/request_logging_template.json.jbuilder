# frozen_string_literal: true
json.ignore_nil!
json.url url
json.method args[:method]
json.verifySsl verify_ssl
json.requestHeaders args.fetch(:headers, {})
json.requestBody payload
json.sourceIp ip_address
json.eventName RestClient::Jogger.request_pattern
json.eventId event_id
json.timeElapsed time_elapsed
json.openTimeout open_timeout
json.readTimeout read_timeout
json.timestamp timestamp.iso8601
