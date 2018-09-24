# frozen_string_literal: true
json.url args[:url]
json.method args[:method]
json.verify_ssl args[:verify_ssl]

json.headers do
  json.dateTime Time.now
  json.executionTime Time.now
  json.action 'response'
  json.merge! args[:headers]
end
json.body do
  json.payload args[:payload]
end
json.sourceIp ip_address
json.details do
  json.eventName LoggedRequest::RESPONSE_PATTERN
  json.eventId event_id
  json.timeElapsed args[:time_elapsed]
  json.openTimeout args[:open_timeout]
  json.readTimeout args[:timeout]
end

json.code args[:code]
json.timestamp timestamp
json.exception args[:exception]
