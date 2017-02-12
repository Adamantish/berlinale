require 'nokogiri'

module Normalisers
  class AbsoluteLinks
    def initialize(node, origin)
      @node = node
      @origin = origin
    end

    def process
      node = @node.dup
      node.css('a').each do |anchor|
        anchor.attributes['href'].value = "#{@origin}#{anchor.attributes['href'].value}"
      end

      node.css('img').each do |img|
        img.attributes['src'].value = "#{@origin}#{img.attributes['src'].value}"
      end

      node
    end

    private

    def absolutify(element, attribute)
      original_value = element.attributes[attribute].value
      unless original_value[0..3] == 'http'
        element.attributes[attribute].value = "#{@origin}#{original_value}"
      end
    end
  end
end

      origin = Scrapers::BerlinaleProgramme::ORIGIN
      Screening.all.each do |screen|
        node = Nokogiri::HTML(screen.html_row)
        new_node = Normalisers::AbsoluteLinks.new(node, origin).process
        screen.update!(html_row: new_node.to_html)
      end
