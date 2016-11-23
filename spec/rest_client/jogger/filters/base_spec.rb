describe RestClient::Jogger::Filters::Base do
  describe '#filter_data' do
    it 'raises NotImplementedError' do
      expect{ subject.send(:filter_data, [:foo]) }.to raise_error(NotImplementedError)
    end
  end
end
