describe RestClient::Request do
  describe ::LoggedRequest do
    describe '.logged_request' do
      let(:url) { 'http://example.com' }
      let(:response) { 'hello, world!' }
      let(:request_pattern) { RestClient::Jogger.request_pattern }
      let(:response_pattern) { RestClient::Jogger.response_pattern }

      before(:each) do
        @was_called = false
        @payload = nil
        @request = nil
        Rails.configuration.filter_parameters = [:user, :password]
        ActiveSupport::Notifications.unsubscribe(request_pattern)
        ActiveSupport::Notifications.unsubscribe(response_pattern)

        ActiveSupport::Notifications.subscribe(request_pattern) do |*request|
          @request = request
          @was_called = true
          request_subscription.call request.last
        end

        ActiveSupport::Notifications.subscribe(response_pattern) do |*payload|
          @payload = payload
          @was_called = true
          response_subscription.call payload.last
        end
      end

      context 'HTTP 200' do
        let(:headers) { { authorization: 'some bearer token', accept: 'json' } }
        let(:status) { 200 }
        let(:response_subscription) do
          -> (payload) {
            expect(payload[:response].body).to eq(response)
            expect(payload[:response].headers).to be_a Hash
            expect(payload[:start_time]).to be_a Time
          }
        end
        let(:request_subscription) do
          -> (request) {
            expect(request[:payload]).to eq("payload")
            expect(request[:headers]).to be_a Hash
            expect(request[:start_time]).to be_a Time
          }
        end

        before(:each) do
          WebMock.stub_request(:any, url).to_return(body: response, status: status, headers: headers)
          RestClient::Request.logged_request(
            method: :get,
            payload: 'payload',
            url: url,
            headers: headers
          )
        end

        context 'request' do
          it 'notifies any subscribers' do
            expect(@was_called).to be true
          end

          it 'filters the authorization header' do
            expect(@request.last[:headers][:authorization]).to eq('[FILTERED]')
          end
        end

        context 'response' do
          it 'notifies any subscribers' do
            expect(@was_called).to be true
          end
        end
      end

      context 'HTTP 400 (exception with response)' do
        let(:status) { 400 }
        let(:headers) { { authorization: 'some bearer token', accept: 'json' } }

         let(:response_subscription) do
          -> (payload) {
            expect(payload[:response].body).to eq(response)
            expect(payload[:exception]).to eq('RestClient::BadRequest')
            expect(payload[:response].code).to eq(400)
            expect(payload[:response].headers).to be_a Hash
            expect(payload[:start_time]).to be_a Time
          }
        end
        let(:request_subscription) do
          -> (request) {
            expect(request[:payload]).to eq("payload")
            expect(request[:headers]).to be_a Hash
          }
        end

        before(:each) do
          WebMock.stub_request(:any, url).to_return(body: response, status: status, headers: headers)
        end

        it 'notifies any subscribers and specifies the exception class' do
          exec = -> { RestClient::Request.logged_request(method: :get, payload: 'payload', url: url, headers: headers) }
          expect { exec.call }.to raise_error(RestClient::BadRequest)
          expect(@was_called).to be true
        end
      end

      context 'HTTP Timeout' do
        let(:headers) { { authorization: 'some bearer token', accept: 'json' } }
        let(:response_subscription) do
          -> (payload) {
            expect(payload[:exception]).to eq('RestClient::Exceptions::OpenTimeout')
            expect(payload[:response]).to be_nil
            expect(payload[:start_time]).to be_a Time
          }
        end

        let(:request_subscription) do
          -> (request) {
            expect(request[:payload]).to eq("payload")
            expect(request[:headers]).to be_a Hash
          }
        end

        before(:each) do
          WebMock.stub_request(:any, url).and_timeout
        end

        it 'notifies subscribers, specifies exception class and has nil response' do
          exec = -> { RestClient::Request.logged_request(method: :get, payload: 'payload', url: url, headers: headers) }
          expect { exec.call }.to raise_error(RestClient::Exceptions::OpenTimeout)
          expect(@was_called).to be true
        end
      end

      context 'a ArgumentError' do
        let(:headers) { { authorization: 'some bearer token', accept: 'json' } }
        let(:response_subscription) do
          -> (payload) {
            expect(payload[:exception]).to eq('ArgumentError')
            expect(payload[:response]).to be nil
            expect(payload[:start_time]).to be_a Time
          }
        end

        let(:request_subscription) do
          -> (request) {
            expect(request[:payload]).to eq("payload")
            expect(request[:headers]).to be_a Hash
          }
        end

        before(:each) do
          WebMock.stub_request(:any, url).to_raise(ArgumentError)
        end

        it 're-raises ArgumentError' do
          exec = -> { RestClient::Request.logged_request(method: :get, payload: 'payload', url: url, headers: headers) }
          expect { exec.call }.to raise_error(ArgumentError)
          expect(@was_called).to be true
        end
      end
    end
  end
end
