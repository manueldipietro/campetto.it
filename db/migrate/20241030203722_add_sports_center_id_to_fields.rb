class AddSportsCenterIdToFields < ActiveRecord::Migration[6.1]
  def change
    add_column :fields, :sports_center_id, :integer
  end
end
