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
        absolutify(anchor, 'href')
      end

      node.css('img').each do |img|
        absolutify(img, 'src')
      end
      node
      # @node
    end

    private

    def absolutify(element, attribute)
      original_value = element.attributes[attribute].value
      unless original_value.starts_with? 'http'
        element.attributes[attribute].value = "#{@origin}#{original_value}"
      end
    end
  end
end

      # origin = Scrapers::BerlinaleProgramme::ORIGIN
      # Screening.all.each do |screen|
      #   node = Nokogiri::HTML(screen.html_row)
      #   new_node = Normalisers::AbsoluteLinks.new(node, origin).process
      #   screen.update!(html_row: new_node.to_html)
      # end
