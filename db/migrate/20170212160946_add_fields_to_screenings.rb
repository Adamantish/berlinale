class AddFieldsToScreenings < ActiveRecord::Migration
  def change
    add_column :screenings, :buy_url, :string
    add_column :screenings, :cinema, :string
    add_column :screenings, :starts_at, :datetime, index: true
  end
end
