require 'nokogiri'

class ScreeningsImporter
  def process
    page = 0

    ActiveRecord::Base.transaction do
      Screening.delete_all
      loop do
        page += 1
        body = Scrapers::BerlinaleProgramme.new(page).data
        results = Parsers::BerlinalePage.new(body).results
        break unless results
        results.each do |result| 
          film = Film.find_or_create_by(result[:film])
          Screening.create!(result[:screening].merge(film_id: film.id))
        end
        puts "Inserting #{results.count} screenings"
      end
    end

    puts 'Complete!'
  end
end
