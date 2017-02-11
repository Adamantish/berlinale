class HomeController < ApplicationController

  TEST_EMAIL = "test@test.com"

  include ApplicationHelper

  def index

    login_as_test unless current_traveller || session["stay_logged_out"] == "Y"

    traveller_id = current_traveller.id if current_traveller
    traveller_id ||= 0
    
    @edit_or_new_to_do = ToDo.new()
    @destinations = Destination.all
    @destination_options = get_select_options(Destination.all)
    @to_dos = ToDo.includes(:likes, :destination).where("traveller_id = ?", traveller_id)
    @to_dos_json = to_dos_json( @to_dos )
 
  end

private
  
  def login_as_test
    user = Traveller.where("email = ?", TEST_EMAIL).first
    sign_in user
  end

end