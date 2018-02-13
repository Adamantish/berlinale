class HomeController < ApplicationController

  include ApplicationHelper
  def index
    @screenings = filtered_scope
    @future_screening_count = Screening.future.count
    @future_film_count = Screening.future.select(:film_id).uniq.count
    @date_groups = @screenings.to_a.group_by(&:date_heading)
    begin
      count = @screenings.uniq.count(:page_url)
      Request.create(remote_ip: request.remote_ip, kind: :visitor, movie_count: count)
    rescue ActiveRecord::StatementInvalid
    end
  end

  private

  def filtered_scope
    scope = @screenings = Screening.order(:starts_at)
    scope = status_scope(scope).eager_load(:film)
  end

  def status_scope(scope)
    status = params['status'] || 'current'
    scope.where(ticket_status: status)
  end
end
