describe RestClient::Jogger::Action do
  let(:logger) { Logger.new('/dev/null') }
  subject { described_class.new(logger: logger) }

  describe '#notifier' do
    it 'defaults to Rollbar' do
      expect(subject.notifier).to eq(Rollbar)
    end
  end

  describe '#template' do
    it 'raises NotImplementedError' do
      expect { subject.template }.to raise_error(NotImplementedError)
    end
  end
end
