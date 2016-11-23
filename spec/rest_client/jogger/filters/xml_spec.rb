describe RestClient::Jogger::Filters::Xml do
  it_behaves_like 'a base filter'

  describe '#filter' do
    let(:filter_params) { [:user, :password] }
    let(:replacement) { RestClient::Jogger::Filters::Base::DEFAULT_REPLACEMENT }
    let(:filter) { described_class.new(data: xml).filter }
    let(:document) { Nokogiri::XML(filter) }

    before(:each) do
      Rails.configuration.filter_parameters = filter_params
    end

    context 'with valid xml' do
      let(:xml) do
        <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <data>
            <user>FakeUser</user>
            <password>supersecret</password>
            <body>Waffles</body>
          </data>
        XML
      end

      it 'filters the keys from xml' do
        expect(document.css('user').first.text).to eq(replacement)
        expect(document.css('password').first.text).to eq(replacement)
        expect(document.css('body').first.text).to eq('Waffles')
      end

      it 'returns a string' do
        expect(filter).to be_a String
      end
    end

    context 'with invalid xml' do
      let(:xml) { 'invalid because a string was returned password: username' }

      it 'returns the input string' do
        expect(filter).to eq(xml)
      end
    end

    context 'with nil input' do
      let(:xml) { nil }

      it 'returns the empty string' do
        expect(filter).to eq('')
      end
    end
  end
end
