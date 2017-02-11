require 'nokogiri'

module Parsers
  class BerlinalePage
    def initialize(body)
      @body = body
    end

    private

    def document
      Nokogiri::HTML(body)
    end

    def film_row_nodes
      films = document.css('table.programmeTable > tbody > tr')
      films.reject do |film|
        film.css('a.sprite.tickets_N').empty?
      end
    end

    attr_reader :body
  end
end
