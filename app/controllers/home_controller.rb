class HomeController < ApplicationController

  include ApplicationHelper
  def index
    @screenings = Screening.order(:title)

    begin
      count = Screening.uniq.count(:page_url)
      Request.create(kind: :visitor, movie_count: count)
    rescue ActiveRecord::StatementInvalid
    end
  end
end
