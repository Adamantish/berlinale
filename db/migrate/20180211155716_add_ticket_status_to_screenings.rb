class AddTicketStatusToScreenings < ActiveRecord::Migration
  def change
    add_column :screenings, :ticket_status, :string
    add_index :screenings, :ticket_status
  end
end
