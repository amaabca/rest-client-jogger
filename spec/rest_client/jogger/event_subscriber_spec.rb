describe RestClient::Jogger::EventSubscriber do
  describe "#logger" do
    it "#level defaults to DEBUG" do
      expect(subject.logger.level).to eq Logger::DEBUG
    end
  end

  describe "#request_pattern" do
    it "defaults" do
      expect(subject.request_pattern).to be_present
    end
  end

  describe "#response_pattern" do
    it "defaults" do
      expect(subject.response_pattern).to be_present
    end
  end

  describe "#subscribe" do
    it "subscribes to all event streams in #request_pattern" do
      subject.subscribe
      expect(ActiveSupport::Notifications.notifier.listening? subject.request_pattern.to_s).to be(true)
    end

    it "subscribes to all event streams in #response_pattern" do
      subject.subscribe
      expect(ActiveSupport::Notifications.notifier.listening? subject.response_pattern.to_s).to be(true)
    end

    it "subscribes to rest_client.request" do
      expect(ActiveSupport::Notifications.notifier.listening? "rest_client.request").to be(true)
    end
  end
end
