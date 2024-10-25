class SportsCenter < ApplicationRecord
    belongs_to :owner, class_name: 'Partner', foreign_key: 'owner_id'
    has_many :partners_sports_centers
    has_many :managers, through: :partners_sports_centers, source: :partner
    has_many :fields, dependent: :destroy
end
