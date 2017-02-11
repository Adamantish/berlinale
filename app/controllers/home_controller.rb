class HomeController < ApplicationController

  include ApplicationHelper

  # @@index_setup = lambda { @todo = ToDo.new()
  #   @destination_options = get_select_options(Destination.all)
  #   # @destination_options.unshift(["",0])
  #   @to_dos = ToDo.all.includes(:likes)
  #   @to_dos_json = @to_dos.to_json(except: %i(id, created_at, updated_at))
  # }

  def index

    @edit_or_new_to_do = ToDo.new()
    @destinations = Destination.all
    @destination_options = get_select_options(@destinations)
    @to_dos = ToDo.all.includes(:likes, :destination)
    @to_dos_json = to_dos_json( @to_dos )
 
  end


end