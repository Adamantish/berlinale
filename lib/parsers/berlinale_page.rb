require 'nokogiri'

module Parsers
  class BerlinalePage
    CSS_LOCATORS = {
      ticket_icon:        'a.sprite.tickets_N',
      future_ticket_icon: 'span.sprite.tickets_I',
      never_ticket_icon: 'span.sprite.tickets_Never',
      film_row:           'table.programmeTable > tbody > tr',
      film_row_detail_link: 'td.title a',
      date: '.date',
      time_berlin: '.time',
      cinema: '.venue'
    }.freeze

    def initialize(body)
      @body = body
   end

    def screenings
      return nil if all_film_rows.empty?
      ticket_icons.map do |icon|
        screening_hash(icon)
      end
    end

    private

    attr_reader :body

    def document
      Nokogiri::HTML(body)
    end

    # TODO: Switch this for an array of screening rows
    def ticket_icons
      find_all(document, :future_ticket_icon) + find_all(document, :ticket_icon) + find_all(document, :never_ticket_icon) 
    end

    def all_film_rows
      @_all_film_rows ||= find_all(document, :film_row).to_a
    end

    def find_all(within_node, locator)
      within_node.css(CSS_LOCATORS[locator])
    end

    def screening_parent_row(ticket_icon)
      ticket_icon.parent.parent.parent.parent.parent
    end

    def screening_row(ticket_icon)
      ticket_icon.parent.parent
    end

    def title_row(screening_parent_row)
      row = screening_parent_row
      # Rubocop doesn't like this but I'd argue it's clearer than a single line version of the while.
      # The single line version looks as if it will return but in fact this return nil which is why row is called on the last line.
      while find_all(row, :film_row_detail_link).empty?
        row = row.next_sibling
      end
      row
    end

    def ticket_status(ticket_icon)
      # Acch repeating myself but rushing now
      lookup = { 'tickets_I' => 'future', 'tickets_N' => 'current', 'tickets_Never' => 'never' }
      icon_class = ticket_icon.attributes['class'].value.match(/\btickets_.+/).to_s.strip
      lookup[icon_class]
    end

    def screening_hash(ticket_icon)
      screening_row_parser = Parsers::ScreeningRow.new(screening_row(ticket_icon))
      origin = Scrapers::BerlinaleProgramme::ORIGIN
      title_row = title_row(screening_parent_row(ticket_icon))
      title_row = ::Normalisers::AbsoluteLinks.new(title_row, origin).process
      link = find_all(title_row, :film_row_detail_link)[0]

      { title: link.children.first.inner_html,
        page_url: link.attributes['href'].value,
        # html_row: title_row.to_html,
        starts_at: screening_row_parser.starts_at,
        cinema: screening_row_parser.cinema,
        ticket_status: ticket_status(ticket_icon) }
    end
  end
end
