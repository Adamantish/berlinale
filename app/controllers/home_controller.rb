class HomeController < ApplicationController

  include ApplicationHelper
  def index
    @do_hot_sellers = params[:hot_sellers] == 'true'
    @screenings = filtered_scope
    @future_screening_count = Screening.future.count
    @future_film_count = Screening.future.select(:film_id).uniq.count
    @date_groups = @screenings.to_a.group_by(&:date_heading)
    @hot_sellers_url = hot_sellers_url

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
    scope = hot_sellers_scope(scope) if @do_hot_sellers
    scope
  end

  def hot_sellers_scope(scope)
    fast_selling_film_ids = Film.where('average_sellout_minutes < 120').ids
    scope.where(film_id: fast_selling_film_ids)
  end
  
  def status_scope(scope)
    status = params['status'] || 'current'
    scope.where(ticket_status: status)
  end

  def hot_sellers_url
    if @do_hot_sellers
      params.delete(:hot_sellers)
    else
      params[:hot_sellers] = 'true'
    end
    # params = params.except(:action, :controller)
    "#{request.path}?#{params.to_query}"
  end
end
