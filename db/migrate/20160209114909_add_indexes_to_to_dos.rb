class AddIndexesToToDos < ActiveRecord::Migration[5.0]
  def change
  	add_index :to_dos, :updated_at, using: :btree
  	add_index :to_dos, :traveller_id, using: :btree
  end
end
