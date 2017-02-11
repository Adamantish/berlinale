class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.string :description
      t.string :address
      t.string :string
      t.integer :destination_id

      t.timestamps null: false
    end
  end
end
