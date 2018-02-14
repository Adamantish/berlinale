class AddEventTimesToFilms < ActiveRecord::Migration
  def change
    add_column :films, :average_sellout_minutes, :integer, index: true

    add_column :screenings, :sale_began_at, :datetime
    add_column :screenings, :soldout_at, :datetime
  end
end
