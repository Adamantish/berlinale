class AddIndexesToScreenings < ActiveRecord::Migration
  def change
    add_index :screenings, :film_id
    add_index :films, :languages
  end
end
