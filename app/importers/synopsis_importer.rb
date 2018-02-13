class SynopsisImporter
  def process
    films = Film.where(synopsis: nil)
    film_count = films.count
    films.each do |film|
      body = Scrapers::Synopsis.new(film.synopsis_id).data
      synopsis = simple_parse_synopsis(body)
      film.update!(synopsis: synopsis)
    end

    p "#{film_count} synopses imported"
  end

  private

  def simple_parse_synopsis(body)
    Nokogiri::HTML(body).inner_text
  end
end