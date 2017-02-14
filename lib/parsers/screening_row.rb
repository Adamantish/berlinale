require 'nokogiri'
require 'active_support/core_ext/string/conversions'

module Parsers
  class ScreeningRow
    CSS_LOCATORS = Parsers::BerlinalePage::CSS_LOCATORS

    def initialize(row_node)
      @row_node = row_node
    end

    def starts_at
      date = find_all(row_node, :date).inner_html
      time = find_all(row_node, :time_berlin).inner_html
      "#{date} 2017 #{time} +0100".to_time
    end

    private

    attr_reader :row_node

    def find_all(within_node, locator)
      within_node.css(CSS_LOCATORS[locator])
    end
  end
end
