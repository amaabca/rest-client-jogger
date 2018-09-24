# frozen_string_literal: true
json.url args[:url]
json.method args[:method]
json.verify_ssl args[:verify_ssl]

json.headers do
  json.dateTime Time.now
  json.executionTime Time.now
  json.action 'request'
  json.merge! args[:headers]
end
json.body do
  json.payload args[:payload]
end
json.sourceIp ip_address
json.details do
  json.eventName LoggedRequest::REQUEST_PATTERN
  json.eventId event_id
  json.timeElapsed (Time.now - args[:started])
  json.openTimeout args[:open_timeout]
  json.readTimeout args[:timeout]
end

json.timestamp timestamp
