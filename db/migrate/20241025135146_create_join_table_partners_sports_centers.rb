class CreateJoinTablePartnersSportsCenters < ActiveRecord::Migration[6.1]
  def change
    create_join_table :partners, :sports_centers do |t|
      t.index [:partner_id, :sports_center_id], name: 'index_partners_centers_on_partner_center'
      t.index [:sports_center_id, :partner_id], name: 'index_centers_partners_on_center_partner'
    end
  end
end

