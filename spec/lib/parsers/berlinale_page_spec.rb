require 'spec_helper'
require_relative '../../../lib/scrapers/berlinale_programme'
require_relative '../../../lib/parsers/berlinale_page'

RSpec.describe Parsers::BerlinalePage do
  let(:page_body) do
    VCR.use_cassette('berlinale_page_20') do
      Scrapers::BerlinaleProgramme.new(20).data
    end
  end

  subject { described_class.new(page_body) }
  describe '#film_row_nodes' do
    it 'returns html_nodes with available tickets' do
      subject.send(:film_row_nodes).each do |row|
        buy_link = row.css('a.sprite.tickets_N').first.attributes['href'].value
        expect(buy_link).to include('eventim.de')
      end
    end
  end
end
