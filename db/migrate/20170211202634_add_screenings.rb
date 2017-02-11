class AddScreenings < ActiveRecord::Migration
  def change
    create_table :screenings do |t|
      t.string :title, null: false
      t.string :page_url
      t.string :image_url
      t.timestamps null: false
    end
  end
end
