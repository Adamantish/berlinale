require 'rails_helper'

RSpec.describe ToDosController, type: :controller do

	describe "get_changes" do

		it "returns the 'created' js template if a todo was created in the last refresh period" do
			sane_params({thing: "ching"})
		end

		it "returns nothing if a todo was created slightly longer ago than the refresh period" do

		end
	end	

end
