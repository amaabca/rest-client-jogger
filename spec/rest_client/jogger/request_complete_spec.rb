describe RestClient::Jogger::RequestComplete do
  subject(:completer) { RestClient::Jogger::RequestComplete.new logger: logger, notifier: notifier }
  let(:logger_path) { 'log/instrumenter_logger.log' }
  let(:logger) { ActiveSupport::Logger.new(logger_path).tap {|l| l.level = Logger::DEBUG } }
  let(:notifier) { instance_double("ErrorNotifier", :error) }

  describe "#initialize" do
    it "requires a logger argument" do
      expect { subject.class.new }.to raise_error(KeyError, /key not found: :logger/)
    end
  end

  describe "#notifier" do
    it "defaults to Rollbar" do
      completer.notifier = nil
      expect(completer.notifier).to eq Rollbar
    end

    it "is overridable" do
      expect(completer.notifier).to eq notifier
    end
  end

  describe "#call" do
    let(:payload) { { exception: "", method: "post", url: "https://example.com/waffles.json" } }
    let(:timestamp) { Time.now }

    context "without errors" do
      before(:each) do
        f = File.open(logger_path, "w") and f.close
        completer.call "rest_client.response", timestamp, timestamp, "9c122712f744339c29e7", payload
      end

      it "logs the payload as JSON" do
        expect(File.read(logger_path)).to include(payload[:exception].to_json, payload[:method].to_json,payload[:url].to_json)
      end

      it "logs event start time as a Loggly parseable timestamp" do
        expect(File.read(logger_path)).to include (timestamp.to_json)
      end
    end

    context "logger is invalid" do
      it "notifies" do
        completer.logger = {}
        expect(completer.notifier).to receive :error
        completer.call "rest_client.request", timestamp, timestamp, "9c122712f744339c29e7", payload
      end
    end
  end
end
