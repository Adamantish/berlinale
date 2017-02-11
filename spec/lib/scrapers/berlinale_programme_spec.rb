require 'spec_helper'
require_relative '../../../lib/scrapers/berlinale_programme'

RSpec.describe Scrapers::BerlinaleProgramme do
  subject { described_class.new(page) }
  let(:page) { 20 }

  describe '#data' do
    it 'returns some data' do
      VCR.use_cassette("berlinale_page_#{page}") do
        data = expect(subject.data).to be_a String
        expect(subject.send(:success?)).to be true
      end
    end
  end
end
