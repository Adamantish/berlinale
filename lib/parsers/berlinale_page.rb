require 'nokogiri'

module Parsers
  class BerlinalePage
    CSS_LOCATORS = {
      ticket_icon:        'a.sprite.tickets_N',
      future_ticket_icon: 'a.sprite.tickets_I',
      film_row:           'table.programmeTable > tbody > tr',
      film_link:          'td.title a'
    }.freeze

    def initialize(body)
      @body = body
    end

    def films
      return nil if all_film_rows.empty?
      title_row_nodes.map do |row_node|
        film_hash(row_node)
      end
    end

    private

    attr_reader :body

    def document
      Nokogiri::HTML(body)
    end

    def locate(within_node, locator)
      within_node.css(CSS_LOCATORS[locator])
    end

    def all_film_rows
      @_all_film_rows ||= locate(document, :film_row).to_a
    end

    def ticket_row_indices
      @_ticket_row_indices ||= [].tap do |indices|
        all_film_rows.each_with_index do |film, i|
          indices << i unless locate(film, :ticket_icon).empty?
        end
      end
    end

    def title_row_nodes
      # The tickets and film details are usually in the same row
      # But not when a number of short films are part of a single screening.
      # This partially takes account of that, taking only the first listed short.
      link_row_indices = ticket_row_indices.map do |i|
        if !locate(all_film_rows[i], :film_row_link).empty?
          i
        elsif !locate(all_film_rows[i + 1], :film_row_link).empty?
          i + 1
        end
      end

      all_film_rows.values_at(*link_row_indices)
    end

    def film_hash(film_row_node)
      origin = Scrapers::BerlinaleProgramme::ORIGIN
      film_row_node = Normalisers::AbsoluteLinks.new(film_row_node, origin).process
      link = locate(film_row_node, :film_row_link)[0]
      { title: link.children.first.inner_html,
        page_url: "#{Scrapers::BerlinaleProgramme::ORIGIN}#{link.attributes['href'].value}",
        html_row: film_row_node.to_html }
    end
  end
end
