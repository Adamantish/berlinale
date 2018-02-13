require_relative 'generic'

module Scrapers
  class Synopsis < Generic
    ORIGIN = 'https://www.berlinale.de'.freeze

    def initialize(film_id)
      @film_id = film_id
    end

    PER_PAGE = 250

    protected

    def max_retries
      2
    end

    def origin
      ORIGIN
    end

    def path
      '/en/programm/berlinale_programm/Synopsis-Layer.html'
    end

    def query_hash
      {
        film_id: @film_id
      }
    end
  end
end


