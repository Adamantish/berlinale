class CreateFilms < ActiveRecord::Migration
 def change
    create_table :films do |t|
      t.string :title
      t.integer :synopsis_id
      t.text :synopsis
      t.text :languages, array: true, default: []
      t.timestamps null: false
    end

    add_reference :screenings, :film, index: true

    add_index :films, :title
  end
end
