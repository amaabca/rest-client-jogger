describe RestClient::Jogger::Response do
  subject(:completer) { RestClient::Jogger::Response.new(logger: logger, notifier: notifier) }
  let(:logger_path) { 'log/instrumenter_logger.log' }
  let(:logger) { ActiveSupport::Logger.new(logger_path).tap { |l| l.level = Logger::DEBUG } }
  let(:notifier) { instance_double('ErrorNotifier', :error) }

  before(:each) do
    Rails.configuration.filter_parameters = %i[secret]
  end

  after(:all) do
    Rails.configuration.filter_parameters = nil
  end

  describe '#initialize' do
    it 'requires a logger argument' do
      expect { subject.class.new }.to raise_error(KeyError, /key not found: :logger/)
    end
  end

  describe '#notifier' do
    it 'defaults to Rollbar' do
      completer.notifier = nil
      expect(completer.notifier).to eq Rollbar
    end

    it 'is overridable' do
      expect(completer.notifier).to eq notifier
    end
  end

  describe '#call' do
    let(:body) { { success: true }.to_json }
    let(:request) { RestClient::Request.new(method: :get, url: 'https://example.com') }
    let(:net_http_response) { Net::HTTPResponse.new('HTTP/2', '200', body) }
    let(:response) do
      RestClient::Response.create(
        body,
        net_http_response,
        request
      )
    end
    let(:payload) do
      {
        exception: '',
        method: 'post',
        url: 'https://example.com/waffles.json',
        start_time: Time.now,
        response: response
      }
    end
    let(:timestamp) { Time.now }

    context 'without errors' do
      before(:each) do
        net_http_response.add_field('Secret', 's3cret')
        net_http_response.add_field('Content-Type', 'application/json')
        File.open(logger_path, 'w') { |f| f.truncate(0) }
        completer.call(
          'rest_client.response',
          timestamp,
          timestamp,
          '9c122712f744339c29e7',
          payload
        )
      end

      it 'logs the payload as JSON' do
        expect(File.read(logger_path)).to include(
          payload[:exception].to_json,
          payload[:method].to_json,
          payload[:url].to_json
        )
      end

      it 'logs event start time as a Loggly parseable timestamp' do
        expect(File.read(logger_path)).to include(timestamp.iso8601.to_json)
      end

      it 'filters the response headers' do
        expect(File.read(logger_path)).to include('"responseHeaders":{"secret":"[FILTERED]"')
      end
    end

    context 'logger is invalid' do
      it 'notifies' do
        completer.logger = {}
        expect(completer.notifier).to receive(:error).once
        completer.call(
          'rest_client.request',
          timestamp,
          timestamp,
          '9c122712f744339c29e7',
          payload
        )
      end
    end
  end
end
