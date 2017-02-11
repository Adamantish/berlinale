class AddLatLngToToDos < ActiveRecord::Migration
  def change
    add_column :to_dos, :lat, :decimal
    add_column :to_dos, :lng, :decimal
  end
end
