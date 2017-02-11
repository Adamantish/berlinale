class ScreeningsImporter
  def process
    films = []
    page = 0

    ActiveRecord::Base.transaction do
      Screening.delete_all
      loop do
        page += 1
        require 'pry'; binding.pry
        body = Scrapers::BerlinaleProgramme.new(page).data
        films = Parsers::BerlinalePage.new(body).films
        break unless films
        films.each do |film|
          Screening.create!(film)
        end
        puts "Inserting #{films.count} films"
      end
    end

    puts 'Complete!'
  end
end
