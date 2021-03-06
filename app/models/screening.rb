require 'nokogiri'

class Screening < ActiveRecord::Base
  CSS_LOCATORS = Parsers::BerlinalePage::CSS_LOCATORS

  belongs_to :film
  
  scope :current, -> { where(ticket_status: 'current') }
  scope :future, -> { where(ticket_status: 'future') }
  scope :soldout, -> { where(ticket_status: 'soldout') }
  scope :sales_recorded, -> { where.not(sale_rounds: nil) }
  
  before_save :repair_missing_tallies

  def film_node
    # memoize here to prevent unnecessary de-serializations when working with the model
    @film_node ||= Nokogiri::HTML(html_row)
  end

  def film_node=(film_row_node)
    @film_node = film_row_node.to_html
    self.html_row = @film_node
  end

  def calc_minutes_on_sale
    return (minutes_on_sale || 0) unless should_calc_current_sale_metrics?
    (minutes_on_sale || 0) + calc_on_sale_minutes
  end

  def calc_sale_rounds
    return (sale_rounds || 0) unless should_calc_current_sale_metrics?
    (sale_rounds || 0) + 1
  end

  def calc_average_sale_duration
    return 0 unless calc_minutes_on_sale > 0 && calc_sale_rounds > 0
    calc_minutes_on_sale.to_f / calc_sale_rounds
  end

  def should_calc_current_sale_metrics?
    sale_began_at && !soldout_at
  end

  def screening_node
    # TODO: Making this quiet and fault tolerant till it's fully figured out.
    nodes = find_all(film_node, :future_ticket_icon)[0].try(:parent)
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

  def identifier
    "#{film_id}|#{cinema}|#{starts_at}"
  end

  def find_all(within_node, locator)
    within_node.css(CSS_LOCATORS[locator])
  end

  # -------- Finders -----------

  def film_row_detail_link
    # De-serialized node seems to come wrapped in extra stuff which sometimes prevents this working.
    find_all(film_node, :film_row_detail_link)[0]
  end

  # ----------------------------
  private

  def repair_missing_tallies
    self.sale_rounds = 1 if minutes_on_sale.present?
    return true unless sale_began_at && soldout_at && !minutes_on_sale.present?
    self.minutes_on_sale = calc_on_sale_minutes
  end

  def calc_on_sale_minutes
    return 0 unless sale_began_at
    uptil = soldout_at || Time.now.utc
    ((uptil - sale_began_at) / 60).to_i
  end
end
