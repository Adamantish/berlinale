class HomeController < ApplicationController

  include ApplicationHelper
  def index
    @screenings = Screening.order(:title)
  end
end
