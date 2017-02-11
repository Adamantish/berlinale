require_relative 'generic'

module Scrapers
  class BerlinaleProgramme < Generic
    def initialize(page)
      super(page)
    end

    PER_PAGE = 250

    protected

    def max_retries
      1
    end

    def origin
      'http://www.berlinale.de'
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
