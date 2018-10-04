describe RestClient::Jogger::Request do
  let(:logger) { Logger.new('/dev/null') }
  subject { described_class.new(logger: logger) }

  describe '#template' do
    it 'returns a Tilt::JbuilderTemplate' do
      expect(subject.template).to be_a(Tilt::JbuilderTemplate)
    end

    it 'returns the request template' do
      expect(subject.template.file).to match(/request/)
    end
  end
end
