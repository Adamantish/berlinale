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

    def document
      Nokogiri::HTML(body)
    end

    def all_film_rows
      @_all_film_rows ||= document.css('table.programmeTable > tbody > tr')
    end

    def key_row_indices
      @_key_row_indices ||= [].tap do |indices|
        all_film_rows.each_with_index do |film, i|
          indices << i unless film.css('a.sprite.tickets_N').empty?
        end
      end
    end

    def title_row_nodes
      link_row_indices = key_row_indices.map { |i| i + 1 } # move to next row
      all_film_rows.to_a.values_at(*link_row_indices)
    end

    def title_and_link(film_row_node)
      link = film_row_node.css('a')[0]
      { title: link.children.first.inner_html,
        detail_path: link.attributes['href'].value }
    end

    attr_reader :body
  end
end
