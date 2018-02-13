require 'nokogiri'

class ScreeningsImporter
  def process
    page = 0

    ActiveRecord::Base.transaction do
      get_the_previous
      Screening.delete_all
      loop do
        page += 1
        body = Scrapers::BerlinaleProgramme.new(page).data
        results = Parsers::BerlinalePage.new(body).results
        break unless results
        results.each do |result| 
          film = Film.find_or_create_by(result[:film])
          provide_screening(result[:screening], film).save!
        end
        puts "Inserting #{results.count} screenings"
      end
    end

    puts 'Complete!'
  end

  private

  def get_the_previous
    @the_previous ||= {}.tap do |hsh|
      Screening.where(ticket_status: ['current', 'future']).select(:film_id, :cinema, :starts_at, :ticket_status, :sale_began_at, :soldout_at).to_a.each do |screening|
        hsh[screening.identifier] = { ticket_status_was: screening.ticket_status, sale_began_at_was: screening.sale_began_at, soldout_at_was: screening.soldout_at }
      end
    end
  end

  def provide_screening(screening_hash, film)
    Screening.new(screening_hash.merge(film_id: film.id)).tap do |screening|
      previous_details = @the_previous[screening.identifier] || {}
      screening.sale_began_at = previous_details[:sale_began_at_was]
      screening.soldout_at = previous_details[:soldout_at_was]
      ticket_status_was       = previous_details[:ticket_status_was]

      transition = [ticket_status_was, screening.ticket_status]
      screening.sale_began_at ||= Time.now.utc if transition == ['future', 'current'] || transition == [nil, 'current']
      screening.soldout_at    ||= Time.now.utc      if transition == ['current', 'soldout']
    end
  end
end
