class Field < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one_attached :image
  has_many :slots, dependent: :destroy

  after_create :create_slots

  private

  def create_slots
    Slot.generate_slots(self)
  end
end

