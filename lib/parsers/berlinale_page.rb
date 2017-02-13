require 'nokogiri'

module Parsers
  class BerlinalePage
    CSS_LOCATORS = {
      ticket_icon:        'a.sprite.tickets_N',
      future_ticket_icon: 'a.sprite.tickets_I',
      film_row:           'table.programmeTable > tbody > tr',
      film_row_detail_link: 'td.title a',
      date: '.date',
      time_berlin: '.time'
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

    def find_all(within_node, locator)
      within_node.css(CSS_LOCATORS[locator])
    end
 
    def ticket_icons
      find_all(document, :ticket_icon)
    end

    def ticket_row(ticket_icon)
      ticket_icon.parent.parent.parent.parent.parent
    end

    def map_to_title_row(ticket_row)
      ticket_row.tap do |row|
        until find_all(row, :film_row_detail_link) 
          row = row.next_sibling
        end
      end
    end

    def all_film_rows
      @_all_film_rows ||= find_all(document, :film_row).to_a
    end

    def ticket_row_indices
      @_ticket_row_indices ||= [].tap do |indices|
        all_film_rows.each_with_index do |film, i|
          indices << i unless find_all(film, :ticket_icon).empty?
        end
      end
    end

    def title_row_nodes
      # The tickets and film details are usually in the same row
      # But not when a number of short films are part of a single screening.
      # This partially takes account of that, taking only the first listed short.
      link_row_indices = ticket_row_indices.map do |i|
        if !find_all(all_film_rows[i], :film_row_detail_link).empty?
          i
        elsif !find_all(all_film_rows[i + 1], :film_row_detail_link).empty?
          i + 1
        end
      end

      all_film_rows.values_at(*link_row_indices)
    end

    def film_hash(film_row_node)
      origin = Scrapers::BerlinaleProgramme::ORIGIN
      film_row_node = ::Normalisers::AbsoluteLinks.new(film_row_node, origin).process
      link = find_all(film_row_node, :film_row_detail_link)[0]
      { title: link.children.first.inner_html,
        page_url: "#{Scrapers::BerlinaleProgramme::ORIGIN}#{link.attributes['href'].value}",
        html_row: film_row_node.to_html }
    end

    def screening_hash(ticket_icon)
      origin = Scrapers::BerlinaleProgramme::ORIGIN
      film_row = title_row_for_ticket(ticket_icon)
      film_row = ::Normalisers::AbsoluteLinks.new(film_row, origin).process
    end
  end
end
