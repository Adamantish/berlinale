require 'nokogiri'

class Screening < ActiveRecord::Base
  CSS_LOCATORS = Parsers::BerlinalePage::CSS_LOCATORS

  before_save :update_from_html, if: proc { |screening| screening.html_row_changed? }

  def film_node
    # memoize here to prevent unnecessary de-serializations when working with the model
    @film_node ||= Nokogiri::HTML(html_row)
  end

  def film_node=(film_row_node)
    @film_node = film_row_node.to_html
    self.html_row = @film_node
  end


  def screening_node
    # TODO: Making this quiet and fault tolerant till it's fully figured out.
    nodes = find_all(film_node, :ticket_icon)[0].try(:parent)
    return unless nodes
    nodes = nodes.try(:parent)
    return unless nodes
    nodes.css('td.screeningItem')[0]
  end

  # ---- Presentation decorators -----
  def date_heading
    date = starts_at.try(:to_date)
    return 'Scheiße! I can\'t tell when ¯\_(ツ)_/¯' unless date.is_a? Date
    date.strftime('%A %d')
  end


  def berlin_time_text
    time = starts_at.try(:getlocal, '+01:00')
    time.try(:strftime, '%H:%M')
  end

  private

  def find_all(within_node, locator)
    within_node.css(CSS_LOCATORS[locator])
  end

  def update_from_html
    update_starts_at_from_html
  end

  def update_starts_at_from_html
    return unless screening_node
    date = find_all(screening_node, :date).inner_html
    time = find_all(screening_node, :time_berlin).inner_html
    self.starts_at = "#{date} 2017 #{time} +0100".to_time
  end
end
