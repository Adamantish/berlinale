class DropAllTables < ActiveRecord::Migration
  def up
    drop_table :destinations
    drop_table :likes
    drop_table :to_dos
    drop_table :travellers
  end

  def down
    raise IrreversibleMigration
  end
end
