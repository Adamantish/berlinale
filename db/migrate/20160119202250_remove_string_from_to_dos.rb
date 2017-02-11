class RemoveStringFromToDos < ActiveRecord::Migration
  def change
  	remove_column :to_dos, :string
  end
end
