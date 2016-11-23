shared_examples 'a base filter' do
  describe '.filter_class' do
    let(:filter_class) { described_class.filter_class content_type }

    context 'content_type == nil' do
      let(:content_type) { nil }
      it 'defaults to RestClient::Jogger::Filters::Json' do
        expect(filter_class).to eq RestClient::Jogger::Filters::Json
      end
    end

    context 'content_type invalid' do
      let(:content_type) { 'application/json/mf' }

      it 'defaults to RestClient::Jogger::Filters::Json' do
        expect(filter_class).to eq RestClient::Jogger::Filters::Json
      end
    end

    context 'content_type == application/json' do
      let(:content_type) { 'application/json' }

      it 'returns to RestClient::Jogger::Filters::Json' do
        expect(filter_class).to eq RestClient::Jogger::Filters::Json
      end
    end

    context 'content_type == application/xml' do
      let(:content_type) { 'application/xml' }

      it 'returns to RestClient::Jogger::Filters::Xml' do
        expect(filter_class).to eq RestClient::Jogger::Filters::Xml
      end
    end
  end

  describe '#data' do
    let(:data) { 'waffles' }
    it 'defaults to an empty string' do
      subject.data = nil
      expect(subject.data).to eq ''
    end

    it 'is overrideable' do
      subject.data = data
      expect(subject.data).to eq data
    end
  end

  describe '#filters' do
    let(:filters) { [:waffles, :pancakes] }

    before(:each) do
      Rails.configuration.filter_parameters = filters
    end

    it 'defaults to Rails.configuration.filter_parameters' do
      subject.filters = nil
      expect(subject.filters).to eq filters
    end

    it 'is overrideable' do
      subject.filters = filters
      expect(subject.filters).to eq filters
    end
  end

  describe '#filter_replacement' do
    let(:replacement) { '[WAFFLES]' }
    it 'defaults to [FILTERED]' do
      subject.filter_replacement = nil
      expect(subject.filter_replacement).to eq '[FILTERED]'
    end

    it 'is overrideable' do
      subject.filter_replacement = replacement
      expect(subject.filter_replacement).to eq replacement
    end
  end

  describe '#content_type' do
    let(:content_type) { 'application/xml' }

    it 'defaults to application/json' do
      subject.content_type = nil
      expect(subject.content_type).to eq 'application/json'
    end

    it 'is overrideable' do
      subject.content_type = content_type
      expect(subject.content_type).to eq content_type
    end
  end
end
