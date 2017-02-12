require 'nokogiri'

module Normalisers
  class AbsoluteLinks
    def initialize(node, origin)
      @node = node
      @origin = origin
    end

    def process
      # TODO: Turn this off for now until it's fixed
      @node
      # node = @node.dup
      # node.css('a').each do |anchor|
      #   absolutify(anchor, 'a')
      # end

      # node.css('img').each do |img|
      #   absolutify(img, 'img')
      # end

      # node
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

      # origin = Scrapers::BerlinaleProgramme::ORIGIN
      # Screening.all.each do |screen|
      #   node = Nokogiri::HTML(screen.html_row)
      #   new_node = Normalisers::AbsoluteLinks.new(node, origin).process
      #   screen.update!(html_row: new_node.to_html)
      # end
