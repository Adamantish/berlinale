require 'spec_helper'
require_relative '../../../lib/scrapers/berlinale_programme'
require_relative '../../../lib/parsers/berlinale_page'

RSpec.describe Parsers::BerlinalePage do
  subject { described_class.new(page_body) }
  let(:page_body) do
    VCR.use_cassette('berlinale_page_20') do
      Scrapers::BerlinaleProgramme.new(20).data
    end
  end

  describe '#key_row_indices' do
    it 'returns html_nodes with available tickets' do
      rows = subject.send(:all_film_rows)
      subject.send(:key_row_indices).each do |i|
        buy_link = rows[i].css('a.sprite.tickets_N').first.attributes['href'].value
        expect(buy_link).to include('eventim.de')
      end
    end
  end


  describe '#films' do
    it 'returns array of hashes with relevant information' do
      subject.films
    end
  end
end
