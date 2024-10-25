class AddOwnerIdToSportsCenters < ActiveRecord::Migration[6.1]
  def change
    add_column :sports_centers, :owner_id, :integer
    add_index :sports_centers, :owner_id
  end
end
