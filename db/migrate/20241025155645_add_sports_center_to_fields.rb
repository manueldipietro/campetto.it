class AddSportsCenterToFields < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:fields, :sports_center_id)
      add_reference :fields, :sports_center, null: false, foreign_key: true
    end
  end
end
