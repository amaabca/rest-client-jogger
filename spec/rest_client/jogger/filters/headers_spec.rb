describe RestClient::Jogger::Filters::Headers do
  let(:filter_parameters) { [:secret, 'password', /visible/i] }
  subject { described_class.new(data: headers, filters: filter_parameters) }

  describe '#filter' do
    let(:headers) do
      {
        'Secret' => 's3cret',
        'Password' => 'passw0rd',
        'Visible' => 'test',
        'Content-Type' => 'application/test'
      }
    end

    it 'filters out specified header values' do
      expect(subject.filter).to eq(
        'Secret' => '[FILTERED]',
        'Password' => '[FILTERED]',
        'Visible' => 'test',
        'Content-Type' => 'application/test'
      )
    end
  end
end
