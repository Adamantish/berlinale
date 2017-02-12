require 'nokogiri'

class Screening < ActiveRecord::Base
  def node
    Nokogiri::HTML(html_row)
  end
end
