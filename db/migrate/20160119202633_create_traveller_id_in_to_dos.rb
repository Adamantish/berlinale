class CreateTravellerIdInToDos < ActiveRecord::Migration
  def change
    add_column :to_dos, :traveller_id, :integer
  end
end
