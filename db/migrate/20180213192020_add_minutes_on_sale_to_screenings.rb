class AddMinutesOnSaleToScreenings < ActiveRecord::Migration
  def change
    add_column :screenings, :minutes_on_sale, :integer
  end
end
