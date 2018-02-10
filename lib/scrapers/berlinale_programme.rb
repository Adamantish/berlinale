require_relative 'generic'

module Scrapers
  class BerlinaleProgramme < Generic
    ORIGIN = 'https://www.berlinale.de'.freeze

    def initialize(page)
      super(page)
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
      '/en/programm/berlinale_programm/programmsuche.php'
    end

    def query_hash
      {
        page: page
      }
    end
  end
end
