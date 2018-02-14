class AddMinutesIndexToScreenings < ActiveRecord::Migration
  def change
    add_index :films, :average_sellout_minutes
  end
end
