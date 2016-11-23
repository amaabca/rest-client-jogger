describe RestClient::Jogger::Filters::Json do
  it_behaves_like 'a base filter'

  describe '#filter' do
    let(:filter_params) { [:user, :password] }
    let(:replacement) { RestClient::Jogger::Filters::Base::DEFAULT_REPLACEMENT }
    let(:filter) { described_class.new(data: json).filter }
    let(:parsed) { JSON.parse(filter) }

    before(:each) do
      Rails.configuration.filter_parameters = filter_params
    end

    context 'with valid json' do
      let(:json) do
        <<-JSON
          {
            "waffles": {
              "password": "supersecret"
            },
            "user": "fakeuser",
            "data": true
          }
        JSON
      end

      it 'filters the keys from json' do
        expect(parsed['waffles']['password']).to eq(replacement)
        expect(parsed['user']).to eq(replacement)
        expect(parsed['data']).to be true
      end

      it 'returns a string' do
        expect(filter).to be_a String
      end
    end

    context 'with invalid json' do
      let(:json) { 'invalid because a string was returned password: username' }

      it 'returns the input string' do
        expect(filter).to eq(json)
      end
    end

    context 'with nil input' do
      let(:json) { nil }

      it 'returns the empty string' do
        expect(filter).to eq('')
      end
    end
  end
end
