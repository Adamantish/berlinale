class AddSaleRoundsToScreenings < ActiveRecord::Migration
  def change
    add_column :screenings, :sale_rounds, :integer
  end
end
