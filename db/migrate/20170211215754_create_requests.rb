class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :kind
      t.integer :movie_count

      t.timestamps null: false
    end
  end
end
