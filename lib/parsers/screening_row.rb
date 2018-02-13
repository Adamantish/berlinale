require 'nokogiri'
require 'active_support/core_ext/string/conversions'
require_relative 'berlinale_page'

module Parsers
  class ScreeningRow
    CSS_LOCATORS = Parsers::BerlinalePage::CSS_LOCATORS

    def initialize(row_node)
      @row_node = row_node
    end

    def starts_at
      date = find_all(row_node, :date).inner_text
      time = find_all(row_node, :time_berlin).inner_text
      "#{date} 2018 #{time} +0100".to_time
    end

    def cinema
      find_all(row_node, :cinema).inner_text
    end

    private

    attr_reader :row_node

    def find_all(within_node, locator)
      within_node.css(CSS_LOCATORS[locator])
    end
  end
end
