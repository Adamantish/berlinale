class ToDosController < ApplicationController

  include ApplicationHelper

  def unsynced_changes
    # If this were a heavily concurrent app I'd test for all types of change and concatenate rendered JS 
    # for all affected types. In this low traffic setting it's overkill.

    # This implementation will only action one change that's been made since last check. While the page has focus
    # and checks are every 2 seconds this should be fine in low traffic. 

    # To make this work more robustly I'd refactor to return JSON rather than JS.
    
    @new_to_do = ToDo.where("id > ?", params["latest_id"].to_i ).first if params["latest_id"]
    @edited_to_do = ToDo.where("updated_at > ?",Time.at(params["latest_update"].to_i + 1 )).first if params["latest_update"]

    if @new_to_do
      render "create.js.erb"
    elsif @edited_to_do
      render partial: 'edited'
    else
      render text: ""
    end

  end

  def latest_timestamps
    output = { latest_update: ToDo.maximum(:updated_at).to_i ,
               latest_id:     ToDo.maximum(:id) }
    render json: { timestamps: output }
  end

  def create
    @new_to_do = ToDo.create(sane_params)
    @new_to_do_json = [@new_to_do].to_json(except: %i(created_at, updated_at))
    @to_dos = []; @to_dos << @new_to_do
  end

  def edit
    @destination_options = get_select_options(Destination.all)
    @edit_or_new_to_do = ToDo.find(params["id"])
  end

  def update
    id = params["to_do"]["id"]
    @edited_to_do = ToDo.update(id, sane_params)
    render partial: 'edited'
  end

  def destroy
    ToDo.destroy(params["id"].to_i)
    render text: ""
  end

  def photos
    @to_do_id = params['id']
    @photos = ToDo.find(@to_do_id).photos
  end

  def create_like
    @to_do = ToDo.find(params["id"])
    @to_do.travellers << current_traveller
    @likes = @to_do.likes.count
    render partial: 'liked'
  end

  def delete_like
    # TODO
  end

  def search
    
    base_query = ToDo.includes(:destination).joins(:destination)
    @search_results = base_query.where("description || address || name ILIKE ?", "%#{params[:search]}%")

    @results_a = []
    @search_results.each do |obj|
      h = obj.attributes
      h["destination_name"] = obj.destination.name
      @results_a << h
    end

    @numOfSearchResults = @search_results.count == 0 ? "" : @search_results.count

    respond_to do |format|
      format.json {render json: @results_a}
      format.html do

          @edit_or_new_to_do = ToDo.new()
          @destinations = Destination.all
          @destination_options = get_select_options(@destinations)
          @to_dos = ToDo.all.includes(:likes)
          @to_dos_json = @to_dos.to_json(except: %i(id, created_at, updated_at))
          
          render 'home/index'
            
      end
    end
  end

  private

  def sane_params
     params.require(:to_do).permit(:destination_id, :description, :address)
  end


end
