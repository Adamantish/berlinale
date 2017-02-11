class AddIndexToRequest < ActiveRecord::Migration
  def change
    add_index :requests, :remote_ip
  end
end
