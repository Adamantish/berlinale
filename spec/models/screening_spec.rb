require 'rails_helper'

RSpec.describe Screening, type: :model do

  let(:html_row) do
    File.new('spec/fixtures/html_row.html').read
  end

  let(:attributes) do
    { title: 'André - The Voice of Wine',
      page_url: 'http://www.berlinale.de/en/programm/berlinale_programm/datenblatt.php?film_id=201715159',
      html_row: html_row }
  end

  subject { described_class.new(attributes) }

  describe '#screening_node' do
    it 'traverses up then down from an available ticket to find screening info' do
      expect(subject.screening_node).to_not be_nil
    end
  end

  describe '#update_from_html' do
    it 'updates various attributes using the raw html' do
      expect(subject).to receive(:update_starts_at_from_html).once
      subject.send(:update_from_html)
    end
  end

  describe '#update_starts_at_from_html' do
    let(:expected_starts_at) { '2017-02-16 19:00:00 +0100'.to_time }
    it 'constructs a datetime with timezone for the ticket row' do
      expect(subject.starts_at).to be_nil
      subject.send(:update_starts_at_from_html)
      expect(subject.starts_at).to eq expected_starts_at
    end
  end

  describe '#save' do
    it 'calls #update_from_html when html_row is changed' do
      subject.save
      expect(subject).to receive(:update_from_html).once
      subject.title = 'schmoodle'
      subject.save!
      subject.html_row = subject.html_row.gsub('first icons', 'second icons')
      subject.save!
    end
  end
end
