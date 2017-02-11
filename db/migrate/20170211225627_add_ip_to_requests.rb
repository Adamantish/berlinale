class AddIpToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :remote_ip, :string
  end
end
