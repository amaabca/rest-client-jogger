require 'spec_helper'

describe RestClient::Jogger do
  it 'has a version number' do
    expect(RestClient::Jogger::VERSION).not_to be nil
  end

  describe '#configure' do
    it 'yields a RestClient::Jogger::Configuration instance' do
      described_class.configure do |config|
        expect(config).to be_a(RestClient::Jogger::Configuration)
      end
    end

    context 'filter parameters config' do
      let(:filters) { [:password] }

      before(:each) do
        described_class.configure do |config|
          config.filter_parameters = filters
        end
      end

      it 'set the filters' do
        expect(RestClient::Jogger.filter_parameters).to include :password
      end
    end
  end
end
