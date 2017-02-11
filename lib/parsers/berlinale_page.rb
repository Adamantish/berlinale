require 'nokogiri'

module Parsers
  class BerlinalePage
    def initialize(body)
      @body = body
    end

    def films
      title_row_nodes.map do |row_node|
        title_and_link(row_node)
      end
    end

    private

    attr_reader :body

    def document
      Nokogiri::HTML(body)
    end

    def all_film_rows
      @_all_film_rows ||= document.css('table.programmeTable > tbody > tr').to_a
    end

    def key_row_indices
      @_key_row_indices ||= [].tap do |indices|
        all_film_rows.each_with_index do |film, i|
          indices << i unless film.css('a.sprite.tickets_N').empty?
        end
      end
    end

    def title_row_nodes
      link_row_indices = key_row_indices.map do |i|
        if !all_film_rows[i].css('td.title a').empty?
          i
        elsif !all_film_rows[i + 1].css('td.title a').empty?
          i + 1
        end
      end

      all_film_rows.values_at(*link_row_indices)
    end

    def title_and_link(film_row_node)
      link = film_row_node.css('td.title a')[0]
      { title: link.children.first.inner_html,
        detail_path: "#{Scrapers::BerlinaleProgramme::ORIGIN}link.attributes['href'].value" }
    end
  end
end
