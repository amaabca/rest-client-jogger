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
  end
end
