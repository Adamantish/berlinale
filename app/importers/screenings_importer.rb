class ScreeningsImporter
  def process
    page = 0

    ActiveRecord::Base.transaction do
      Screening.delete_all
      loop do
        page += 1
        body = Scrapers::BerlinaleProgramme.new(page).data
        screenings = Parsers::BerlinalePage.new(body).screenings
        break unless screenings
        screenings.each do |screening|
          Screening.create!(screening)
        end
        puts "Inserting #{screenings.count} screenings"
      end
    end

    puts 'Complete!'
  end
end
