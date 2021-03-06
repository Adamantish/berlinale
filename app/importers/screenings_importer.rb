require 'nokogiri'

# --- Yeah this should be in a separate file really but hey it's tiny
class StateTransition
  def initialize(from:, to:)
    @tuple = [from, to]
  end

  def moves_from?(state)
    @tuple[0] == state && @tuple[1] != state
  end

  def moves_to?(state)
    @tuple[0] != state && @tuple[1] == state
  end
end

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
        break unless results.present?
        results.each do |result| 
          film = Film.find_or_create_by(result[:film])
          provide_screening(result[:screening], film).save!
        end
        puts "Inserting #{results.count} screenings"
      end
      retain_deleted
    end

    puts 'Complete!'
  end

  private

  def get_the_previous
    @the_previous ||= {}.tap do |hsh|
      Screening.all.to_a.each do |screening|
        hsh[screening.identifier] = screening
      end
    end
  end

  def provide_screening(screening_hash, film)
    Screening.new(screening_hash.merge(film_id: film.id)).tap do |screening|
      previous_screening = @the_previous.delete(screening.identifier)
      screening.sale_began_at = nil
      screening.soldout_at = nil

      transition = StateTransition.new(from: previous_screening ? previous_screening.ticket_status : nil, to: screening.ticket_status)
      if previous_screening
        screening.minutes_on_sale = previous_screening.minutes_on_sale
        screening.sale_rounds     = previous_screening.sale_rounds

        unless transition.moves_to?('current')
          screening.sale_began_at = previous_screening.sale_began_at
          screening.soldout_at    = previous_screening.soldout_at
        end
      end

      screening.sale_began_at = screening.sale_began_at || Time.now.utc if transition.moves_to?('current')
      screening.soldout_at    = screening.soldout_at || Time.now.utc if transition.moves_from?('current')
      screening = set_sales_tallies(screening, previous_screening)
    end
  end

  def set_sales_tallies(screening, previous_screening)
    return true unless screening.soldout_at.present? && screening.sale_began_at && previous_screening && previous_screening.soldout_at.nil?
    # Note this logic is mostly repeated in the Screening class in the calc methods. Not super easy to refactor
    screening.minutes_on_sale = (previous_screening.minutes_on_sale || 0) + ((screening.soldout_at - screening.sale_began_at) / 60)
    screening.sale_rounds     = (previous_screening.sale_rounds || 0) + 1
    screening
  end

  def retain_deleted
    return unless @the_previous.values.present?
    @the_previous.values.each do |screening|
      screening.ticket_status = 'deleted'
      screening.id = nil
      screening.save!
      p "Retained deleted screening #{screening.identifier}"
    end
    p "Marked #{@the_previous.values.count} screenings deleted"
  end
end
