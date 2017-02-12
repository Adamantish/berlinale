class HomeController < ApplicationController

  include ApplicationHelper
  def index
    @screenings = Screening.order(:starts_at)
    @date_groups = @screenings.all.to_a.group_by(&:date_heading)
    begin
      count = Screening.uniq.count(:page_url)
      Request.create(remote_ip: request.remote_ip, kind: :visitor, movie_count: count)
    rescue ActiveRecord::StatementInvalid
    end
  end
end
