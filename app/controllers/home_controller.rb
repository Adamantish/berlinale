class HomeController < ApplicationController

  include ApplicationHelper

  before_action :set_current_params

  def index
    @screenings = filtered_scope
    # @future_screening_count = Screening.future.count
    # @future_film_count = Screening.future.select(:film_id).uniq.count
    @date_groups = @screenings.to_a.group_by(&:date_heading)
    
    set_hot_sellers_url
    set_now_url
    set_future_url

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
    scope.where(ticket_status: @ticket_status_filter)
  end

  def url_for(params_copy)
    "#{request.path}?#{params_copy.to_query}"
  end

  def set_hot_sellers_url
    params_copy = @current_params.dup
    if @do_hot_sellers
      params_copy.delete(:hot_sellers)
    else
      params_copy[:hot_sellers] = 'true'
    end
    @hot_sellers_url = url_for(params_copy)
  end

  def set_now_url
    params_copy = @current_params.dup
    params_copy.delete(:status)
    @now_url = url_for(params_copy)
  end

  def set_future_url
    params_copy = @current_params.dup
    params_copy[:status] = 'future'
    @future_url = url_for(params_copy)
  end

  def set_current_params
    @current_params = params.except('action', 'controller')
    @do_hot_sellers = params[:hot_sellers] == 'true'
    @ticket_status_filter = params['status'] || 'current'
  end
end
