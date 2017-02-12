class AddHtmlRowToScreenings < ActiveRecord::Migration
  def change
    add_column :screenings, :html_row, :string
  end
end
