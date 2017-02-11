class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :traveller_id
      t.integer :to_do_id

      t.timestamps null: false
    end
  end
end
