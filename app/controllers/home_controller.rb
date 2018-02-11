class HomeController < ApplicationController

  include ApplicationHelper
  def index
    @screenings = filtered_scope
    @film_count = @screenings.uniq.count(:page_url)
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
    scope = status_scope(scope)
  end

  def status_scope(scope)
    return scope # until we have migration done
    status = params['status'] || 'current'
    scope.where(ticket_status: status)
  end
end
