describe RestClient::Jogger::Filters::QueryParameters do
  let(:filter_parameters) { %i[password] }
  subject { described_class.new(data: url, filters: filter_parameters) }

  describe '#filter' do
    context 'with query parameters in the url' do
      # NOTE: we're also testing the behaviour with a duplicate parameter
      let(:url) { 'https://example.com/foo?password=1234&password=4567&bar=test' }

      it 'returns the url as a string with filtered parameters' do
        expect(subject.filter).to eq('https://example.com/foo?password=[FILTERED]&password=[FILTERED]&bar=test')
      end
    end

    context 'without query parameters in the url' do
      let(:url) { 'https://example.com/foo' }

      it 'returns the url as a string' do
        expect(subject.filter).to eq(url)
      end
    end
  end
end
