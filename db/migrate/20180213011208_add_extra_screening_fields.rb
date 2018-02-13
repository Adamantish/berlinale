class AddExtraScreeningFields < ActiveRecord::Migration
  def change
    add_column :screenings, :subtitles, :string, array: true, default: []
  end
end
