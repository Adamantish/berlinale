require 'spec_helper'
require_relative '../../../lib/scrapers/berlinale_programme'
require_relative '../../../lib/parsers/berlinale_page'
require_relative '../../../lib/normalisers/absolute_links'

RSpec.describe Parsers::BerlinalePage do
  subject { described_class.new(page_body) }
  let(:page_body) do
    VCR.use_cassette('berlinale_page_20') do
      Scrapers::BerlinaleProgramme.new(20).data
    end
  end

  describe '#ticket_icons' do
    let(:ticket_icons) { subject.send(:ticket_icons) }
    let(:expected_first_icon_html) do
      "<a data-ticket=\"130-20170212-1630\" class=\"sprite tickets_N\" target=\"_blank\" href=\"https://secure.eventim.de/tinfo.dll?fun=evdetail&amp;doc=evdetailb&amp;key=1601438%249373953&amp;affiliate=BNA&amp;language=en\" onclick=\"javascript:ticketonlinepopup('https://secure.eventim.de/tinfo.dll?fun=evdetail&amp;doc=evdetailb&amp;key=1601438$9373953&amp;affiliate=BNA&amp;language=en'); return false;\" title=\"Online tickets\"></a>"
    end

    it 'returns array of hashes with relevant information' do
      expect(ticket_icons.count).to eq 41
      expect(ticket_icons.first.to_html).to eq expected_first_icon_html
    end
  end

  describe '#title_row' do
    let(:screening_parent_row) { subject.send(:screening_parent_row, ticket_icon) }
    let(:title_row) { subject.send(:title_row, screening_parent_row) }

    context 'when title row is to be found lower down than screening row' do
      let(:ticket_icon) { subject.send(:ticket_icons).first }
      it 'returns a different row that contains the first listed title' do
        expect(subject.send(:title_row, screening_parent_row)).to_not be screening_parent_row
        expect(title_row.css('td.title a')).to_not be_empty
      end
    end

    context 'when title can be found in the screening_parent_row' do
      let(:ticket_icon) { subject.send(:ticket_icons)[11] }
      it 'returns exactly what it was passed' do
        expect(subject.send(:title_row, screening_parent_row)).to be screening_parent_row
      end
    end
  end

  describe '#screenings' do
    let(:screenings) { subject.screenings }
    it 'returns array of hashes with relevant information' do
      expect(screenings.first).to include(title: 'Premières armes',
                                          page_url: 'https://www.berlinale.de/en/programm/berlinale_programm/datenblatt.php?film_id=201816369',
                                          starts_at: '2017-02-20 16:00:00 +0100'.to_time,
                                          cinema: 'CineStar 8 (E)'
                                          )
    end

    context 'when no films on page' do
      let(:page_body) do
        VCR.use_cassette('berlinale_page_100') do
          Scrapers::BerlinaleProgramme.new(100).data
        end
      end

      it 'returns nil' do
        expect(subject.screenings).to be_nil
      end
    end
  end
end
