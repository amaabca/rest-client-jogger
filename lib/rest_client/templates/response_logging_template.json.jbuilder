# frozen_string_literal: true
json.ignore_nil!
json.url url
json.exception exception
json.method method
json.verifySsl verify_ssl
json.requestHeaders headers
json.responseHeaders response_headers
json.requestBody payload
json.responseBody response_body
json.sourceIp ip_address
json.eventName RestClient::Jogger.response_pattern
json.eventId event_id
json.eventAgent RestClient::Jogger::AGENT_VERSION
json.timeElapsed time_elapsed
json.openTimeout open_timeout
json.readTimeout read_timeout
json.code code
json.timestamp timestamp.iso8601
