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
      Screening.where(ticket_status: ['current', 'future']).to_a.each do |screening|
        hsh[screening.identifier] = screening
      end
    end
  end

  def provide_screening(screening_hash, film)
    Screening.new(screening_hash.merge(film_id: film.id)).tap do |screening|
      previous_screening = @the_previous[screening.identifier]
      transition = [previous_screening&.ticket_status, screening.ticket_status]

      if transition.first != 'current' && transition.second == 'current'
        #reset for a new round of sale
        screening.sale_began_at = nil
        screening.soldout_at = nil
      else
        screening.sale_began_at = previous_screening&.sale_began_at
        screening.soldout_at    = previous_screening&.soldout_at
      end

      screening.sale_began_at ||= Time.now.utc if transition == ['future', 'current'] || transition == [nil, 'current']
      screening.soldout_at    ||= Time.now.utc if transition == ['current', 'soldout']
      set_sales_tallies(screening, previous_screening)
    end
  end

  def set_sales_tallies(screening, previous_screening)
    return true unless screening.soldout_at.present? && previous_screening&.soldout_at.nil? && screening.sale_began_at
    screening.minutes_on_sale = (screening.minutes_on_sale || 0) + ((screening.soldout_at - screening.sale_began_at) / 60)
    screening.sale_rounds     = (screening.sale_rounds || 0) + 1
  end
end
